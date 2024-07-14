//
//  PlaceChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/8.
//

import SwiftUI

struct PlaceChoice: View {
    @State private var textInput = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{
            // Text field
            TextField("請輸入地點名稱", text: $textInput)
                .font(.system(size: 20))
                .padding(10)
                .padding(.horizontal)
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(20)
                .padding(30)
              
        
            Spacer()
            
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    Text("返回")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
        
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("確定")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
      
                
            }
            
        }
        .navigationBarBackButtonHidden(true)

       
          
    }
}

#Preview {
    PlaceChoice()
}
