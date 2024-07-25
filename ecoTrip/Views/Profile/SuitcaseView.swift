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
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .bold()
                        .foregroundColor(Color(hex: "8F785C", alpha: 1.0))


                }
                .padding(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 3)
                )

            })
            .frame(width: 300, height: 100)
            .padding()
            

            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                HStack{
                    Text("台南三天兩夜")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .bold()
                        .foregroundColor(Color(hex: "8F785C", alpha: 1.0))


                }
                .padding(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(hex: "8F785C", alpha: 1.0), lineWidth: 3)
                )

            })
            .frame(width: 300, height: 100)
            .padding()

        }
    }
}
#Preview {
    SuitcaseView()
}
