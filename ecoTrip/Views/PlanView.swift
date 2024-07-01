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
    
    var body: some View {
        VStack {
            HStack {
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                    
                }
                Spacer()
                
                
                Image(systemName: "chevron.down")
                // 使用透明的假按钮保持平衡
                    .opacity(0)  // 使其透明
                    .font(.system(size: 30))
                
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            

            
            // Day section
            HStack(alignment:.bottom, spacing:0) {
                // Day1
                Button(action: {
                    self.indexd = 0
                    
                }, label: {
                    HStack {
                        
                        Text("7/1")
                            .font(.title3)
                            .foregroundColor(indexd == 0 ? .black : Color.init(hex: "999999", alpha: 1.0))
                        
                    }
                    .frame(width: 90, height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(indexd == 0 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                    )
                })
           
                
                // 餐廳 button
                Button(action: {
                    self.indexd = 1
                }, label: {
                    HStack {
                        Text("7/2")
                            .foregroundColor(indexd == 1 ? .black : Color.init(hex: "999999", alpha: 1.0))
                    }
       
                    .frame(width: 90, height: 41)
                    .background(Color.init(hex: "F5EFCF", alpha: 1.0))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(indexd == 1 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                    )
                })
    
                
                // 住宿 button
                Button(action: {
                    self.indexd = 2
                    
                }, label: {
                    HStack {
                        Text("7/3")
                            .foregroundColor(indexd == 2 ? .black : Color.init(hex: "999999", alpha: 1.0))
                    }
             
                    .frame(width: 90, height: 41)
                    .background(Color.init(hex: "F5EFCF", alpha: 1.0))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(indexd == 2 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                    )
                })
         
                
                Button(action: {
                    self.indexd = 2
                    
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 21, height: 21)
                  
                    }
                    .padding(10)
                    .frame(width: 45, height: 41)
                    .background(Color.init(hex: "D1CECE", alpha: 1.0))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(indexd == 2 ? .black : Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                    )
                })
                
            Spacer()
          
            }
            .padding(.top)
            .padding(.trailing)
            .padding(.bottom)
            
            Spacer()
        }
    }
}

#Preview {
    PlanView( indexd: .constant(0))
}
