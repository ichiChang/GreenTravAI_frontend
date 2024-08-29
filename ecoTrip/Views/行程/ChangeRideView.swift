//
//  ChangeRideView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/17.
//

import SwiftUI

struct ChangeRideView: View {
    @State private var selectedIndex: Int? = 1
    @Environment(\.dismiss) var dismiss
    let transportationOptions = [
           ("figure.walk", "47 分鐘", false),
           ("bicycle", "12 分鐘", true),
           ("bus.fill", "25 分鐘", false),
           ("scooter", "7 分鐘", false),
           ("car.rear.fill", "8 分鐘", false)
       ]
       
    var body: some View {
        VStack(spacing:0) {
            // Top bar with back button
            HStack {
                Button(action: {
                  dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                })
                .padding()
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            
            //起點終點
            HStack{
                ZStack{
                    Circle()
                        .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                        .frame(width:40,height: 40)

                    Text("起")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 18))
                }
                ZStack(alignment:.leading){
                    Rectangle()
                        .foregroundStyle(Color.init(hex: "E8E8E8", alpha: 1.0))
                        .frame(width:270,height:40)
                        .cornerRadius(15)
                    
                    Text("台北市立動物園")
                        .bold()
                        .font(.system(size: 18))
                        .padding()
                }
            }
            .padding(.vertical)
            
            HStack{
                ZStack{
                    Circle()
                        .foregroundStyle(Color.init(hex: "D26363", alpha: 1.0))
                        .frame(width:40,height: 40)

                    Text("終")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.system(size: 18))
                }
                ZStack(alignment:.leading){
                    Rectangle()
                        .foregroundStyle(Color.init(hex: "E8E8E8", alpha: 1.0))
                        .frame(width:270,height:40)
                        .cornerRadius(15)
                    
                    Text("文山運動中心")
                        .bold()
                        .font(.system(size: 18))
                        .padding()
                }
            }
            .padding(.bottom)
            
            //交通工具
            ForEach(transportationOptions.indices, id: \.self) { index in
                VStack{
                    HStack {
                        Image(systemName: transportationOptions[index].0)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        
                        Text(transportationOptions[index].1)
                            .frame(maxWidth: 70, alignment: .trailing)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            selectedIndex = index
                        }) {
                            Image(systemName: selectedIndex == index ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                        }
                        
                        
                    }
                    .frame(width:320)
                    .padding(10)
                }
                if index < self.transportationOptions.count - 1 {
                    Divider()
                        .frame(minHeight: 2)
                        .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .padding(.bottom)
                        .frame(width:330)
                }
            }
         
                
            Button(action: {
                dismiss()
            }, label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            })
            .frame(width: 120, height: 42)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
            .padding()
        
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    ChangeRideView()
}
