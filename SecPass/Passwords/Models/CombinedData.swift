//
//  CombinedData.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 10/11/25.
//

import Foundation

struct CombinedData: Identifiable, Equatable {
    let id: UUID
    
    // Non-sensitive (SwiftData)
    var createdDate: Date
    var modifiedDate: Date?
    var title: String
    var color: String?
    
    // Sensitive (Keychain)
    var username: String?
    var email: String?
    var password: String?
    var website: String?
    
    // Build from existing models (detail/edit)
    init(meta: PasswordModel, creds: SensitiveDataModel) {
        precondition(meta.id == creds.id)
        self.id = meta.id
        self.createdDate = meta.createdDate!
        self.modifiedDate = meta.modifiedDate
        self.title = meta.title
        self.color = meta.color
        self.username = creds.username
        self.email = creds.email
        self.password = creds.password
        self.website = creds.website
    }
    
    // Build from scratch (create screen)
    init(id: UUID = UUID(),
         title: String = "",
         color: String? = nil,
         username: String? = nil,
         email: String? = nil,
         password: String? = nil,
         website: String? = nil,
         now: Date = .now) {
        self.id = id
        self.createdDate = now
        self.modifiedDate = nil
        self.title = title
        self.color = color
        self.username = username
        self.email = email
        self.password = password
        self.website = website
    }
    
    // CREATE: make a brand-new SwiftData row
    func makeMetaNew() -> PasswordModel {
        PasswordModel(
            id: id,
            createdDate: createdDate,
            modifiedDate: modifiedDate,
            title: title,
            color: color
        )
    }
    
    // UPDATE: mutate existing SwiftData row
    func writeMeta(into meta: inout PasswordModel) {
        precondition(meta.id == id)
        meta.title = title
        meta.color = color
        meta.modifiedDate = .now
        // DO NOT touch createdDate here.
    }
    
    // Split back out
    //func toMeta(_ meta: inout PasswordModel) {
    func toMeta() -> PasswordModel {
        //TODO: Fix issue with new PasswordModel being created rather than returning the same PasswordModel
        /*
         meta.id = id
         meta.createdDate = createdDate
         meta.title = title
         meta.modifiedDate = .now
         meta.color = color
         */
        PasswordModel(id: id, createdDate: createdDate, modifiedDate: modifiedDate, title: title, color: color)
    }
    func toCreds() -> SensitiveDataModel {
        SensitiveDataModel(id: id, username: username, email: email, password: password, website: website)
    }
}
