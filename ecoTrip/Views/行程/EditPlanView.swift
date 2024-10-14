//
//  EditPlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/10/14.
//



import SwiftUI

struct EditPlanView: View {
    @State private var textInput = ""
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @Environment(\.dismiss) var dismiss
    @Binding var stop: String
    @State private var navigateToPlaceChoice = false
    @State private var selectedPlace: PlaceModel?

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
            .padding(20)
            
            NavigationStack {
                Button {
                    navigateToPlaceChoice = true

                } label: {
                    HStack {
                        Text(selectedPlace?.name ?? stop)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .frame(alignment: .leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .bold()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                    }
                    .frame(width: 295,height: 45)
                }
                .navigationDestination(isPresented: $navigateToPlaceChoice) {
                    PlaceChoice(selectedPlace: $selectedPlace)
                }

            
                
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom)
                
                
                HStack(spacing:0) {
                    Text("預計停留時間")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 130, alignment: .leading)
                        .layoutPriority(1)  // Give the text priority to take up space

 
                    Picker("", selection: $hours){
                            ForEach(0..<9, id: \.self) { i in
                                Text(" \(i) hrs").tag(i)
                                    .font(.system(size: 20))
                            }
                        }.pickerStyle(WheelPickerStyle())
                    
                    Picker("", selection: $minutes){
                        ForEach(0..<60, id: \.self) { i in
                            Text("\(i) ").tag(i)
                                .font(.system(size: 20))
                        }
                    }.pickerStyle(WheelPickerStyle())
                    
                }
                .frame(width: 295, height: 120)
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom)
                
                HStack{
                    
                    Text("行程細節備註")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 150, alignment: .leading)
                    
                    Spacer()
                }
                .frame(width: 295,height: 45)
                
                // Text field
                ZStack {
                    
                    // Background Color
                    Color(hex: "D9D9D9")
                        .cornerRadius(20)
                        .frame(width: 300, height: 150)
                    
                    // TextEditor with padding
                    TextEditor(text: $textInput)
                        .padding()
                        .background(Color.clear)
                        .frame(width: 300, height: 150)
                        .cornerRadius(20)
                        .colorMultiply(Color.init(hex: "D9D9D9", alpha: 1.0))
                        .font(.custom("HelveticaNeue", size: 15))
                    
                }
                .padding([.horizontal], 30)
                .padding([.bottom], 30)
                
                Button(action: {
                }, label: {
                    Text("確定")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
                .frame(width: 295, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
            }

        }

    }
}


