//
//  PasswordDataRow.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI

struct PasswordDataRow: View {
    var name: String
    var value: String
    var imageName: String
    
    var body: some View {
        HStack () {
            Image(systemName: imageName)
            VStack (alignment: .leading) {
                Text(name)
                    .foregroundStyle(.text.opacity(0.7))
                    .font(.subheadline)
                Text(value)
                    .foregroundColor(.text)
                    .tint(.text)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background{
            Color.second
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 3)
    }
}

#Preview {
    PasswordDataRow(name: "Email Address", value: "placeholder@test.com", imageName: "envelope")
}
