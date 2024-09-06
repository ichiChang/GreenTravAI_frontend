//
//  PlaceChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/8.
//

import SwiftUI

struct PlaceChoice: View {
    @State private var textInput = ""
    @Binding var navigateToPlaceChoice: Bool


    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    navigateToPlaceChoice = false
                }
               , label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .bold()
                        .frame(width: 15, height: 20)
                        .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                })
               
                
                // Text field
                TextField("請輸入地點名稱", text: $textInput)
                    .frame(width: 280)
                    .font(.system(size: 15))
                    .padding(10)
                    .padding(.horizontal,10)
                    .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                    .cornerRadius(20)
                   
                
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                navigateToPlaceChoice = false
            }, label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            })
            .frame(width: 280, height: 50)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
            .padding()
           
            
        }
        .navigationBarBackButtonHidden(true)

       
          
    }
}

#Preview {
    PlaceChoice(navigateToPlaceChoice: .constant(false))
}
