//
//  PrivacyPolicyView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 13/11/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Privacy Policy")
                        .font(.largeTitle).bold()
                    
                    Text("""
    Effective Date: November 13, 2025
    
    This Privacy Policy describes how SecPass handles your information. SecPass is designed as a local-only password manager with an optional on-device security feature that uses the device camera to detect the presence of additional faces and temporarily conceal sensitive information. The App does not transmit, store, or process any personal data outside of your device.
    """)
                    
                    Text("1. Information We Collect")
                        .font(.title3).bold()
                    
                    Text("""
    The App does not collect, store, transmit, or share any personal data. All operations occur exclusively on your device. We do not maintain servers, databases, analytics platforms, or third-party data processors.
    """)
                    
                    Text("2. Password Storage and Security")
                        .font(.title3).bold()
                    
                    Text("""
    All passwords and sensitive entries you create within the App are stored locally on your device using Apple’s secure system frameworks. The App does not upload passwords to any external service, does not back up or synchronize data to remote servers, and does not have access to your passwords in any form. You retain full and exclusive control over your data at all times.
    """)
                    
                    Text("3. Camera Access and On-Device Vision Processing")
                        .font(.title3).bold()
                    
                    Text("""
    The App may request access to the device camera solely to enable an optional protective feature that detects whether multiple faces are present near the screen. This functionality exists to help shield sensitive information from observation.
    
    • Camera input is processed entirely on-device.  
    • The App does not capture, record, store, or transmit images or video.  
    • No identification, biometric storage, or personal profiling takes place.  
    • Camera access may be disabled at any time in system settings, and the App will continue to function as a password manager.
    """)
                    
                    Text("4. Third-Party Services")
                        .font(.title3).bold()
                    
                    Text("""
    The App does not use any third-party analytics, advertising networks, cloud services, or external APIs. No information is shared with external entities.
    """)
                    
                    Text("5. Data Retention and Deletion")
                        .font(.title3).bold()
                    
                    Text("""
    All data is stored exclusively on the user's device. If you uninstall the App, all stored data, including passwords, will be permanently deleted from the device.
    """)
                    
                    Text("6. Your Rights and Control")
                        .font(.title3).bold()
                    
                    Text("""
    You may revoke camera permissions at any time via device settings and delete all stored data by removing the App.
    """)
                    
                    Text("7. Changes to This Privacy Policy")
                        .font(.title3).bold()
                    
                    Text("""
    Any future updates to this Privacy Policy will be provided within the App. Users will be notified of any changes. Continued use of the App after an update constitutes acceptance of the revised policy.
    """)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundStyle(Color.text)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
