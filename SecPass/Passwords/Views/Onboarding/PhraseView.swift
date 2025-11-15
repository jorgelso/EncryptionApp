//
//  EditPINView.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 06/11/25.
//

import SwiftUI

struct PhraseView: View {
    @State var pin: String = ""
    @Binding var firstTime: Bool
    
    var body: some View {
            VStack (alignment: .center) {
                Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                
                VStack(alignment: .leading) {
                    Text("This is your recovery phrase")
                        .font(.title)
                        .padding(.top)
                    
                    HStack {
                        Spacer()
                        //TODO: Generate a new random phrase each time
                        Text("taco-burrito")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .padding()
                            .foregroundStyle(Color.main)
                        Spacer()
                    }
                
                    Text("Make sure to keep it safe. You will need it for recovering your data.")
                        .font(.headline)
                        .padding(.top)
                    Text("You will not be able to see it again.")
                        .foregroundStyle(Color.accent)
                        .bold()
                        .font(.headline)
                        .padding(.top, 2)
                }
                .foregroundStyle(Color.text)
                
                Button {
                    //TODO: If first time, change show variable, if not, dismiss environment to exit navstack
                    if firstTime {
                        firstTime.toggle()
                    }
                    //if !$pin.isEmpty {}
                } label: {
                    Text("Accept")
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
    }
}

#Preview {
    PhraseView(firstTime: .constant(true))
}
