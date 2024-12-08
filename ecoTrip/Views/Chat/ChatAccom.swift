//
//  ChatAccom.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/30.
//

import SwiftUI

struct ChatAccom: View {
    @Binding var showChatAccom: Bool
    @State private var showPlacePicker = false
    @State private var selectedPlace = "台北市"
    @State private var upperbudget = ""
    @State private var lowerbudget = ""
    @State private var peoplecount = ""
    @State var showDatePicker = false
    @State var selectedDates: Set<DateComponents> = []
    @State private var schedule = ""
    @State private var showAccomPicker = false
    @State private var selectedAccom = "自行安排"
    @EnvironmentObject var colorManager: ColorManager
    var onSubmit: ((String) -> Void)?

    var body: some View {
        
        VStack(spacing:0){
            Button(action: {
                showChatAccom = false
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
            
            Text("住宿推薦")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom,5)
            
            Text("請輸入行程資訊")
                .font(.system(size: 15))
                .padding(.bottom,5)
            
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
                    .frame(width: 280, height: 32)
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
                //旅遊日期
                
                
                
                Text("旅遊日期")
                    .bold()
                    .foregroundStyle(.black)
                    .font(.system(size: 15))
                
                Button(action: {
                    showDatePicker.toggle()
                }, label: {
                    HStack {
                        Text(formatSelectedDates(selectedDates))
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
                    .frame(width: 280, height: 32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
                    )
                    .padding(.bottom)
                })
                
                
                //住宿類型
                
                
                
//                Text("住宿類型")
//                    .bold()
//                    .foregroundStyle(.black)
//                    .font(.system(size: 15))
//                
//                Button(action: {
//                    showAccomPicker.toggle()
//                }, label: {
//                    HStack {
//                        Text(selectedAccom.isEmpty ? "民宿" : selectedAccom)
//                            .foregroundColor(.black)
//                            .font(.system(size: 15))
//                            .padding()
//                        
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .foregroundStyle(colorManager.mainColor)
//                            .bold()
//                            .font(.system(size: 25))
//                            .padding()
//                    }
//                    .frame(width: 280, height: 32)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(colorManager.mainColor, lineWidth: 2)
//                    )
//                    .padding(.bottom)
//                })
                
                Text("入住人數")
                    .bold()
                    .foregroundStyle(.black)
                    .font(.system(size: 15))
                
                TextField("", text: $peoplecount)
                    .onChange(of: peoplecount) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.peoplecount = filtered
                        }
                    }
                    .padding(10)
                    .font(.system(size: 15))
                    .frame(width: 280, height: 32)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
                    )
                    .padding(.bottom)
                
                //預算
                HStack{
                    VStack(alignment:.leading){
                        Text("預算下限(一晚)")
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
                            .frame(width: 130, height: 32)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(colorManager.mainColor, lineWidth: 2)
                            )
                            .padding(.bottom)
                    }
                    
                    VStack(alignment:.leading){
                        Text("預算上限(一晚)")
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
                            .frame(width: 130, height: 32)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(colorManager.mainColor, lineWidth: 2)
                            )
                            .padding(.bottom)
                        
                        
                    }.padding(.trailing,15)
                    
                   
                }
                .frame(width: 280)
                
         
            }
            
            //確定按鈕
            Button {
                let message = "請推薦我 \(formatSelectedDates(selectedDates))「\(selectedPlace)」熱門住宿選擇\n住宿類型：\(selectedAccom)\n入住人數：\(peoplecount)\n預算：\(lowerbudget)~\(upperbudget)"
                    onSubmit?(message) // Pass the formatted message back to ChatView
                showChatAccom = false

            } label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 36)
            .background(colorManager.mainColor)
            .cornerRadius(10)
            
            
        }
        .sheet(isPresented: $showDatePicker) {
            DatePick(selectedDates: $selectedDates)
                .presentationDetents([.height(435)])
        } 
        .sheet(isPresented: $showAccomPicker) {
            AccomPicker(selectedAccom: $selectedAccom)
                .presentationDetents([.medium])
        }
        
    }
}
private func formatSelectedDates(_ dates: Set<DateComponents>) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd" // Alternative custom format
    
    let datesArray = dates.compactMap { Calendar.current.date(from: $0) }
    let sortedDates = datesArray.sorted()
    
    if let firstDate = sortedDates.first, let lastDate = sortedDates.last, firstDate != lastDate {
        return "\(dateFormatter.string(from: firstDate)) - \(dateFormatter.string(from: lastDate))"
    } else if let singleDate = sortedDates.first {
        return dateFormatter.string(from: singleDate)
    } else {
        return ""
    }
}
