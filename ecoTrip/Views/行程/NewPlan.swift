//
//  NewPlan.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/8.
//

import SwiftUI

struct NewPlan: View {
    @Environment(\.dismiss) var dismiss
    @State private var navigateToPlaceChoice = false

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
            .padding(30)
            NavigationStack {
                          VStack(spacing: 0) {
                              Button {
                                  navigateToPlaceChoice = true
                              } label: {
                                  HStack {
                                      Text("選擇地點")
                                          .font(.system(size: 25))
                                          .foregroundStyle(.black)
                                          .padding()
                                      Spacer()
                                          .frame(width: 150)
                                      Image(systemName: "chevron.right")
                                          .resizable()
                                          .bold()
                                          .frame(width: 15, height: 15)
                                          .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                                  }
                              }
                              .padding(.horizontal)

                              Divider()
                                  .frame(minHeight: 2)
                                  .frame(width: 295)
                                  .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                                  .padding(.bottom)

                              Button {
                                  
                              } label: {
                                  HStack {
                                      Text("選擇時間")
                                          .font(.system(size: 25))
                                          .foregroundStyle(.black)
                                          .padding()
                                      Spacer()
                                          .frame(width: 150)
                                      Image(systemName: "chevron.right")
                                          .resizable()
                                          .bold()
                                          .frame(width: 15, height: 15)
                                          .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                                  }
                              }
                              .padding(.horizontal)

                              Divider()
                                  .frame(minHeight: 2)
                                  .frame(width: 295)
                                  .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                                  .padding(.bottom)

                              Button {
                                  
                              } label: {
                                  HStack {
                                      Text("新增備註")
                                          .font(.system(size: 25))
                                          .foregroundStyle(.black)
                                          .padding()
                                      Spacer()
                                          .frame(width: 150)
                                      Image(systemName: "chevron.right")
                                          .resizable()
                                          .bold()
                                          .frame(width: 15, height: 15)
                                          .foregroundStyle(Color.init(hex: "8F785C", alpha: 1.0))
                                  }
                              }
                              .padding(.horizontal)

                              Divider()
                                  .frame(minHeight: 2)
                                  .frame(width: 295)
                                  .overlay(Color.init(hex: "D9D9D9", alpha: 1.0))
                                  .padding(.bottom)

                              Spacer()

                              Button(action: {
                                  
                              }, label: {
                                  Text("新增")
                                      .bold()
                                      .font(.system(size: 25))
                                      .foregroundColor(.white)
                              })
                              .frame(width: 300, height: 42)
                              .background(Color.init(hex: "5E845B", alpha: 1.0))
                              .cornerRadius(10)
                              .padding()
                          }
                          .navigationDestination(isPresented: $navigateToPlaceChoice) {
                              PlaceChoice()
                          }
            }
       
        }
        
    }
}

#Preview {
    NewPlan()
}
