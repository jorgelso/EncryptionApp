//
//  PasswordsView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData
import CryptoKit

struct PasswordsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var data: [PasswordModel]
    // list of persisted Keychain items
    @State private var items: [SensitiveDataModel] = []
    @ObservedObject var faceDetector: FaceDetector
    
    
    //@State private var selected: PasswordModel? = nil
    @State private var selected: CombinedData? = nil
    @State private var addPassword = false
    
    @State private var decryptedCreds: SensitiveDataModel?
    private let key = SymmetricKey(size: .bits256)
    let store = KeychainHelper.shared
    
    private let headerFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f
    }()
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            if faceDetector.numberOfFaces > 1 {
                VStack {
                    Text("Sensitive Data encrypted")
                        .bold()
                        .font(.title)
                    Text("Only one person can see your screen at a time")
                        .padding()
                }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Button { addPassword = true } label: {
                            Image(systemName: "plus")
                                .padding(.vertical, 5)
                                .foregroundStyle(Color.background)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.main)
                        .sheet(isPresented: $addPassword) {
                            CreatePasswordView(items: $items)
                        }
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(passwordsByMonth(), id: \.0) { monthStart, passwordsInMonth in
                            Section(header: Text(headerFormatter.string(from: monthStart))) {
                                ForEach(passwordsInMonth) { password in
                                    let rowColor: Color = password.colorFromAsset
                                    let detail: String = {
                                        if let e = password.maskedEmail, !e.isEmpty { return e }
                                        if let u = password.maskedUsername, !u.isEmpty { return u }
                                        return ""
                                    }()
                                    
                                    Button {
                                        //selected = password
                                        Task {
                                            do {
                                                let creds = try store.load(id: password.id)
                                                let combined = CombinedData(meta: password, creds: creds)
                                                await MainActor.run {
                                                    selected = combined
                                                    //isPresenting = true
                                                }
                                            } catch { print("Error loading credentials: \(error)") }
                                        }
                                    } label: {
                                        PasswordRowView(
                                            title: password.title,
                                            color: rowColor,
                                            detail: detail
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .listRowBackground(Color.clear)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .sheet(item: $selected) { _ in
                        // Create a proper binding that reads/writes to $selected
                        if let selectedValue = selected {
                            PasswordView(
                                data: Binding(
                                    get: { selectedValue },
                                    set: { selected = $0 }
                                ), items: $items
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func passwordsByMonth() -> [(Date, [PasswordModel])] {
        let cal = Calendar.current
        let groups = Dictionary(grouping: data) { m -> Date in
            let comps = cal.dateComponents([.year, .month], from: m.createdDate!)
            return cal.date(from: comps) ?? cal.startOfDay(for: m.createdDate!)
        }
        let keys = groups.keys.sorted(by: >)
        return keys.map { key in
            (key, (groups[key] ?? []).sorted { $0.createdDate! > $1.createdDate! })
        }
    }
}

