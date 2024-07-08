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

    
    
    
    // Array to hold the days
    @State var days = ["7/1", "7/2", "7/3"]
    
    var body: some View {
        VStack(spacing:0) {
            // Top bar with back button
            HStack {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                })
                .padding()
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .opacity(0)
                    .font(.system(size: 30))
            }
            .frame(maxWidth: .infinity)
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
                                .foregroundColor(indexd == index ? .black : Color.init(hex: "999999", alpha: 1.0))
                                .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(days.count + 1)), height: 50)
                                .background(indexd == index ? .white : Color.init(hex: "F5EFCF", alpha: 1.0))
                            
                        })
                    }
                    
                    // Add day button
                    Button(action: {
                        let nextDay = "7/\(days.count + 1)"
                        days.append(nextDay)
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    })
                    .frame(width: max(90, UIScreen.main.bounds.width / CGFloat(days.count + 1)), height: 50)
                    .background(Color.init(hex: "D1CECE", alpha: 1.0))
                }
            }
 
            
          
        

            
            PlaceListView()
            
            // 新增行程 button
            Button(action: {
               
                showNewPlan.toggle()

            }, label: {
                Text("新增行程")
                    .bold()
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            })
            .frame(width: 300, height: 42)
            .background(Color.init(hex: "5E845B", alpha: 1.0))
            .cornerRadius(10)
            .padding()
            
            Spacer()
            }
            .sheet(isPresented: $showNewPlan) {
                NewPlan()
                .presentationDetents([.height(650)])

            }
            
         
  
       
        }
      
     
    }

// Preview
struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(indexd: .constant(0))
    }
}
