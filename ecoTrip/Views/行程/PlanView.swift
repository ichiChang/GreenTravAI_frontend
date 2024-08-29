//
//  PlanView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/1.
//

import SwiftUI

struct PlanView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var indexd: Int
    @State var showNewPlan = false
    @State private var showDemo = false
    @State private var navigationPath = NavigationPath()
    
    @State private var showChatView = false
    
    // Array to hold the days
    @State var days = ["8/1", "8/2", "8/3"]
    
    var body: some View {
        
        NavigationView{
                VStack(spacing:0) {
                    // Top bar with back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                        })
                        .padding()
                        .offset(x:20,y:40)
                        
                        Spacer()
                            .frame(width:220)
                        
                        Button(action: {
                            showChatView.toggle()
                        }, label: {
                            Image("agent")
                                .resizable()
                                .frame(width: 35, height: 30)
                                .padding(10)
                        })
                        .padding(.horizontal)
                        .offset(x:20,y:40)

                        
                        Button(action: {
                            showDemo.toggle()
                        }, label: {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                                .padding()
                                .offset(x:-20,y:40)
                        })
                        
                        
                        
                    }
                    .ignoresSafeArea()
                    .frame(height:50)
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                    
                    
                    // Days section
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .bottom, spacing: 0) {
                            ForEach(Array(days.enumerated()), id: \.element) { index, day in
                                Button(action: {
                                    self.indexd = index
                                }, label: {
                                    Text(day)
                                        .bold()
                                        .font(.system(size: 20))
                                        .foregroundColor(indexd == index ? .black : .white)
                                        .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(days.count + 1)), height: 40)
                                        .background(indexd == index ? .white : Color.init(hex: "8F785C", alpha: 1.0))
                                    
                                })
                            }
                            
                            // Add day button
                            Button(action: {
                                let nextDay = "8/\(days.count + 1)"
                                days.append(nextDay)
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                            })
                            .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(days.count + 1)), height: 40)
                            .background(Color.init(hex: "B8B7B7", alpha: 1.0))
                        }
                    }
                    .padding(.bottom)
                    
                    
                    
                    PlaceListView()
                    
                    
                    // 新增行程 button
                    
                    Button(action: {
                        
                        showNewPlan.toggle()
                        
                    }, label: {
                        Text("新增行程")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    })
                    .frame(width: 300, height: 42)
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                    .cornerRadius(10)
                    .padding()
                    
                    // 地圖 button
                    Button(action: {
                        
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.init(hex: "8F785C", alpha: 1.0))
                                .frame(width: 60, height: 60)
                                .padding(5)
                            
                            Image(systemName: "map")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                                .bold()
                        }
                    })
                    
                }
            
            }
            .sheet(isPresented: $showNewPlan) {
                NewPlan()
                    .presentationDetents([.height(650)])
                
            }
            .navigationBarBackButtonHidden(true)
            .popupNavigationView(horizontalPadding: 40, show: $showDemo) {
                Demo()
            }
            .sheet(isPresented: $showChatView) {
                ChatView()
            }
        
            
        }
        
    }
    


// Preview
struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(indexd: .constant(0))
    }
}
