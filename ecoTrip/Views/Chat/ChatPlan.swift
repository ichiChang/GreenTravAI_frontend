//
//  ChatPlan.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/28.
//

import SwiftUI

struct ChatPlan: View {
    @Binding var showChatPlan: Bool
    @State private var showPlacePicker = false
    @State private var selectedPlace = "台北市"
    @State private var showDurationPicker = false
    @State private var showRidePicker = false
    @State private var selectedRide = "自行安排"
    @State private var duration = ""
    @State private var upperbudget = ""
    @State private var lowerbudget = ""
    @EnvironmentObject var colorManager: ColorManager
    var onSubmit: ((String) -> Void)?
    
    var body: some View {
        
        VStack{
            Button(action: {
                showChatPlan = false
            }, label: {
                HStack{
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width:20,height:20)
                        .foregroundColor(colorManager.mainColor)
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
                        Text(selectedPlace.isEmpty ? "台北市" : selectedPlace)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .padding()
                        
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(colorManager.mainColor)
                            .bold()
                            .font(.system(size: 25))
                            .padding()
                    }
                    .frame(width: 280, height: 36)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
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
                    .font(.system(size: 15))
                    .padding(10)
                    .frame(width: 280, height: 36)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
                    )
                    .padding(.bottom)
                
                
                
                //預算
                HStack{
                    VStack(alignment:.leading){
                        Text("預算下限")
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
                            .font(.system(size: 15))
                            .padding(10)
                            .frame(width: 130, height: 36)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(colorManager.mainColor, lineWidth: 2)
                            )
                            .padding(.bottom)
                    }
                    
                    VStack(alignment:.leading){
                        Text("預算上限")
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
                            .font(.system(size: 15))
                            .padding(10)
                            .frame(width: 130, height: 36)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(colorManager.mainColor, lineWidth: 2)
                            )
                            .padding(.bottom)
                        
                        
                    }.padding(.trailing,15)
                    
               
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
                        Text(selectedRide.isEmpty ? "自行安排" : selectedRide)
                            .foregroundColor(.black)
                            .font(.system(size: 15))
                            .padding()
                        
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(colorManager.mainColor)
                            .bold()
                            .font(.system(size: 25))
                            .padding()
                    }
                    .frame(width: 280, height: 36)
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
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
                let message = "請幫我規劃「 \(selectedPlace)」 \(duration)天行程\n預算：\(lowerbudget)～\(upperbudget)\n主要交通方式：\(selectedRide)"
                            onSubmit?(message)
                
                showChatPlan = false

            } label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 42)
            .background(colorManager.mainColor)
            .cornerRadius(10)
            
            
        }
    
        
    }
}



#Preview {
    ChatPlan(showChatPlan: .constant(true))
        .environmentObject(ColorManager()) // 提供 ColorManager 給預覽

}
