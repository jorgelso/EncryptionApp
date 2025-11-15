//
//  DeleteDataView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 05/11/25.
//

import SwiftUI

struct DeleteDataView: View {
    @State var recoveryPhrase = ""
    @Binding var encryptedData: Bool
    @Binding var onboarding: Bool
    let store = KeychainHelper.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                
                VStack (alignment: .leading) {
                    Text("Delete your data")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                        .foregroundStyle(Color.text)
                    
                    Text("We need your recovery phrase to confirm your identity")
                        .font(.title3)
                        .foregroundStyle(Color.text)
                    
                    TextField(
                        text: $recoveryPhrase,
                        prompt: Text("Recovery phrase").foregroundColor(.text.opacity(0.6))
                            .font(.headline)
                    ) {
                        Text(recoveryPhrase)
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    
                    Spacer()
                    
                    Button {
                        //TODO: un-hardcode the recovery phrase
                        if recoveryPhrase == "taco-burrito" {
                            //TODO: delete ALL data
                                //keychain, PIN, recovery phrase, SwiftData
                            Task {
                                try? store.clearPIN()
                            }
                            encryptedData.toggle()
                            onboarding.toggle()
                        }
                    } label: {
                        Text("Delete")
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 25)
                    
                    Spacer()
                    
                }
                .padding()
            }
        }
    }
}
#Preview {
    DeleteDataView(encryptedData: .constant(true), onboarding: .constant(false))
}
