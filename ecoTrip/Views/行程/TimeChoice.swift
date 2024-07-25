//
//  TimeChoice.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/11.
//

import SwiftUI

struct TimeChoice: View {
    @Binding var arrivalTime: Date
    @Binding var departureTime: Date
    @State private var selectedStayHour: Int = 0
    @State private var selectedStayMinute: Int = 0
    let hours = Array(0...23)  // Hours array for 24-hour format
    let minutes = Array(0...59)  // Minutes array
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Button{
                dismiss()
            }label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .bold()
                    .frame(width:42, height: 15)
                    .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                
                
            }
            .padding(30)
            
            Spacer()
                .frame(height: 80)
            HStack {
                Text("抵達時間")
                    .font(.system(size: 23))
                    .foregroundStyle(.black)
                    .frame(maxWidth: 150, alignment: .leading)

                DatePicker(
                    "",
                    selection: $arrivalTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .frame(width: 150, height: 60)
                .scaleEffect(1.3)
            }
       

            Divider()
                .frame(width:340,height: 2)
                .overlay(Color.init(hex: "999999", alpha: 1.0))
                .padding()

            HStack {
                Text("離開時間")
                    .font(.system(size: 23))
                    .foregroundStyle(.black)
                    .frame(maxWidth: 150, alignment: .leading)

                
                DatePicker(
                    "",
                    selection: $departureTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .frame(width: 150, height: 60)
                .scaleEffect(1.3)
//                    Picker("Hour", selection: $selectedStayHour) {
//                        ForEach(hours, id: \.self) { hour in
//                            Text("\(hour) hr").tag(hour)
//                                .font(.system(size: 23))
//                        }
//                    }
//                    .frame(width: 100) 
//                    .clipped()
//                    .pickerStyle(WheelPickerStyle())
//
//                    Picker("Minute", selection: $selectedStayMinute) {
//                        ForEach(minutes, id: \.self) { minute in
//                            Text("\(minute) min").tag(minute)
//                                .font(.system(size: 23))
//                        }
//                    }
//                    .frame(width: 80)  // Control the width of the minute picker
//                    .clipped()
//                    .pickerStyle(WheelPickerStyle())
                
            }
            .padding(.horizontal)

            Spacer()
   

            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("返回")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("確定")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
                
            }
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct TimeChoice_Previews: PreviewProvider {
    static var previews: some View {
        TimeChoice(arrivalTime: .constant(Date()),
                   departureTime: .constant(Date().addingTimeInterval(3600)))
    }
}
