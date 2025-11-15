//
//  SecPassApp.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData

@main
struct SecPassApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PasswordModel.self)
    }
}
