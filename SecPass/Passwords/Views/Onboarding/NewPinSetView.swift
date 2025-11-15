//
//  NewPinSetView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 13/11/25.
//

import SwiftUI

struct NewPinSetView: View {
    @Binding var firstTime: Bool
    @Environment(\.dismiss) private var dismiss
    @State var showPhrase: Bool = false
    
    var body: some View {
        //GeometryReader { geometry in
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if !showPhrase {
                VStack {
                    Text("New PIN code set")
                        .bold()
                        .font(.title)
                        .foregroundStyle(Color.text)
                    // .padding(.vertical, 60)
                    Text("Now you can use it to log-in")
                        .foregroundStyle(Color.text)
                        .padding(.vertical, 20)
                        .onAppear {
                            if firstTime {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showPhrase = true
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    dismiss()
                                }
                                
                                /*
                                 Button {
                                 firstTime.toggle()
                                 } label: {
                                 Text("Continue")
                                 .frame(maxWidth: .infinity)
                                 .font(.title3)
                                 .padding(.vertical, 5)
                                 }
                                 .buttonStyle(.borderedProminent)
                                 .position(x: geometry.size.width / 2, y: geometry.size.height / 3.25)
                                 */
                                
                            }
                        }
                    //}
                }
            } else {
                PhraseView(firstTime: $firstTime)
            }
        }
    }
}

#Preview {
    NewPinSetView(firstTime: .constant(true))
}
