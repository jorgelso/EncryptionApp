//
//  EditPINView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 06/11/25.
//

import SwiftUI

struct EditPINView: View {
    @State var pin: String = ""
    @State var confirmationPin: String = ""
    @Binding var firstTime: Bool
    @State var confirmPin = false
    @State var pinsMismatch = false
    @State var newPinSet = false
    let store = KeychainHelper.shared
    
    var body: some View {
        if !newPinSet{
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                if !confirmPin{
                    VStack (alignment: .center) {
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text("Enter your new code")
                            .font(.title)
                            .padding(.top)
                        SecureField(text: $pin){
                            Text("PIN")
                        }.keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding()
                        
                        Button {
                            if !pin.isEmpty {
                                confirmPin.toggle()
                            }
                        } label: {
                            Text("\(firstTime ? "Continue" : "Change")")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 25)
                        
                        Spacer()
                    }
                    .bold()
                    .padding()
                } else {
                    VStack (alignment: .center) {
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text("Confirm your PIN")
                            .font(.title)
                            .padding(.top)
                        SecureField(text: $confirmationPin){
                            Text("PIN")
                        }.keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .padding()
                        
                        Button {
                            if pin == confirmationPin {
                                //if firstTime {
                                    //firstTime.toggle()
                                    newPinSet = true
                                //}
                                Task {
                                    try store.setPIN(pin)
                                    //print(store.hasPIN())
                                }
                            } else {
                                pinsMismatch = true
                            }
                        } label: {
                            Text("Confirm")
                                .frame(maxWidth: .infinity)
                                .font(.title3)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 25)
                        
                        if pinsMismatch {
                            Text("The PIN codes do not match")
                                .foregroundStyle(.accent)
                        }
                        
                        Spacer()
                    }
                    .bold()
                    .padding()
                }
            }
        } else {
            NewPinSetView(firstTime: $firstTime)
        }
    }
}

#Preview {
    EditPINView(firstTime: .constant(true))
}
