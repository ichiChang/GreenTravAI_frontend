//
//  OtherAppsView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/9/5.
//

import SwiftUI

struct OtherAppsView: View {
    @Environment(\.openURL) var openURL

    //記下app的種類和有哪些app
    let categories = [
       ("交通", ["Uber", "LINE TAXI", "yoxi"]),
       ("搜尋引擎", ["Google", "小紅書"]),
       ("住宿", ["agoda", "Booking.com"]),
       ("行程規劃", ["Klook", "KKday"])
   ]

   //app的logo名字
   let logos = [
       "Uber": "Uber",
       "LINE TAXI": "Line Taxi",
       "yoxi": "Group 64",
       "Google": "Group 59",
       "小紅書": "Group 58",
       "agoda": "Agoda",
       "Booking.com": "Group 61",
       "Klook": "Klook",
       "KKday": "KKday"
   ]
    
    // 每個app的urlScheme和fallbackURL
     let urls = [
         "Uber": ("uber://", "https://www.uber.com"),
         "LINE TAXI": ("linetaxi://", "https://taxi.line.me"),
         "yoxi": ("yoxi://", "https://www.yoxi.com"),
         "Google": ("googlechrome://", "https://www.google.com"),
         "小紅書": ("xiaohongshu://", "https://www.xiaohongshu.com"),
         "agoda": ("agoda://", "https://www.agoda.com"),
         "Booking.com": ("booking://", "https://www.booking.com"),
         "Klook": ("klook://", "https://www.klook.com"),
         "KKday": ("kkday://", "https://www.kkday.com")
     ]
    
   //定義LazyVGrid的佈局，每行最多3個app
   let columns = [
       GridItem(.flexible(), spacing: 20),
       GridItem(.flexible(), spacing: 20),
       GridItem(.flexible(), spacing: 20)
   ]
    
    func openApp(urlScheme: String, fallbackURL: String) {
          if let url = URL(string: urlScheme) {
              UIApplication.shared.open(url, options: [:]) { success in
                  if !success {
                      // 如果無法打開應用程序，則打開網頁版本
                      openURL(URL(string: fallbackURL)!)
                  }
              }
          }
      }
 
   var body: some View {

           VStack(alignment: .leading, spacing: 30) {
               Text("應用程式")
                   .font(.system(size: 25))
                   .bold()
                   .padding(.leading, 10)
               ScrollView {
                   //迴圈用來重複categories(標題和app)
                   //將它變列舉格式，每個元素會變成 (index, categoryData)
                   ForEach(Array(categories.enumerated()), id: \.offset) { index, categoryData in
                       
                       //拆分 categoryData
                       let (category, apps) = categoryData
                       
                       VStack(alignment: .leading) {
                           Text(category)
                               .font(.system(size: 18))
                               .bold()
                               .padding(.leading, 10)
                               .padding(.bottom, 10)
                           
                           LazyVGrid(columns: columns, spacing: 20) {
                               ForEach(apps, id: \.self) { app in
                                   VStack {
                                       Image(logos[app] ?? "")
                                           .resizable()
                                           .aspectRatio(contentMode: .fit)
                                           .frame(width: 90, height: 90)
                                           .overlay {
                                               RoundedRectangle(cornerRadius: 15)
                                                   .stroke(Color.brown, lineWidth: 2)
    
                                           }
                                           .onTapGesture {
                                              let (urlScheme, fallbackURL) = urls[app] ?? ("", "")
                                              openApp(urlScheme: urlScheme, fallbackURL: fallbackURL)
                                                                                  }
                                            
                                       Text(app)
                                           .font(.system(size: 16))
                                   }
                               }
                           }
                           .padding(.bottom,5)
                           
                           // 最後一個不用分隔線
                           if index < categories.count - 1 {
                               Divider()
                                   .frame(minHeight: 1)
                                   .overlay(Color.init(hex: "D1CECE", alpha: 1.0))
                           }
                       }
                       .padding(5)
                   }
               }
           }
           .padding()
       }
   }

#Preview {
    OtherAppsView()
}
