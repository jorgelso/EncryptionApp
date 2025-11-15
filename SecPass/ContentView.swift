//
//  ContentView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var requestPin: Bool
    @State private var encryptedData: Bool
    //TODO: Change onboarding to be on the environment
    @State private var onboarding: Bool
    private let store = KeychainHelper.shared
    
    @StateObject var faceDetector = FaceDetector()
    
    init(requestPin: Bool = true, encryptedData: Bool = false) {
        _requestPin   = State(initialValue: requestPin)
        _encryptedData = State(initialValue: encryptedData)
        //_onboarding   = State(initialValue: !KeychainHelper.shared.hasPIN())
        _onboarding   = State(initialValue: !store.hasPIN())
        print(store.hasPIN())
    }
    
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            if !onboarding {
                VStack {
                    if requestPin {
                        PINView(requestPin: $requestPin, encryptedData: $encryptedData, onboarding: $onboarding)
                    } else {
                        //TODO: Add an animation for the transition
                        TabView() {
                            Tab("Passwords", systemImage: "lock.fill") {
                                PasswordsView(faceDetector: faceDetector)
                                    .onAppear {
                                        faceDetector.start()
                                    }
                                    .onDisappear {
                                        faceDetector.stop()
                                    }
                            }
                            Tab("Settings", systemImage: "gear") {
                                SettingsView()
                            }
                        }
                    }
                }
            } else {
                OnboardingView(firstTime: $onboarding)
            }
        }
    }
}

#Preview {
    ContentView()
}
