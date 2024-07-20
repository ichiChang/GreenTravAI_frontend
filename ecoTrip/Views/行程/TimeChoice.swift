//
//  TimeChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/11.
//

import SwiftUI

struct TimeChoice: View {
    @Environment(\.dismiss) var dismiss


    var body: some View {
        
        VStack(alignment:.center, spacing: 0) {
            
            
                HStack {
                    Text("抵達時間")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: 295, alignment: .leading)
                    
                   
                    
                    
                }

            
            
            Divider()
                .frame(minHeight: 2)
                .frame(width: 295)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding(.bottom)
            
            
                HStack {
                    Text("預計停留時間")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: 295, alignment: .leading)
                    
                }
      
            
            Spacer()
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            
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
    }
}

#Preview {
    TimeChoice()
}
