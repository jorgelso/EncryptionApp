//
//  NavButton.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 13/11/25.
//

import SwiftUI

struct NavButton<Destination: View>: View {
    let destination: Destination
    let text: String
    let imageText: String
    
    var body: some View {
        NavigationLink(destination: destination) {
                HStack{
                    Text(text)
                    Spacer()
                    Image(systemName: imageText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(Color.text)
                .background{
                    Color.second.opacity(0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                }
                .foregroundStyle(Color.text)
            }
    }
}

#Preview {
    NavButton(destination: EmptyView(), text: "Continue", imageText: "square.and.arrow.up.fill")
}
