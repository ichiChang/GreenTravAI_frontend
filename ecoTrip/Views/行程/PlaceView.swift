//
//  PlaceView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/3.
//

import SwiftUI

struct PlaceView: View {
    var name: String
    var time: String

    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(name)
                    .bold()
                    .font(.system(size: 23))
                    .padding(10)
                Text(time)
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.horizontal,10)
                    .padding(.bottom,10)

            }
            .padding()
            
            Spacer()
                
            
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 10,height: 20)
                    .foregroundColor(.black)
                    .padding(.trailing,10)
             
            })
            .padding()
        
      
        }
        .frame(width: 300,height: 90)
        .background(Color.init(hex: "F5EFCF", alpha: 1.0))
        .cornerRadius(20)
        .padding(.bottom)
   
     
   
        
    }
}

#Preview {
    PlaceView(name: "國立政治大學", time: "10:00 - 10:30")
}
