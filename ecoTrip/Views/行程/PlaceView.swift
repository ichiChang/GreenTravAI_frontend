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
                    .font(.system(size: 20))
                    .padding(.top,10)
                    .padding(.leading,10)
                    .padding(.bottom,3)
                Text(time)
                    .bold()
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.horizontal,10)
                    .padding(.bottom,5)

            }
            .padding()
            
            Spacer()
                
            
            Button(action: {
                
            }, label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .bold()
                    .frame(width: 10,height: 20)
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                    .padding(.trailing,10)
             
            })
            .padding()
        
      
        }
        .frame(width: 330,height: 70)
        .background(Color.init(hex: "F5F5F5", alpha: 1.0))
        .cornerRadius(15)
     
   
     
   
        
    }
}

#Preview {
    PlaceView(name: "國立政治大學", time: "10:00 - 10:30")
}
