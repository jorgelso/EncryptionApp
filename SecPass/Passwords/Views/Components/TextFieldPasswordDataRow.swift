//
//  TextFieldPasswordDataRow.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI

struct TextFieldPasswordDataRow: View {
    var name: String
    @Binding var value: String
    var imageName: String
    var allowDete: Bool
    
    var body: some View {
        VStack {
            HStack () {
                Image(systemName: imageName)
                VStack (alignment: .leading) {
                    Text(name)
                        .foregroundStyle(value != "" ? .text.opacity(0.6) : .text)
                        .animation(.easeInOut(duration: 0.5), value: value)
                        .font(.subheadline)
                    TextField(
                        text: $value,
                        prompt: Text("Add \(name.lowercased())").foregroundColor(.text.opacity(0.6))
                    ) {
                        Text(name)
                    }
                    .foregroundColor(.text)
                    .tint(.text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                }
                Spacer()
                
                if allowDete {
                    Button {
                        value = ""
                    } label: {
                        Image(systemName: "multiply")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background{
                Color.second.opacity(0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 3)
        }
    }
}

#Preview {
    TextFieldPasswordDataRow(name: "Email Address", value: .constant("placeholder@test.com"), imageName: "envelope", allowDete: false)
}
