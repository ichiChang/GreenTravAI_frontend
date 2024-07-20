//
//  PlacePicker.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/9.
//
import SwiftUI

struct PlacePicker: View {
    private let places: [String] = [
        "台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市", "新竹縣", "苗栗縣", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "屏東縣", "宜蘭縣", "花蓮縣", "台東縣", "基隆市", "新竹市", "嘉義市"
    ]
    
    @Binding public var selectedPlace: String
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        VStack{
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
           
            
            Text("請選擇目的地")
                .font(.system(size: 20))
             
             
                Picker("Select a place", selection: $selectedPlace) {
                    ForEach(places, id: \.self) { place in
                        Text(place)
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

// SwiftUI Preview
struct PlacePicker_Previews: PreviewProvider {
    static var previews: some View {
        PlacePicker(selectedPlace: .constant(""))
    }
}
