//
//  RidePicker.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/9.
//

import SwiftUI

struct RidePicker: View {
    private let ride: [String] = [
        "自行安排", "開車", "大眾運輸", "步行", "機車"
    ]
    
    @Binding public var selectedRide: String
    @Environment(\.dismiss) var dismiss
    
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
           
            
            Text("請選擇主要交通方式")
                .font(.system(size: 20))
                .padding(.top)
           
             
          
             
                Picker("Select a ride", selection: $selectedRide) {
                    ForEach(ride, id: \.self) { ride in
                        Text(ride)
                    }
                }
                .pickerStyle(WheelPickerStyle())
           
            
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

#Preview {
    RidePicker(selectedRide: .constant(""))
}
