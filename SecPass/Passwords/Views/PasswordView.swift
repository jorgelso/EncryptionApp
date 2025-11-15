//
//  PasswordView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData

struct PasswordView: View {
    //@Binding var data: PasswordModel
    @Environment(\.presentationMode) var presentationMode
    @State var showModal = false
    @State private var showConfirm = false
    @Environment(\.modelContext) private var modelContext
    //@Bindable var data: PasswordModel
    @Binding var data: CombinedData
    @Binding var items: [SensitiveDataModel]
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .frame(width: 20, height: 25)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.second.opacity(0.4))
                    .foregroundStyle(.text)
                    Spacer()
                    
                    Button {
                        showModal.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "pencil.line")
                            Text("Edit")
                        }
                        .foregroundStyle(.text)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.second.opacity(0.4))
                    Button {
                        showConfirm = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(Color.text)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accent.opacity(0.7))
                    .alert("Delete this item?",
                           isPresented: $showConfirm,
                           actions: {
                        Button("Delete", role: .destructive) {
                            //Delete
                            //modelContext.delete(data)
                            modelContext.delete(data.toMeta())
                            //TODO: Delete from keychain
                            try? modelContext.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("Cancel", role: .cancel) { }
                    },
                           message: {
                        Text("Are you sure you want to delete this item?")
                    }
                    )
                }
                .padding(.horizontal, 20)
                Text(data.title)
                    .font(.title)
                    .bold()
                //Text("Category")
                
                VStack {
                    PasswordDataRow(name: "Email adress", value: data.email ?? "", imageName: "envelope.fill")
                    PasswordDataRow(name: "Username", value: data.username ?? "", imageName: "person.fill")
                    PasswordDataRow(name: "Password", value: data.password ?? "", imageName: "lock.shield.fill")
                    PasswordDataRow(name: "Website", value: data.website ?? "", imageName: "paperclip")
                    PasswordDataRow(name: "Created date", value:  data.createdDate.formatted(date: .complete, time: .shortened), imageName: "wand.and.sparkles.inverse")
                    PasswordDataRow(name: "Last modified", value: data.modifiedDate?.formatted(date: .complete, time: .complete) ?? "Never Modified", imageName: "pencil")
                }
            }
            .sheet(isPresented: $showModal) {
                ModifyPasswordView(data: $data, items: $items)
                    .interactiveDismissDisabled()
            }
        }
    }
}

/*
 #Preview {
 PasswordView(data: .constant(PasswordModel(title: "Placeholder", password: "Placeholder")))
 }
 
 */
