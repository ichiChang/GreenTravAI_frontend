//
//  Demo.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/8/6.
//

import SwiftUI

struct Demo: View {
    @State private var selectedDot = 0
    @Binding var showDemo: Bool

    var currentView: some View {
        switch selectedDot {
        case 0:
            return AnyView(Text("點選「新增行程」，輸入行程基本資訊")
                .bold()
                .font(.system(size: 15))
            )
        case 1:
            return AnyView(Text("可根據即時路況隨意更改交通方式")
                .bold()
                .font(.system(size: 15)))
        case 2:
            return AnyView(Text("行程方塊可拖曳以更改行程順序")
                .bold()
                .font(.system(size: 15)))
        case 3:
            return AnyView(  
    
                    HStack{
                        Text("點選")
                            .bold()
                            .font(.system(size: 15))
                        
                        ZStack {
                            Circle()
                                .foregroundColor(Color.init(hex: "8F785C", alpha: 1.0))
                                .frame(width: 30, height: 30)
                                .padding(5)
                            
                            Image(systemName: "map")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                                .bold()
                        }
                        
                        Text("可查看行程路線順序")
                            .bold()
                            .font(.system(size: 15))
                     
                    
            })
        default:
            return AnyView(EmptyView())
        }
    }

    var body: some View {
        VStack {
    
            Button(action: {
                showDemo = false
            }, label: {
                HStack{
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    Spacer()
                }
                .frame(width: 280)
                
            })
            
            Spacer()
            
            VStack {
                currentView
                    .padding()
                
                HStack {
                    ForEach(0..<4) { index in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(index == selectedDot ? Color.init(hex: "5E845B", alpha: 1.0) : Color.init(hex: "D9D9D9", alpha: 1.0))
                            .onTapGesture {
                                withAnimation {
                                    selectedDot = index
                                }
                            }
                    }
                }
                .padding(.bottom)
                
                if selectedDot == 3 {
                    Button {
                        showDemo = false

                    } label: {
                        Text("結束")
                            .bold()
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                    }
                    .frame(width: 80, height: 42)
                    .background(Color.init(hex: "5E845B", alpha: 1.0))
                    .cornerRadius(20)
                }
            }
        }
        .padding()

    }

}

#Preview {
    Demo(showDemo: .constant(false))
}
