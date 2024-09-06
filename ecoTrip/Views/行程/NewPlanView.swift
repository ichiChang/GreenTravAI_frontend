//
//  NewPlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/6.
//

import SwiftUI

struct NewPlanView: View {
    @State private var arrivalTime: Date = Date()
    @State private var departureTime: Date = Date()
    @State private var textInput = ""
    @Binding var showNewPlan: Bool
    @State private var navigateToPlaceChoice = false

    
    var body: some View {
        VStack{
            
            Button{
                showNewPlan = false
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
                        Text("選擇地點")
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .frame(maxWidth: 150, alignment: .leading)
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
                    PlaceChoice(navigateToPlaceChoice: $navigateToPlaceChoice)
                }
                
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom)
                
                HStack {
                    Text("抵達時間")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 150, alignment: .leading)
                    
                    DatePicker(
                        "",
                        selection: $arrivalTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .frame(width: 145, height: 45)
                    .scaleEffect(1.3)
                }
                .frame(width: 295)
                
                Divider()
                    .frame(minHeight: 2)
                    .frame(width: 295)
                    .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                    .padding(.bottom)
                
                HStack {
                    Text("預計離開時間")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 150, alignment: .leading)
                    
                    
                    DatePicker(
                        "",
                        selection: $departureTime,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .frame(width: 150, height: 45)
                    .scaleEffect(1.3)
                    
                }
                .frame(width: 295)
                
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
                        .font(.custom("HelveticaNeue", size: 20)) // Adjust font size and font family as needed
                    
                }
                .padding([.horizontal], 30)
                .padding([.bottom], 30)
                
                Button(action: {
                    showNewPlan = false
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

#Preview {
    NewPlanView(showNewPlan: .constant(false))
}

