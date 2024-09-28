//
//  PopularPlansView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/5.
//

import SwiftUI

struct PopularPlansView: View {
    @State private var textInput = ""
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 30)
            HStack{
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 45, height: 45)
                        .padding(.leading, 5)
                    
                    TextField(" ", text: $textInput)
                        .padding(.vertical, 10)
                    
                    
                }
                .frame(width: 280, height: 35)
                .background(Color.init(hex: "E8E8E8", alpha: 1.0))
                .cornerRadius(10)
                .padding(.vertical)
                
                Button {
                    
                } label: {
                    ZStack{
                        Circle()
                            .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                            .frame(width:40,height: 40)
                        
                        Image("filter 1")
                            .frame(width: 45, height: 45)
                    }
                }
                
            }
            .frame(width: 350, height: 35)
            
            //旅行計劃
            ScrollView{
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
                        VStack(alignment: .leading,spacing:0) {
                            Text("綠島畢業旅行").bold()
                                .font(.system(size: 20))
                                .bold()
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                            
                            
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
                            .padding(.bottom, 10)
                            
                        }
                        
                        
                        
                    }
                    .frame(width: 280, height: 60, alignment: .leading)
                    .background(Color.white)
                    
                    
                    
                }
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(20)
                
                VStack(spacing:0){
                    ZStack(alignment:.top){
                        
                        
                        Image("tainan")
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
                        VStack(alignment: .leading,spacing:0) {
                            Text("府城美食之旅").bold()
                                .font(.system(size: 20))
                                .bold()
                                .padding(.top, 15)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                            
                            
                            HStack(alignment:.top){
                                Text("3 days ·")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                
                                
                                Image(systemName:"hand.thumbsup")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                                    .bold()
                                
                                Text("168 ·")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                
                                
                                Image(systemName:"heart")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                                    .bold()
                                
                                Text("30")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                
                            }
                            .padding(.leading, 10)
                            .padding(.bottom, 10)
                            
                        }
                        
                        
                        
                    }
                    .frame(width: 280, height: 60, alignment: .leading)
                    .background(Color.white)
                    
                    
                    
                }
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(20)
            }
            Spacer()
            
        }
        
        
    }
}


#Preview {
    PopularPlansView()
}
