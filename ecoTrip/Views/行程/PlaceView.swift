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
                    .font(.system(size: 25))
                    .padding(.bottom,10)
                Text(time)
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .padding()
    
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 15,height: 25)
                    .foregroundColor(.black)
                    .padding(.trailing,30)
            })
        
      
        }
        .background(Color.init(hex: "F5EFCF", alpha: 1.0))
        .cornerRadius(20)
        .padding(20)
       
     
   
        
    }
}

#Preview {
    PlaceView(name: "國立政治大學", time: "10:00 - 10:30")
}
