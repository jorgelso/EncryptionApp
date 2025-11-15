//
//  ModifyPasswordView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData

// Value snapshot for change detection
private struct PasswordSnapshot: Equatable {
    var title: String
    var username: String?
    var email: String?
    var password: String?
    var website: String?
    var createdDate: Date
    var modifiedDate: Date?
    
    init(from m: CombinedData) {
        self.title = m.title
        self.username = m.username
        self.email = m.email
        self.password = m.password
        self.website = m.website
        self.createdDate = m.createdDate
        self.modifiedDate = m.modifiedDate
    }
}

struct ModifyPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    //@Bindable var data: PasswordModel
    @Binding var data: CombinedData
    @State private var original: PasswordSnapshot
    
    /*
     // Take a model, wrap it for @Bindable, and snapshot it once
     init(data: PasswordModel) {
     self._data = Bindable(wrappedValue: data)
     self._original = State(initialValue: PasswordSnapshot(from: data))
     }
     */
    
    init(data: Binding<CombinedData>, items: Binding<[SensitiveDataModel]>) {
        self._data = data
        self._original = State(initialValue: PasswordSnapshot(from: data.wrappedValue))
        self._items = items
    }
    
    
    
    var hasChanged: Bool {
        PasswordSnapshot(from: data) != original
    }
    
    // list of persisted Keychain items
    @Binding private var items: [SensitiveDataModel]
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        // discard any unsaved edits in the context
                        modelContext.rollback()
                        dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .frame(width: 20, height: 25)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.second.opacity(0.4))
                    .foregroundStyle(.text)
                    
                    Spacer()
                    
                    Button {
                        if hasChanged {
                            data.modifiedDate = Date()
                            try? modelContext.save()
                            // refresh snapshot if the view stays alive
                            original = PasswordSnapshot(from: data)
                        }
                        dismiss()
                    } label: {
                        Text(hasChanged ? "Save" : "Discard")
                            .foregroundStyle(Color.background)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.main.opacity(0.9))
                }
                .padding(.horizontal, 20)
                
                Text(data.title)
                    .font(.title)
                    .bold()
                
                VStack {
                    TextFieldPasswordDataRow(
                        name: "Email address",
                        value: Binding(
                            get: { data.email ?? "" },
                            set: { data.email = $0 }
                        ),
                        imageName: "envelope.fill",
                        allowDete: true
                    )
                    
                    TextFieldPasswordDataRow(
                        name: "Username",
                        value: Binding(
                            get: { data.username ?? "" },
                            set: { data.username = $0 }
                        ),
                        imageName: "person.fill",
                        allowDete: true
                    )
                    
                    TextFieldPasswordDataRow(
                        name: "Password",
                        value: Binding(
                            get: { data.password ?? "" },
                            set: { data.password = $0.isEmpty ? nil : $0 }
                        ),
                        imageName: "lock.shield.fill",
                        allowDete: true
                    )
                    
                    TextFieldPasswordDataRow(
                        name: "Website",
                        value: Binding(
                            get: { data.website ?? "" },
                            set: { data.website = $0 }
                        ),
                        imageName: "paperclip",
                        allowDete: true
                    )
                    
                    TextFieldPasswordDataRow(
                        name: "Created date",
                        value: .constant(
                            data.createdDate.formatted(date: .complete, time: .shortened)
                        ),
                        imageName: "wand.and.sparkles.inverse",
                        allowDete: false
                    )
                    
                    TextFieldPasswordDataRow(
                        name: "Last modified",
                        value: .constant(
                            data.modifiedDate?.formatted(date: .complete, time: .complete) ?? "Never Modified"
                        ),
                        imageName: "pencil",
                        allowDete: false
                    )
                }
            }
        }
    }
}

/*
 #Preview {
 do {
 let cfg = ModelConfiguration(isStoredInMemoryOnly: true)
 let container = try ModelContainer(for: PasswordModel.self, configurations: cfg)
 let example = PasswordModel(title: "Placeholder", password: "Yes")
 container.mainContext.insert(example)
 return ModifyPasswordView(data: example)
 .modelContainer(container)
 } catch {
 fatalError("Failed to create model: \(error)")
 }
 }
 
 */
