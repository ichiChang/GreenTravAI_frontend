//
//  CopyPlanPop.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/10/31.
//

import SwiftUI

struct CopyPlanPop: View {
    @Binding var showCopyPlan: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showCopyPlan = false
                }) {
                    Image(systemName: "xmark")
                }
                .padding()
                Spacer()
            }
            
            Spacer()

            Text("成功複製此行程！")
                .font(.system(size: 30))
                .padding()
            
            Button(action: {
            
            }) {
                Text("查看此旅行計劃")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 150, height: 50)
                    .background(Color(hex: "8F785C", alpha: 1.0))
                    .cornerRadius(15)
            }
            .padding()
            
            Spacer()
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


