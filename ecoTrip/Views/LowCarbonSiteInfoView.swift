//
//  LowCarbonSiteInfoView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/10/29.
//


import SwiftUI
import MapKit

struct LowCarbonSiteInfoView: View {
    @Environment(\.dismiss) var dismiss
    var name: String
    var address: String
    var image: Image

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment:.top){
                
                HStack(spacing:0) {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .padding(10)
                            
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 15, height: 20)
                                .bold()
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                        }
                    }
                    Spacer()
                    Button(action: {
                        // 地圖
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .padding(10)
                            Image(systemName: "map.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                    
                    Button(action: {
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width:35,height: 35)
                                .padding(10)
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width:20,height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                }

                .padding()
                .padding(.bottom)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
            }
            .frame(height:50)

 
                
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width:400, height: 250)
                    .clipped()
                    .padding(.bottom)
                
                
            

            ScrollView{
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(name).bold()
                            .font(.system(size: 20))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                        
                        Text(address)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                    
                    Button(action: {
                    }) {
                        Text("加入行程")
                            .bold()
                            .font(.system(size: 15))
                            .padding(15)
                            .foregroundStyle(.white)
                            .background(Color.init(hex: "5E845B", alpha: 1.0))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                
                
                Divider()
                    .frame(minHeight: 2)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.vertical)
                
                Link(destination: URL(string: "https://www.zoo.gov.taipei/") ?? URL(string: "https://www.example.com")!) {
                    HStack {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.horizontal)                     .foregroundColor(Color(hex: "444444"))
                        Text("https://www.zoo.gov.taipei/")
                            .font(.system(size: 15))

                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 330)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding()
                
                HStack {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                    Text("02 2938 2300") // TODO: 電話
                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                        .font(.system(size: 15))

                    Spacer()
                }

                .padding(.horizontal)
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 330)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding()
                
            
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)
                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                    Text("星期一: 09:00–17:00\n星期二: 09:00–17:00\n星期三: 09:00–17:00\n星期四: 09:00–17:00\n星期五: 09:00–17:00\n星期六: 09:00–17:00\n星期日: 09:00–17:00")
                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                        .font(.system(size: 15))

                    Spacer()
                }
                .padding(.horizontal)
                
                
                Spacer()
                
            }
            .navigationBarBackButtonHidden(true)

        }
    }
    private func getDomainPrefix(from urlString: String) -> String {
        guard let url = URL(string: urlString),
              let host = url.host else {
            return urlString
        }
        return host
    }
    
}

