//
//  RecoveryView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 04/11/25.
//

import SwiftUI

struct RecoveryView: View {
    @State var recoveryPhrase = ""
    @Binding var encryptedData: Bool
    @Binding var attemptsRemaining: Int
    @Binding var onboarding: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                VStack (alignment: .leading) {
                    Text("Data Encrypted")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                        .foregroundStyle(Color.text)
                    
                    Text("Type your recovery phrase to unlock your data")
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
                            encryptedData.toggle()
                            attemptsRemaining = 3
                        }
                    } label: {
                        Text("Unlock")
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 25)
                    
                    NavigationLink(destination: DeleteDataView(encryptedData: $encryptedData, onboarding: $onboarding)) {
                        Text("Do you wish to delete your data?")
                            .padding(.vertical)
                            .foregroundStyle(Color.accent)
                    }
                 Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        RecoveryView(encryptedData: .constant(true), attemptsRemaining: .constant(0), onboarding: .constant(false))
    }
}
