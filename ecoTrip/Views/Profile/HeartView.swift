//
//  HeartView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/22.
//
import SwiftUI

struct HeartView: View {
    @State private var selectedTab: Tab = .travelPlan
    
    enum Tab {
        case travelPlan
        case itinerary
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("行程")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(selectedTab == .travelPlan ? Color.init(hex: "5E845B", alpha: 1.0) : Color.init(hex: "BFBFBF", alpha: 1.0))
                    .onTapGesture {
                        selectedTab = .travelPlan
                    }
//                Spacer()
//                Text("｜")
//                Spacer()
//                Text("旅行計劃")
//                    .font(.system(size: 20))
//                    .bold()
//                    .foregroundColor(selectedTab == .itinerary ? Color.init(hex: "5E845B", alpha: 1.0) : Color.init(hex: "BFBFBF", alpha: 1.0))
//                    .onTapGesture {
//                        selectedTab = .itinerary
//                    }
                Spacer()
            }
            .frame(width: 280)
            
            ScrollView {
                if selectedTab == .travelPlan {
                    travelPlanContent()
                } else {
                    itineraryContent()
                }
            }
        }
    }
    
    // 行程的內容
    @ViewBuilder
    private func travelPlanContent() -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Button(action: {
                    // 按鈕動作
                }, label: {
                    HStack {
                        ZStack {
                            Circle()  // 白色圓形背景
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "leaf.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                        }
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
                    Text("台北植物園")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text("100台北市中正區南海路53號")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 15)
                }
                Spacer()
                Button(action: {
                    // 按鈕動作
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 25)
                }
            }
            .frame(width: 280, height: 60, alignment: .leading)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(20)
        
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                
                Image("nightmarket")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 130)
                    .clipped()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("南機場夜市")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text("100台北市中正區中華路二段307巷")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 15)
                }
                Spacer()
                Button(action: {
                    // 按鈕動作
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 25)
                }
            }
            .frame(width: 280, height: 60, alignment: .leading)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(20)
    }
    
    // 旅行計劃的內容
    @ViewBuilder
    private func itineraryContent() -> some View {
        VStack(spacing:0){
            ZStack(alignment:.top){
                
                
                Image("greenisland")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 130)
                    .clipped()
                HStack{
                    Spacer()
                    
                    VStack(spacing:0){
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(5)
                            
                            Image(systemName:"heart")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(5)
                            
                            Image(systemName:"hand.thumbsup")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    }
                }
                .frame(width: 280)
                
                
            }
            
            
            HStack {
                VStack(alignment: .leading, spacing:5) {
                    Text("綠島畢業旅行")
                        .bold()
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 10)

                    
                    
                    HStack(alignment:.top){
                        Text("4 days ·")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)

                        
                        
                        Image(systemName:"hand.thumbsup")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                            .bold()
                        
                        Text("362 ·")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                        
                        Image(systemName:"heart")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                            .bold()
                        
                        Text("58")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                    }
                    .padding(.leading, 10)
                    .padding(.bottom)
                    
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
