//
//  SuitcaseView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//

import SwiftUI

struct SuitcaseView: View {
    var body: some View {
        VStack{
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                HStack{
                    Text("宜蘭三天兩夜")
                        .bold()
                        .font(.system(size: 23))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .bold()
                        .foregroundColor(Color(hex: "8F785C", alpha: 1.0))


                }
                .padding(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 3)
                )

            })

            .frame(width: 312, height: 118)
            

        

        }
    }
}
#Preview {
    SuitcaseView()
}
