//
//  KeychainHelper.swift
//  testing
//
//  Created by Jorge Luis Salcedo Orozco on 07/11/25.
//

import Foundation
import Security
import CryptoKit
import CommonCrypto

enum KeychainError: Error { case os(OSStatus), bad }

struct KeychainHelper {
    static let shared = KeychainHelper()
    //private init() {}
    
    private let service = (Bundle.main.bundleIdentifier ?? "app") + ".creds"
    private let keyAccount = "crypto.masterkey"
    
    // Persist/obtain the symmetric key
    private func ensureKey() throws -> SymmetricKey {
        if let k = try? loadKey() { return k }
        let k = SymmetricKey(size: .bits256)
        try saveKey(k)
        return k
    }
    private func saveKey(_ key: SymmetricKey) throws {
        let data = key.withUnsafeBytes { Data($0) }
        try upsert(data: data, account: keyAccount, accessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    }
    private func loadKey() throws -> SymmetricKey {
        let data = try loadData(account: keyAccount)
        return SymmetricKey(data: data)
    }
    
    // CRUD
    func create(_ creds: SensitiveDataModel) throws {
        let key = try ensureKey()
        let blob = try AES.GCM.seal(JSONEncoder().encode(creds), using: key).combined!
        try add(data: blob, account: creds.id.uuidString)
    }
    
    func update(_ creds: SensitiveDataModel) throws {
        let key = try ensureKey()
        let blob = try AES.GCM.seal(JSONEncoder().encode(creds), using: key).combined!
        try update(data: blob, account: creds.id.uuidString) // same account → overwrite
    }
    
    func load(id: UUID) throws -> SensitiveDataModel {
        let key  = try ensureKey()
        let blob = try loadData(account: id.uuidString)
        let box  = try AES.GCM.SealedBox(combined: blob)
        let dec  = try AES.GCM.open(box, using: key)
        return try JSONDecoder().decode(SensitiveDataModel.self, from: dec)
    }
    
    // List all IDs (no plaintext indexing)
    func listIDs() throws -> [UUID] {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        var item: CFTypeRef?
        let s = SecItemCopyMatching(query as CFDictionary, &item)
        if s == errSecItemNotFound { return [] }
        guard s == errSecSuccess, let array = item as? [[String: Any]] else { throw KeychainError.os(s) }
        return array.compactMap { ($0[kSecAttrAccount as String] as? String).flatMap(UUID.init(uuidString:)) }
    }
    
    // --- low-level helpers ---
    private func add(data: Data, account: String,
                     accessible: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) throws {
        var q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: accessible
        ]
        let s = SecItemAdd(q as CFDictionary, nil)
        if s == errSecDuplicateItem { throw KeychainError.os(s) }
        guard s == errSecSuccess else { throw KeychainError.os(s) }
    }
    
    private func update(data: Data, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let attrs: [String: Any] = [kSecValueData as String: data]
        let s = SecItemUpdate(query as CFDictionary, attrs as CFDictionary)
        if s == errSecItemNotFound {
            try add(data: data, account: account) // upsert behavior
            return
        }
        guard s == errSecSuccess else { throw KeychainError.os(s) }
    }
    
    private func upsert(data: Data, account: String, accessible: CFString) throws {
        do { try update(data: data, account: account) }
        catch KeychainError.os(let code) where code == errSecItemNotFound {
            try add(data: data, account: account, accessible: accessible)
        }
    }
    
    private func loadData(account: String) throws -> Data {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let s = SecItemCopyMatching(q as CFDictionary, &item)
        guard s == errSecSuccess, let data = item as? Data else { throw KeychainError.os(s) }
        return data
    }
}

extension KeychainHelper {
    private var pinAccount: String { "pin.record" }
    
    func hasPIN() -> Bool {
        (try? loadData(account: pinAccount)) != nil
    }
    
    func setPIN(_ pin: String, iterations: UInt32 = 150_000) throws {
        let salt = randomBytes(16)
        let hash = try pbkdf2SHA256(password: Data(pin.utf8), salt: salt, rounds: iterations)
        let rec = PINModel(salt: salt, iterations: iterations, hash: hash, failCount: 0)
        let data = try JSONEncoder().encode(rec)
        // store as ThisDeviceOnly so it won’t sync/export; persists across launches/reinstalls on same device
        try upsert(data: data, account: pinAccount, accessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    }
    
    @discardableResult
    func verifyPIN(_ pin: String, lockoutAfter: UInt32 = 3) throws -> Bool {
        var rec = try loadPINRecord()
        let candidate = try pbkdf2SHA256(password: Data(pin.utf8), salt: rec.salt, rounds: rec.iterations)
        let ok = constantTimeEqual(candidate, rec.hash)
        if ok {
            if rec.failCount != 0 {
                rec.failCount = 0
                try savePINRecord(rec)
            }
            return true
        } else {
            rec.failCount &+= 1
            try savePINRecord(rec)
            if rec.failCount >= lockoutAfter {
                // TODO: lock or wipe data
                // try clearPIN()
            }
            return false
        }
    }
    
    func clearPIN() throws {
        //absence of keychain blob is treated as “ask to create PIN”
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: pinAccount
        ]
        let s = SecItemDelete(q as CFDictionary)
        guard s == errSecSuccess || s == errSecItemNotFound else { throw KeychainError.os(s) }
    }
    
    // MARK: - private helpers
    
    private func loadPINRecord() throws -> PINModel {
        let data = try loadData(account: pinAccount)
        return try JSONDecoder().decode(PINModel.self, from: data)
    }
    
    private func savePINRecord(_ rec: PINModel) throws {
        let data = try JSONEncoder().encode(rec)
        try upsert(data: data, account: pinAccount, accessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
    }
    
    private func randomBytes(_ n: Int) -> Data {
        var d = Data(count: n)
        _ = d.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, n, $0.baseAddress!) }
        return d
    }
    
    private func pbkdf2SHA256(password: Data, salt: Data, rounds: UInt32, outLen: Int = 32) throws -> Data {
        var dk = Data(count: outLen)
        let status = dk.withUnsafeMutableBytes { dkPtr in
            salt.withUnsafeBytes { saltPtr in
                password.withUnsafeBytes { passPtr in
                    CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                         passPtr.bindMemory(to: Int8.self).baseAddress, password.count,
                                         saltPtr.bindMemory(to: UInt8.self).baseAddress, salt.count,
                                         CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                         rounds,
                                         dkPtr.bindMemory(to: UInt8.self).baseAddress, outLen)
                }
            }
        }
        guard status == kCCSuccess else { throw KeychainError.bad }
        return dk
    }
    
    private func constantTimeEqual(_ a: Data, _ b: Data) -> Bool {
        guard a.count == b.count else { return false }
        var diff: UInt8 = 0
        for i in 0..<a.count { diff |= a[i] ^ b[i] }
        return diff == 0
    }
}
