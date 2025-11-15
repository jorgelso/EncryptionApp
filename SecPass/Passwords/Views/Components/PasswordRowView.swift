//
//  PasswordRowView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 03/11/25.
//

import SwiftUI

struct PasswordRowView: View {
    let title: String
    let color: Color
    let detail: String
    
    private var initials: String {
            let parts = title.split(separator: " ").filter { !$0.isEmpty }
            if parts.count >= 2 {
                return parts.prefix(2)
                    .compactMap { $0.first }
                    .map { String($0).uppercased() }
                    .joined()
            } else {
                return String(title.trimmingCharacters(in: .whitespaces).prefix(2)).uppercased()
            }
        }
    
    var body: some View {
        ZStack {
            HStack (spacing: 20) {
                Circle()
                    .fill(color)
                    .frame(width: 60)
                    .overlay {
                        Text(
                            initials
                        )
                        .foregroundStyle(.text)
                    }
                VStack (alignment: .leading) {
                    Text(title)
                        .foregroundStyle(.text)
                        .bold()
                    if !detail.isEmpty {
                        Text(detail)
                            .foregroundStyle(.text.opacity(0.8))
                    }
                }
                .lineLimit(1)
            }
            .padding()
        }
    }
}

#Preview {
    PasswordRowView(title: "Lorem Ipsum", color: .red, detail: "exercitation veniam exercitation")
}
