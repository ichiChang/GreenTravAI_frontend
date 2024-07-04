//
//  MenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/22.
//
import SwiftUI

struct MenuView: View {
    @State var index = 0
    @State var index1 = 0
    @State var indexd = 0
    @State var showChatView = false
    @State var showPlanView = false
  

    
    var body: some View {
            VStack {
                SearchView(index1: $index1)
                
                
                CustomTabs(index: $index,
                           showChatView: $showChatView, showPlanView: $showPlanView
                )
                
                
                
            }
            .sheet(isPresented: $showChatView) {
                ChatView()
            }
            .sheet(isPresented: $showPlanView) {
                PlanView(indexd: $indexd)
            }
            
            
            
        

       
    }
}


struct CustomTabs: View {
    @Binding var index: Int
    @Binding var showChatView: Bool
    @Binding var showPlanView: Bool
    
    var body: some View {
        
        Spacer()
        HStack(alignment: .bottom, spacing: 10) {
            Button(action: {
                self.index = 0
            }, label: {
                Image(index == 0 ? "searchGreen" : "searchWhite")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(10)
            })
            
            Button(action: {
                self.index = 1
            }, label: {
                Image(index == 1 ? "squareGreen" : "square")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(10)
            })
            
            Button(action: {
                self.index = 2
                showPlanView.toggle()
            }, label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: "F5EFCF"))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "plus")
                       .resizable()
                       .frame(width: 40, height: 40)
                       .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                       .padding(10)
                }
            })
            
            Button(action: {
                self.index = 3
                showChatView.toggle()
            }, label: {
                Image(index == 3 ? "agent" : "agent")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                    .padding(10)
            })
           
            
            Button(action: {
                self.index = 4
            }, label: {
                Image(index == 4 ? "userInfogreen" : "UserInfo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.black)
                    .padding(10)
            })
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "5E845B"))
        .navigationBarBackButtonHidden(true)

    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
