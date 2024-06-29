//
//  SiteInfoView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/28.
//

import SwiftUI

struct SiteInfoView: View {
    var body: some View {
        VStack(spacing:0){
  
            ZStack(alignment: .topLeading){
                HStack{
                    
                    Button(action: {
                        // 按鈕動作
                    }) {
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width:45,height: 45)
                                .padding()
                            
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width:20,height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                                
                      

                        }

                    }
                    Spacer()
                    Button(action: {
                        // 按鈕動作
                    }) {
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width:45,height: 45)
                                .padding()
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width:23,height: 23)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()

                        }

                    }
                    Button(action: {
                        // 按鈕動作
                    }) {
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width:45,height: 45)
                                .padding(5)
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width:23,height: 23)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                               

                        }

                    }
                }
                .zIndex(1)
                
                Image(.garden)
                    .resizable()
                    .scaledToFit()
             
        }
        

        
        HStack{
            VStack(alignment: .leading) {
                Text("台北植物園").bold()
                    .font(.title2)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                    .padding(.bottom, 5)
                
                
                Text("100台北市中正區南海路53號")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                
             
            
            }
            Spacer()
                
           
                
            Button(action: {
                    // 按鈕動作
                }){
                
                    Text("加入行程")
                        .bold()
                        .font(.system(size: 15))
                        .padding(15)
                        .foregroundStyle(.white)
                        .background(Color.init(hex: "5E845B", alpha: 1.0))
                        .cornerRadius(15)
                     
                    
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            
            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding(.bottom)

            
            HStack{
                Image(systemName: "globe")
                    .resizable()
                    .frame(width:25,height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

          
            
            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding()
            
            
            
            HStack{
                Image(systemName: "phone.fill")
                    .resizable()
                    .frame(width:25,height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

          
            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding()
            
            HStack{
                Image(systemName: "clock")
                    .resizable()
                    .frame(width:25,height: 25)
                    .padding(10)
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Spacer()
            }
            .padding(.horizontal)

          
                
          
            

            
            
            Spacer()
        }
       
    }
}

#Preview {
    SiteInfoView()
}
