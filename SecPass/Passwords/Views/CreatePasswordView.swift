//
//  CreatePasswordView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData
import CryptoKit
import UIKit

struct CreatePasswordView: View {
    //@State var data = PasswordModel(title: "", password: "")
    @State private var id = UUID()
    @State private var data: CombinedData
    @State private var errorText: String?
    // list of persisted Keychain items
    @Binding var items: [SensitiveDataModel]
    
    init(items: Binding<[SensitiveDataModel]>) {
        self._items = items
        let id = UUID()
        _data = State(initialValue:
                        CombinedData(
                            meta: PasswordModel(id: id, title: ""),
                            creds: SensitiveDataModel(id: id)
                        )
        )
    }
    
    
    //@State var data = CombinedData(meta: PasswordModel(id: uuid, title: "", password: ""), creds: SensitiveDataModel(id: uuid))
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    
    @State var showingAlert = false
    
    let store = KeychainHelper.shared
    private func encryptAndSave(_ model: SensitiveDataModel) {
        do {
            let ids = try store.listIDs()
            if ids.contains(model.id) {
                try store.update(model)
                if let idx = items.firstIndex(where: { $0.id == model.id }) {
                    items[idx] = model
                }
            } else {
                try store.create(model)
                items.append(model)
            }
            // reset form if you want to add multiple
            //data = SensitiveDataModel()
            errorText = nil
        } catch { errorText = "\(error)" }
    }
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        //Discard
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .frame(width: 20, height: 25)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.second.opacity(0.4))
                    .foregroundStyle(.text)
                    Spacer()
                    
                    Button {
                        //Save data
                        if data.title != "" {
                            //viewModel.append(data)
                            //Save metadata
                            //modelContext.insert(data)
                            modelContext.insert(data.toMeta())
                            encryptAndSave(data.toCreds())
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    } label: {
                        Text("Create")
                            .foregroundStyle(Color.background)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.main.opacity(0.9))
                }
                .padding(.horizontal, 20)
                Text(data.title)
                    .font(.title)
                    .bold()
                //Text("Category")
                
                VStack {
                    TextFieldPasswordDataRow(
                        name: "Title",
                        value: $data.title,
                        imageName: "envelope.fill",
                        allowDete: true
                    )
                    
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
                        //value: $data.password,
                        value: Binding(
                            get: { data.password ?? "" },
                            set: { data.password = $0 }
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
                    Spacer()
                }
                if let errorText {
                    Text("ERROR: \(errorText)").foregroundStyle(.red).font(.footnote)
                }
            }
            .padding(.vertical)
            .alert("Title cannot be empty", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    showingAlert = false
                }
            } message: {
                Text("Your login data needs to have a title")
            }
        }
    }
}

/*
 #Preview {
 do {
 let config = ModelConfiguration(isStoredInMemoryOnly: true)
 let container  = try ModelContainer(for: PasswordModel.self, configurations: .config)
 let example = PasswordModel(title: "Placeholder", password: "Yes")
 return CreatePasswordView(data: example)
 .modelContainer(container)
 } catch {
 fatalError("Failed to create model")
 }
 }
 
 */
