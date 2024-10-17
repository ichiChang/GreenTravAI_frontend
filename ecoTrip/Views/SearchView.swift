//
//  SearchView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/30.
//

import SwiftUI

struct SearchView: View{
    @State private var searchText = ""
    @Binding var index1: Int
    @State private var navigateToSiteInfo = false
    @State private var showres = false
    @State private var showaccom = false
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View{
        NavigationView  {
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                // Search bar
                HStack {
                    // Search icon
                    Image(systemName: "magnifyingglass")
                        .frame(width: 45, height: 45)
                        .padding(.leading, 10)
                    
                    // Text field
                    TextField("搜尋地點", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            mapViewModel.searchPlaces(query: newValue)
                        }
                        .padding(.vertical, 10)
                }
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding()
                
                // Button section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        categoryButton(title: "附近", systemName: "mappin.and.ellipse", index: 0)
                        categoryButton(title: "餐廳", systemName: "fork.knife", index: 1)
                        categoryButton(title: "住宿", systemName: "bed.double.fill", index: 2)
                        categoryButton(title: "超市", systemName: "cart.fill", index: 3)
                    }
                    .padding(.horizontal)
                }
                
                if mapViewModel.isLoading {
                    ProgressView("正在載入地點...")
                        .padding()
                } else if mapViewModel.searchResults.isEmpty {
                    Text("沒有找到地點")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(mapViewModel.searchResults) { placeModel in
                            placeCard(placeModel: placeModel)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    private func categoryButton(title: String, systemName: String, index: Int) -> some View {
        Button(action: {
            self.index1 = index
            switch index {
            case 0:
                mapViewModel.searchNearbyPlaces()
            case 1:
                mapViewModel.searchPlaces(query: "餐廳")
            case 2:
                mapViewModel.searchPlaces(query: "住宿")
            case 3:
                mapViewModel.searchPlaces(query: "超市")
            default:
                break
            }
        }) {
            HStack {
                Image(systemName: systemName)
                    .foregroundColor(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0))
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0))
            }
            .frame(width: 80, height: 35)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(index1 == index ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
            )
        }
        .padding(.horizontal, 5)
    }
    
    // Helper function to display place card
    func placeCard(placeModel: PlaceModel) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment:.top) {
                HStack {
                    // Display lowCarbon icon if the place is low-carbon
                    if false {
                        Image(.greenlabel2)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    Spacer()
                    
                    // Heart button for favoriting a place
                    Button(action: {
                        // TODO: favorite
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .padding(5)
                            
                            Image(systemName:"heart")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    })
                }
                .frame(width: 280, height: 60)
                .zIndex(1)
                
                // Place image with NavigationLink to SiteInfoView
                NavigationLink(destination: SiteInfoView(placeModel: placeModel)) {
                    if let image = placeModel.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 130)
                            .clipped()
                    }
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(placeModel.name)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text(placeModel.address)
                        .font(.system(size: 13))
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
                        .padding(.leading, 25)
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
