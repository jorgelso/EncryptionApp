//
//  PasswordModel.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class PasswordModel: Identifiable, Equatable {
    //The id needs to be the same from the Sensitive Data Model
    var id: UUID
    var createdDate: Date?
    var modifiedDate: Date?
    var title: String
    var color: String? = "second"
    var maskedUsername: String?
    var maskedEmail: String?
    //var category: String?
    
    @Transient
    var colorFromAsset: Color {
        guard let name = color else { return .gray }
        return Color(name) // looks up Color Asset
    }
    
    init(id: UUID, createdDate: Date = Date(), modifiedDate: Date? = nil, title: String, color: String? = nil, maskedUsername: String? = nil, maskedEmail: String? = nil) {
        self.id = id
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.title = title
        self.color = color
        self.maskedUsername = maskedUsername
        self.maskedEmail = maskedEmail
    }
    
    static func == (lhs: PasswordModel, rhs: PasswordModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.modifiedDate == rhs.modifiedDate
    }
}
