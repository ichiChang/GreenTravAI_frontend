//
//  HeartView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//

import SwiftUI

struct HeartView: View {

    var body: some View {
        VStack(spacing:0){
            ZStack(alignment:.top){
                Button(action: {

                }, label: {
                    HStack{
                    
                    Image(.greenlabel2)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                        .padding(10)
                              
                        
                        Spacer()
                        
                    }
                    
                })
                .frame(width: 280, height: 60)
                .zIndex(1)
                   
                Image("garden")
                .resizable()
                .scaledToFill()
                .frame(width: 280, height: 130)
                .clipped()
                            
                }
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("台北植物園").bold()
                            .font(.system(size: 20))
                            .bold()
                            .padding(.top, 15)
                            .padding(.leading, 10)
                            .padding(.bottom, 3)
                        
                        Text("100台北市中正區南海路53號")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .padding(.bottom, 15)
                    }
                    
                  
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.black)
                            .padding(.leading,25)
                    }
                }
                .frame(width: 280, height: 60, alignment: .leading)
                .background(Color.white)
            }
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(20)
        }
    }
  
#Preview {
    HeartView()
}
