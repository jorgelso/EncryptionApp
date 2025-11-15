//
//  SettingsView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 04/11/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    
                    NavButton(destination: EditPINView(firstTime: .constant(false)), text: "Change PIN", imageText: "key.fill")
                    
                    NavButton(destination: PrivacyPolicyView(), text: "Privacy policy", imageText: "book.pages.fill")
                    
                    //TODO: Export
                    //NavButton(destination: , text: "Export", imageText: "square.and.arrow.up.fill")
                    
                    //TODO: Change recovery phrase
                    //NavButton(destination: , text: "Change recovery phrase", imageText: "key.fill")
                    
                    Spacer()
                }
                .padding()
                .foregroundStyle(Color.text)
            }
        }
    }
    
}


#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        SettingsView()
    }
}
