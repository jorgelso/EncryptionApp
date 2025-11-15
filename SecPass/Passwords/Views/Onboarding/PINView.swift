//
//  PINView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI

struct PINView: View {
    @State var pin: String = ""
    @Binding var requestPin: Bool
    @State var attemptsRemaining = 3
    @State var showingAlert = false
    @State var showingExitAlert = false
    @Binding var encryptedData: Bool
    let store = KeychainHelper.shared
    
    @Binding var onboarding: Bool
    
    var body: some View {
        if !encryptedData {
            VStack (alignment: .center) {
                HStack {
                    Spacer()
                    Button{
                        showingExitAlert = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .imageScale(.large)
                    }
                }
                .alert("Log out?",
                       isPresented: $showingExitAlert,
                       actions: {
                           Button("Log out", role: .destructive) {
                               encryptedData = true
                           }
                           Button("Cancel", role: .cancel) { }
                       },
                       message: {
                           Text("Your data will be encrypted until you insert your recovery phrase")
                       }
                )
                .padding()
                Image("logo")
                .resizable()
                .frame(width: 180, height: 180)
                Text("Enter your PIN code")
                    .font(.title)
                    .padding(.top, 5)
                SecureField(text: $pin){
                    Text("PIN")
                }.keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    //.padding()
                
                //TODO: Make it so that if attemptsRemaining equals 0, the app deletes all data or encrypts or blocks UI access or something
                if attemptsRemaining < 3 {
                    Text("Attempts remaining: \(attemptsRemaining)")
                        .foregroundStyle(.accent)
                }
                
                Button {
                    Task {
                        if !pin.isEmpty {
                            if try store.verifyPIN(pin) {
                                requestPin = false
                            } else {
                                attemptsRemaining -= 1
                                if attemptsRemaining < 1 {
                                    showingAlert = true
                                }
                            }
                        }
                    }
                } label: {
                    Text("Unlock")
                        .frame(maxWidth: .infinity)
                        .font(.title3)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .disabled(attemptsRemaining <= 0)
                .padding(.top, 25)
                
                Spacer()
            }
            .bold()
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Data encrypted"),
                    message: Text("Use your verification code to unlock your data"),
                    dismissButton: .default(Text("Ok")) {
                        encryptedData = true
                    }
                )
            }
        } else {
            RecoveryView(encryptedData: $encryptedData, attemptsRemaining: $attemptsRemaining, onboarding: $onboarding)
        }
    }
}

#Preview {
    PINView(requestPin: .constant(true), encryptedData: .constant(false), onboarding: .constant(false))
}
