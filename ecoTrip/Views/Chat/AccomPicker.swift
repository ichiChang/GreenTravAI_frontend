//
//  AccomPicker.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/5.
//

import SwiftUI

struct AccomPicker: View {
  
        private let accom: [String] = [
            "民宿", "飯店", "汽車旅館", "青年旅館", "度假村"
        ]
        
        @Binding public var selectedAccom: String
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
               
                
                Text("請選擇住宿類型")
                    .font(.system(size: 20))
                    .padding(.top)
               
                 
              
                 
                    Picker("Select a accom", selection: $selectedAccom) {
                        ForEach(accom, id: \.self) { accom in
                            Text(accom)
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
    AccomPicker(selectedAccom: .constant(""))
}
