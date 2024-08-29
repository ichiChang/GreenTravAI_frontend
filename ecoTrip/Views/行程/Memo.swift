//
//  Memo.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/7/11.
//

import SwiftUI

struct Memo: View {
    @State private var textInput = ""
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Bool

    
    var body: some View {
        
        VStack(spacing: 0){
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
            
            Spacer()
            
            HStack{
            
                Text("行程細節備註")
                    .font(.system(size: 20))
                    .padding([.horizontal],30)
                    .padding()

                Spacer()
            }
            // Text field
            ZStack {
                     // Background Color
                     Color(hex: "D9D9D9")
                         .cornerRadius(20)
                         .frame(width: 300, height: 300)

                     // TextEditor with padding
                     TextEditor(text: $textInput)
                         .padding()
                         .background(Color.clear)
                         .frame(width: 300, height: 300)
                         .cornerRadius(20)
                         .colorMultiply(Color.init(hex: "D9D9D9", alpha: 1.0))
                         .focused($focus)
                         .onAppear {
                             focus = true
                         }
                         .font(.custom("HelveticaNeue", size: 20)) // Adjust font size and font family as needed

                 }
                 .padding([.horizontal], 30)
                 .padding([.bottom], 30)


        
 
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    Text("返回")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding(30)
        
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("確定")
                        .bold()
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                })
                .frame(width: 120, height: 42)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                .cornerRadius(10)
                .padding()
      
                
            }
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)

       
          
    }
}

#Preview {
    Memo()
}
