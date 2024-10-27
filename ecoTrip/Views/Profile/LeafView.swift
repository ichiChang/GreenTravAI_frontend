import SwiftUI

struct LeafView: View {
    @State private var ecoPercentage: CGFloat = 80
    @State private var piePercentage1: CGFloat = 83
    @State private var piePercentage2: CGFloat = 68
    @State private var progressBarPercentage: CGFloat = 42
    
    var body: some View {
        ScrollView{
            VStack(alignment:.center) {
                
                Text("您的旅行計劃預估減少")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top)

                
                Text("3,000 克")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                    .padding()

                
                Text("的二氧化碳排放量")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.bottom)

                
                Divider()
                    .frame(minHeight: 10)
                    .overlay(Color.init(hex: "F2F2F2", alpha: 1.0))

                
                VStack(alignment: .leading) {
                    Text("3,000 克二氧化碳相當於")
                        .font(.system(size: 20))
                        .bold()
                        .padding()
                    
                    // 減少碳排放的相等項目
                    VStack(alignment:.center) {
                        ItemRow(iconName: "car.fill", description: "駕駛汽油車 20 km 的碳排放")
                        Divider()
                            .frame(minHeight: 1)
                            .frame(width: 320)
                            .overlay(Color.init(hex: "999999", alpha: 1.0))
                        ItemRow(iconName: "tree.fill", description: "21 平方公尺的森林一年內在大氣中所移除的二氧化碳")
                        Divider()
                            .frame(minHeight: 1)
                            .frame(width: 320)
                            .overlay(Color.init(hex: "999999", alpha: 1.0))
                        ItemRow(iconName: "lightbulb.max.fill", description: "一個 9W LED 燈泡使用 8 小時 的碳排放")
                        Divider()
                            .frame(minHeight: 1)
                            .frame(width: 320)
                            .overlay(Color.init(hex: "999999", alpha: 1.0))
                        ItemRow(iconName: "waterbottle.fill", description: "減少生產 8 個 500ml 的 PET 寶特瓶")
                    }
                }
                .padding()

                Divider()
                    .frame(minHeight: 10)
                    .overlay(Color.init(hex: "F2F2F2", alpha: 1.0))
               
                
                Text("您的環保程度已超越\(Int(ecoPercentage))%用戶！")
                    .bold()
                    .font(.system(size: 20))
                    .padding()
                
                Spacer()
                    .frame(height: 30)
                
                // Pie Charts
                HStack(spacing: 30) {
                    VStack {
                        PieChart(percentage: piePercentage1)
                            .frame(width: 90, height: 90)
                        Text("選擇低碳交通比例")
                            .bold()
                            .font(.system(size: 15))
                            .padding(.vertical)
                    }
                    
                    VStack {
                        PieChart(percentage: piePercentage2)
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
                .padding(.trailing,10)

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

