import SwiftUI

struct LeafView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        Group {
            if userViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))
            } else if let error = userViewModel.error {
                // 顯示錯誤訊息
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .padding()
            } else {
                // 資料加載完成後顯示主要內容
                ScrollView {
                    VStack(alignment: .center) {
                        Text("您的旅行交通規劃預估減少")
                            .bold()
                            .font(.system(size: 20))
                            .padding(.top)
                        
                        Text("\(String(format: "%.1f", userViewModel.emissionReduction)) 克")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                            .padding()
                        
                        Text("的二氧化碳排放量")
                            .bold()
                            .font(.system(size: 20))
                            .padding(.bottom)
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.init(hex: "F2F2F2", alpha: 1.0))
                        
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", userViewModel.emissionReduction)) 克二氧化碳相當於")
                                .font(.system(size: 20))
                                .bold()
                                .padding()
                            
                            // 減少碳排放的相等項目
                            VStack(alignment: .center, spacing: 0) {
                                ItemRow(iconName: "car.fill", description: "駕駛汽油車 \(String(format: "%.1f", userViewModel.emissionReduction / 150)) km 的碳排放")
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.init(hex: "999999", alpha: 1.0))
                                ItemRow(iconName: "tree.fill", description: "\(String(format: "%.1f", userViewModel.emissionReduction / 207.5)) 平方公尺的森林一年內在大氣中所移除的二氧化碳")
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.init(hex: "999999", alpha: 1.0))
                                ItemRow(iconName: "lightbulb.max.fill", description: "一個 9W LED 燈泡使用 \(String(format: "%.1f", userViewModel.emissionReduction / 4.75)) 小時 的碳排放")
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.init(hex: "999999", alpha: 1.0))
                                ItemRow(iconName: "waterbottle.fill", description: "減少生產 \(String(format: "%.1f", userViewModel.emissionReduction / 82.8)) 個 500ml 的 PET 寶特瓶")
                            }
                        }
                        .padding()
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color.init(hex: "F2F2F2", alpha: 1.0))
                        
                        Text("您的環保程度已超越\(Int(userViewModel.greenPercentile))%用戶！")
                            .bold()
                            .font(.system(size: 20))
                            .padding()
                        
                        Spacer()
                            .frame(height: 30)
                        
                        // 圓餅圖
                        HStack(spacing: 30) {
                            VStack {
                                PieChart(percentage: userViewModel.greenTransRate)
                                    .frame(width: 90, height: 90)
                                Text("選擇低碳交通比例")
                                    .bold()
                                    .font(.system(size: 15))
                                    .padding(.vertical)
                            }
                            
                            VStack {
                                PieChart(percentage: userViewModel.greenSpotRate)
                                    .frame(width: 90, height: 90)
                                Text("選擇綠色景點比例")
                                    .bold()
                                    .font(.system(size: 15))
                                    .padding(.vertical)
                            }
                        }
                        .padding()
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
        }
        .onAppear {
            if let token = authViewModel.accessToken {
                userViewModel.fetchEcoContribution(token: token)
            }
        }
    }
    
    // ItemRow 為每個減少碳排放的相等項目
    struct ItemRow: View {
        let iconName: String
        let description: String
        
        var body: some View {
            HStack(alignment: .center) {
                Image(systemName: iconName)
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                    .font(.title2)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // PieChart 圖表的實現
    struct PieChart: View {
        var percentage: CGFloat
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                
                Circle()
                    .trim(from: 0.0, to: percentage / 100)
                    .stroke(Color.init(hex: "5E845B", alpha: 1.0), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: percentage)
                
                Text("\(Int(percentage))%")
                    .font(.system(size: 20))
                    .bold()
            }
        }
    }
    
    // ProgressBar 圖表的實現（未在主要視圖中使用）
    struct ProgressBar: View {
        var percentage: CGFloat
        
        var body: some View {
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.3))
                            .frame(height: 20)
                        
                        Rectangle()
                            .foregroundColor(Color.green)
                            .frame(width: geometry.size.width * (percentage / 100), height: 20)
                            .animation(.linear, value: percentage)
                    }
                    .cornerRadius(10)
                }
                Text("\(Int(percentage))%")
                    .font(.system(size: 20))
                    .bold()
                    .padding(.leading, 5)  // Bar 和文字之間的間距
            }
        }
    }
}
