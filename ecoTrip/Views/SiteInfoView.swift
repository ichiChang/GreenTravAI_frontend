//
//  SiteInfoView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/28.
//

import SwiftUI
import MapKit

struct SiteInfoView: View {
    @StateObject private var placeViewModel = PlaceViewModel()
    @Environment(\.dismiss) var dismiss
    let placeModel: PlaceModel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment:.top){
                
                
            if let image = placeModel.image {
                
                image
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 300)
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
            }
            
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
                        placeViewModel.toggleFavorite(for: placeModel.id)
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width:35,height: 35)
                                .padding(10)
                            Image(systemName: placeViewModel.favorites[placeModel.id, default: false] ? "heart.fill" : "heart")
                                .resizable()
                                .frame(width:20,height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                }
                .padding(.top,30)
                .padding(.horizontal)

            }
            .frame(maxWidth: .infinity)

                
         
            
            HStack {
                VStack(alignment: .leading) {
                    Text(placeModel.name).bold()
                        .font(.system(size: 20))
                        .padding(.top, 10)
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    
                    Text(placeModel.address)
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
            .padding()
          
            
            Divider()
                .frame(minHeight: 2)
                .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                .padding(.bottom,30)
            
            Link(destination: URL(string: placeModel.website!) ?? URL(string: "https://www.example.com")!) {
                HStack {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.horizontal)                     .foregroundColor(Color(hex: "444444"))
                    Text(getDomainPrefix(from: placeModel.website!))
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
                    .padding(.horizontal)                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                Text(placeModel.phoneNumber!) // TODO: 電話
                    .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
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
                        .padding(.horizontal)                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                    Text(placeModel.currentOpeningHours ?? "暫時營業時間")
                        .foregroundColor(Color.init(hex: "444444", alpha: 1.0))
                    Spacer()
                }
                .padding(.horizontal)
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    private func getDomainPrefix(from urlString: String) -> String {
        guard let url = URL(string: urlString),
              let host = url.host else {
            return urlString
        }
        return host
    }
    
}


