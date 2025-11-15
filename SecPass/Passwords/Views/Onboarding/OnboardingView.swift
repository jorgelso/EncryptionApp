//
//  OnboardingView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 06/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @State var pin: String = ""
    @Binding var firstTime: Bool
    @State var askForPin = false
    
    let store = KeychainHelper.shared
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if !askForPin {
                VStack (alignment: .center) {
                    Image("logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                    Text("Welcome to SecPass")
                        .font(.title)
                        .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Text("Your security starts here")
                            .font(.headline)
                            .padding(.top)
                    }
                    .foregroundStyle(Color.text.opacity(0.8))
                    
                    Button {
                        askForPin = true
                    } label: {
                        Text("Continue")
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
                EditPINView(firstTime: $firstTime)
            }
        }
    }
}

#Preview {
    OnboardingView(firstTime: .constant(true))
}
