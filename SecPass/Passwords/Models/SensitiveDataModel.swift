//
//  SensitiveDataModel.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 10/11/25.
//

import Foundation
import CryptoKit
import SwiftUI

struct SensitiveDataModel: Codable, Equatable, Identifiable {
    var id: UUID
    var username: String?
    var email: String?
    var password: String?
    var website: String?
    
    init(id: UUID, username: String? = nil, email: String? = nil, password: String? = nil, website: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.website = website
    }
}

extension SensitiveDataModel {
    func encrypt(using key: SymmetricKey) throws -> Data {
        let plain = try JSONEncoder().encode(self)
        let box = try AES.GCM.seal(plain, using: key)
        guard let blob = box.combined else {
            throw NSError(domain: "crypto", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing combined blob"])
        }
        return blob
    }
    static func decrypt(from data: Data, using key: SymmetricKey) throws -> SensitiveDataModel {
        let box = try AES.GCM.SealedBox(combined: data)
        let plain = try AES.GCM.open(box, using: key)
        return try JSONDecoder().decode(SensitiveDataModel.self, from: plain)
    }
}
