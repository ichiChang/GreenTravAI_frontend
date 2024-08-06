//
//  ChatTicket.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/30.
//

import SwiftUI

struct ChatTicket: View {
    @State var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var schedule = ""
    @Binding var showChatTicket: Bool
    @EnvironmentObject var colorManager: ColorManager

    var body: some View {
        
        VStack(alignment:.center){
            Button(action: {
                showChatTicket = false

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
            
            Text("票價查詢")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom,10)
            
            Text("請輸入行程資訊")
                .font(.system(size: 15))
                .padding(.bottom)
     
                //旅遊縣市
                HStack{
                    Text("*景點名稱")
                        .bold()
                        .foregroundStyle(.black)
                        .font(.system(size: 15))
                    Spacer()
                    
                }
                .frame(width: 270, height: 36)

                TextField("", text: $schedule)
                    .padding(10)
                    .frame(width: 270, height: 36)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorManager.mainColor, lineWidth: 2)
                    )
                    .padding(.bottom)
                
                //日期
                HStack(alignment:.center){
                   Text("日期")
                       .bold()
                       .foregroundStyle(Color.black)  // 注意：foregroundStyle 的参数应该是 Color 类型
                       .font(.system(size: 15))
                    
                   Spacer()
                        .frame(width: 120)
                    
                   DatePicker("", selection: $selectedDate, displayedComponents: .date)
                       .labelsHidden() // 隐藏标签以使 DatePicker 紧贴左侧
              
               

                 
                
                
            }
            
            Spacer()
                .frame(height:120)
            
            //確定按鈕
            Button {
                showChatTicket = false

            } label: {
                Text("查詢")
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
#Preview {
    ChatTicket(showChatTicket:  .constant(true))
        .environmentObject(ColorManager()) // 提供 ColorManager 給預覽

}
