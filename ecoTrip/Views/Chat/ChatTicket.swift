//
//  ChatTicket.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/30.
//

import SwiftUI

struct ChatTicket: View {
    @State private var showPlacePicker = false
    @State private var selectedPlace = ""
    @State private var showDurationPicker = false
    @State private var showRidePicker = false
    @State private var selectedRide = ""
    @State private var duration = ""
    @State private var upperbudget = ""
    @State private var lowerbudget = ""
    
    
    var body: some View {
        
        VStack{
            Button(action: {
     
            }, label: {
                HStack{
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:20,height:20)
                        .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                    Spacer()
                }
                .frame(width: 280)
                
            })
            
            Text("行程規劃")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom,10)
            
            Text("請輸入行程資訊")
                .font(.system(size: 15))
                .padding(.bottom)
            
            VStack(alignment:.leading){
                //旅遊縣市
                HStack{
                    Text("*旅遊縣市")
                        .bold()
                        .foregroundStyle(.black)
                        .font(.system(size: 15))
                    
                }
                Button(action: {
                    showPlacePicker.toggle()
                }, label: {
                    HStack {
                        Text(selectedPlace.isEmpty ? "" : selectedPlace)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .padding()
                        
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                            .bold()
                            .font(.system(size: 25))
                            .padding()
                    }
                    .frame(width: 280, height: 36)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2)
                    )
                    .padding(.bottom)
                })
                .sheet(isPresented: $showPlacePicker) {
                    PlacePicker(selectedPlace: $selectedPlace)
                        .presentationDetents([.medium])
                }
                
                //旅遊天數
                
                
                
                Text("*旅遊天數")
                    .bold()
                    .foregroundStyle(.black)
                    .font(.system(size: 15))
                
                TextField("", text: $duration)
                    .onChange(of: duration) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.duration = filtered
                        }
                    }
                    .padding(10)
                    .frame(width: 280, height: 36)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2)
                    )
                    .padding(.bottom)
                
                
                
                //預算
                HStack{
                    VStack(alignment:.leading){
                        Text("*預算上限")
                            .bold()
                            .foregroundStyle(.black)
                            .font(.system(size: 15))
                        
                        TextField("", text: $upperbudget)
                            .onChange(of: upperbudget) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.upperbudget = filtered
                                }
                            }
                            .padding(10)
                            .frame(width: 130, height: 36)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2)
                            )
                            .padding(.bottom)
                        
                        
                    }.padding(.trailing,15)
                    
                    VStack(alignment:.leading){
                        Text("*預算下限")
                            .bold()
                            .foregroundStyle(.black)
                            .font(.system(size: 15))
                        
                        TextField("", text: $lowerbudget)
                            .onChange(of: lowerbudget) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.lowerbudget = filtered
                                }
                            }
                            .padding(10)
                            .frame(width: 130, height: 36)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2)
                            )
                            .padding(.bottom)
                    }
                }
                .frame(width: 280)
                
                
                //交通方式
                HStack {
                    Text("主要交通方式")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    
                }
                Button(action: {
                    showRidePicker.toggle()
                }, label: {
                    HStack {
                        Text(selectedRide.isEmpty ? "" : selectedRide)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .padding()
                        
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                            .bold()
                            .font(.system(size: 25))
                            .padding()
                    }
                    .frame(width: 280, height: 36)
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2)
                    )
                    .padding(.bottom)
                })
                .sheet(isPresented: $showRidePicker) {
                    RidePicker(selectedRide: $selectedRide)
                        .presentationDetents([.medium])
                }
            }
            
            //確定按鈕
            Button {

            } label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 42)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
            
            
        }
    
        
    }
}
#Preview {
    ChatTicket()
}
