//
//  ChatTransport.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/30.
//



import SwiftUI

struct ChatTransport: View {
    @Binding var showChatTransport: Bool
    @State private var showPlacePicker1 = false
    @State private var showPlacePicker2 = false
    @State private var selectedPlace1 = "台北市"
    @State private var selectedPlace2 = "台北市"
    @State private var arrivalTime = Date()
    @State private var departureTime = Date()
    @State private var navigateToTimeChoice = false
    @State private var timeChoice = Time.departure.rawValue  // Default to departure time
    @EnvironmentObject var colorManager: ColorManager
    var onSubmit: ((String) -> Void)?
    
    var body: some View {
        VStack {
            Button(action: {
                showChatTransport = false
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
            
            Text("交通查詢")
                .bold()
                .font(.system(size: 20))
                .padding(.bottom,10)
            
            Text("請輸入行程資訊")
                .font(.system(size: 15))
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("*出發地")
                        .bold()
                        .foregroundStyle(.black)
                        .font(.system(size: 15))
                }
                Button(action: {
                    showPlacePicker1.toggle()
                }, label: {
                    HStack {
                        Text(selectedPlace1.isEmpty ? "台北市" : selectedPlace1)
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
                .sheet(isPresented: $showPlacePicker1) {
                    PlacePicker(selectedPlace: $selectedPlace1)
                        .presentationDetents([.medium])
                }
                //目的地
                     HStack{
                         Text("*目的地")
                             .bold()
                             .foregroundStyle(.black)
                             .font(.system(size: 15))
                         
                     }
                     Button(action: {
                         showPlacePicker2.toggle()
                     }, label: {
                         HStack {
                             Text(selectedPlace2.isEmpty ? "台北市" : selectedPlace2)
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
                     .sheet(isPresented: $showPlacePicker2) {
                         PlacePicker(selectedPlace: $selectedPlace2)
                             .presentationDetents([.medium])
                     }
                     
                     
                
                HStack {
                    RadioButtonsGroup(callback: { selected in
                        timeChoice = selected
                    })
                    VStack{
            
                        DatePicker(
                            "出發時間",
                            selection: $departureTime,
                            displayedComponents: .hourAndMinute
                        )
                        .scaleEffect(0.8)
                        .disabled(timeChoice != Time.departure.rawValue)
                        .labelsHidden()
                        .opacity(timeChoice == Time.departure.rawValue ? 1 : 0.5)
                        
             
                        
                        DatePicker(
                            "抵達時間",
                            selection: $arrivalTime,
                            displayedComponents: .hourAndMinute
                        )
                        .scaleEffect(0.8)
                        .disabled(timeChoice != Time.arrival.rawValue)
                        .labelsHidden()
                        .opacity(timeChoice == Time.arrival.rawValue ? 1 : 0.5)
                    }
                  
                }
                .frame(maxWidth: 280, alignment: .leading)
            }
            
            Button {
                // Create a DateFormatter to format the time as "HH:mm" or "H:mm"
                   let formatter = DateFormatter()
                   formatter.dateFormat = "H:mm"
                   
                   // Format the departureTime and arrivalTime using the formatter
                   let formattedDepartureTime = formatter.string(from: departureTime)
                   let formattedArrivalTime = formatter.string(from: arrivalTime)
                   
                   // Construct the message based on the selected timeChoice
                   let message: String
                   if timeChoice == Time.departure.rawValue {
                       message = "我預計 \(formattedDepartureTime) 時從「\(selectedPlace1)」出發，請告訴我該如何抵達「\(selectedPlace2)」？"
                   } else {
                       message = "我預計 \(formattedArrivalTime) 前抵達「\(selectedPlace2)」\n請告訴我該如何從「\(selectedPlace1)」前往？"
                   }
                   
                   onSubmit?(message) // Pass the formatted message back to ChatView
                   
                   showChatTransport = false
            } label: {
                Text("查詢")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 42)
            .background(colorManager.mainColor)
            .cornerRadius(10)
            .padding(.top)
        }
    }
}

struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked: Bool
    let callback: (String) -> ()

    init(id: String, label: String, size: CGFloat = 20, color: Color = Color.init(hex: "5E845B", alpha: 1.0), isMarked: Bool = false, callback: @escaping (String) -> ()) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = 15
        self.isMarked = isMarked
        self.callback = callback
    }

    var body: some View {
        Button(action: {
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .bold()
                    .foregroundStyle(.black)
                    .font(.system(size: 15))
                Spacer()

            }
            .foregroundColor(self.color)
            .foregroundColor(.white)
        }
    }
}

enum Time: String {
    case arrival = "預計抵達時間"
    case departure = "預計出發時間"
}

struct RadioButtonsGroup: View {
    let callback: (String) -> ()
    @State var selectedID: String = Time.departure.rawValue  // Default

    var body: some View {
        VStack {
            departureMajority
                .padding(.top)
            arrivalMajority
                .padding(.vertical)

        }
    }

    var departureMajority: some View {
        RadioButtonField(
            id: Time.departure.rawValue,
            label: Time.departure.rawValue,
            isMarked: selectedID == Time.departure.rawValue,
            callback: radioGroupCallback
        )
    }
    var arrivalMajority: some View {
        RadioButtonField(
            id: Time.arrival.rawValue,
            label: Time.arrival.rawValue,
            isMarked: selectedID == Time.arrival.rawValue,
            callback: radioGroupCallback
        )
    }

    func radioGroupCallback(_ selected: String) {
        selectedID = selected
        callback(selected)
    }

}
#Preview {
    ChatTransport(showChatTransport:  .constant(true))
        .environmentObject(ColorManager()) // 提供 ColorManager 給預覽

}
