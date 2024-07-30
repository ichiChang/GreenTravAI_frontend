//
//  PopUp.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/30.
//

import SwiftUI

extension View{
    func popupNavigationView<Content: View>(horizontalPadding: CGFloat = 40, show: Binding<Bool>,@ViewBuilder content: @escaping ()->Content) -> some View{
        return self
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity, alignment: .center)
            .overlay{
            if show.wrappedValue{
                GeometryReader{proxy in
                    Color .primary
                        .opacity(0.3)
                        .ignoresSafeArea()
                    NavigationView {
                        content()
                    }
                    .frame(width: 350, height: 550, alignment: .center)
                    .cornerRadius(15)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: .infinity, alignment: .center)
                    
                }
            }
        }
    }
}
