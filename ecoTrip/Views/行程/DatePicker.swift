//
//  DatePicker.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/9.
//

import SwiftUI

struct DatePicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDates: Set<DateComponents>

    
    var body: some View {
        VStack(spacing:0){
            Button{
                dismiss()
            }label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .bold()
                    .frame(width:42, height: 15)
                    .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                
            }
            .padding()
  
           
            
            Text("請選擇行程日期")
                .font(.system(size: 20))
            
           
            MultiDatePicker("Select dates", selection: $selectedDates)
                .frame(height: 290)
                .padding()
                        
                        
            Button(action: {
                dismiss()
            }, label: {
                Text("確定")
                    .bold()
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            })
            .frame(width: 100, height: 42)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
   
            
          
        }
    }
}

// SwiftUI Preview
struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker(selectedDates: .constant([]))
    }
}
