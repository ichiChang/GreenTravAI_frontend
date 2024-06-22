//
//  MenuView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/22.
//
import SwiftUI

struct MenuView: View {
    @State private var textInput = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            // Search bar
            HStack {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .frame(width: 45, height: 45)
                    .padding(.leading, 10)
                
                // Text field
                TextField(" ", text: $textInput)
                    .onSubmit {
                        print(textInput)
                    }
                    .focused($focus)
                    .padding(.vertical, 10)
                
                // Filter icon
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(.filter)
                        .frame(width: 45, height: 45)
                        .padding(.trailing, 10)
                })
        
            }
            .background(Color.init(hex: "E8E8E8", alpha: 1.0))
            .cornerRadius(10)
            .padding(10)
            .onAppear {
                focus = true
            }
            
            // Button section
            HStack {
                // 附近 button
                Button(action: {}, label: {
                    HStack {
                        Image(.placeMarker).foregroundColor(.black)
                            .frame(width: 21, height: 21)
                        Text("附近")
                            .foregroundStyle(.black)

                    }
                    .padding(10)
                    .frame(width: 90, height: 41)
                    .background(Color.white) // 確保背景顏色與邊框顏色一致
                    .cornerRadius(10) // 設置圓角半徑
                    .overlay(
                       RoundedRectangle(cornerRadius: 5)
                           .stroke(Color.black, lineWidth: 3)
                   )
                })
                .padding(.horizontal,5)
 
                
    
                
                // 餐廳 button
                Button(action: {}, label: {
                    HStack {
                        Image(systemName: "fork.knife").foregroundColor(Color.init(hex: "999999", alpha: 1.0))
                            .frame(width: 21, height: 21)
                        Text("餐廳")
                            .foregroundStyle(Color.init(hex: "999999", alpha: 1.0))

                    }
                    .padding(10)
                    .frame(width: 90, height: 41)
                    .background(Color.white) // 確保背景顏色與邊框顏色一致
                    .cornerRadius(10) // 設置圓角半徑
                    .overlay(
                       RoundedRectangle(cornerRadius: 5)
                           .stroke(Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                   )
                   
                })
                .padding(.horizontal,5)
 
                // 住宿 button
                Button(action: {}, label: {
                    HStack {
                        Image(systemName: "bed.double.fill").foregroundColor(Color.init(hex: "999999", alpha: 1.0))
                            .frame(width: 21, height: 21)
                        Text("住宿")
                            .foregroundStyle(Color.init(hex: "999999", alpha: 1.0))

                    }
                    .padding(10)
                    .frame(width: 90, height: 41)
                    .background(Color.white) // 確保背景顏色與邊框顏色一致
                    .cornerRadius(10) // 設置圓角半徑
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.init(hex: "999999", alpha: 1.0), lineWidth: 3)
                   )
                   
                })
                .padding(.horizontal,5)

            }
            .padding(10)
            
            //site
            
            VStack(spacing:0){
                ZStack(alignment: .topLeading){
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Image(.greenlabel2)
                            .resizable()
                            .frame(width:45,height: 45)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                    .zIndex(1)
                    
                    Image("garden") // 請將 "garden" 替換為您的圖片名稱
                       .resizable()
                       .scaledToFill()
                       .frame(width: 320, height: 150)
                       .clipped()
                    
                }
              

                HStack{
                    VStack(alignment: .leading) {
                        Text("台北植物園").bold()
                            .font(.title2)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                        
                        
                        Text("100台北市中正區南海路53號")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .padding(.bottom, 10)
                        
                     
                    
                    }
                    
                    Spacer()
                        .frame(minWidth: 30, maxWidth: 70)
                    Button(action: {
                        // 按鈕動作
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width:18,height: 18)
                            .foregroundColor(.black)
                            .padding(10)
                    }
                }
                .frame(width: 320, height: 80, alignment: .leading)
                .background(Color.white)
            }
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(20)
            
            Spacer()
            
            Circle()
                .frame(width: 105)
                .offset(y:90)
                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
            
            CustomTabs()

        }
  
            
        }
    


    }


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

struct CustomTabs : View{
    var body: some View{
        HStack(alignment: .bottom, spacing: 10){
            Button(action: {}, label: {
                Image(.searchGreen)
                    .resizable()
                    .frame(width:40,height: 40)
                    .foregroundColor(.black)
                    .padding(10)
            })
            
            Button(action: {}, label: {
                Image(.square)
                    .resizable()
                    .frame(width:40,height: 40)
                    .foregroundColor(.black)
                    .padding(10)
            })
            
            

            
    
            Button(action: {},label: {
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding(10)
            })
              
         
            
            
            
            
            Button(action: {}, label: {
                Image(.agent)
                    .resizable()
                    .frame(width:40,height: 40)
                    .padding(10)
            })
            
            Button(action: {}, label: {
                Image(.userInfo)
                    .resizable()
                    .frame(width:40,height: 40)
                    .padding(10)
            })
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.init(hex: "5E845B", alpha: 1.0))
        
    
    }
}