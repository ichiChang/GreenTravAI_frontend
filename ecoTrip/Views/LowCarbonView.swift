import SwiftUI

// Individual low-carbon place view
struct LowCarbonView: View {
    var name: String
    var address: String
    var image: Image

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                HStack {
                    // Display lowCarbon icon
                    ZStack {
                        Circle()  // 白色圓形背景
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "leaf.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    // Heart button for favoriting a place
                    Button(action: {
                        // TODO: favorite
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(5)
                            
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                                .bold()
                        }
                    })
                }
                .frame(width: 280, height: 60)
                .zIndex(1)
                
                // Place image
                NavigationLink(destination: LowCarbonSiteInfoView(name: name, address: address, image: image)) {
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 280, height: 130)
                        .clipped()
                }
            }
            
            HStack(spacing: 0) {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top, 15)
                        .padding(.leading, 10)
                        .padding(.bottom, 3)
                    
                    Text(address)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                        .padding(.bottom, 15)
                        .frame(maxWidth: 200)
                }
                Spacer()
                
                Button(action: {
                    // 按鈕動作
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.black)
                        .padding(.trailing, 15)
                }
            }
            .frame(width: 280, height: 60, alignment: .leading)
            .background(Color.white)
        }
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(20)
    }
}

// Main list view for displaying multiple low-carbon places
struct LowCarbonListView: View {
    let places = [
        (name: "臺北市立動物園", address: "116台北市文山區新光路二段30號", image: Image("1")),
        (name: "Blue磚塊廚房", address: "106台北市大安區敦南街38號", image: Image("2")),
        (name: "陽明山國家公園", address: "台北市士林區竹子湖路1-20號", image: Image("3")),
        (name: "臺大農場農藝分場", address: "106台北市大安區基隆路四段42巷5號", image: Image("4")),
        (name: "meet蘋果咖啡館", address: "100台北市中正區博愛路86號", image: Image("5")),
        (name: "Chinese Whispers 悄悄話餐酒館", address: "106台北市大安區仁愛路四段345巷2弄11號", image: Image("6")),
        (name: "Chao 炒炒蔬食熱炒", address: "106070台北市大安區大安路一段52巷21號", image: Image("7")),
        (name: "福華國際文教會館", address: "106台北市大安區新生南路三段30號", image: Image("8")),
        (name: "小公館人文旅舍", address: "105台北市松山區南京東路五段399號5F", image: Image("9")),
        (name: "初點良食 Dim sum shop", address: "10491台北市中山區龍江路394巷2號1樓", image: Image("10")),
        (name: "臺北典藏植物園", address: "10491台北市中山區濱江街16號", image: Image("11")),
        (name: "芝山文化生態綠園", address: "111台北市士林區雨聲街120號", image: Image("12"))
    ]
    
    var body: some View {
        ScrollView {
            ForEach(places, id: \.name) { place in
                LowCarbonView(name: place.name, address: place.address, image: place.image)
            }
        }
    }
}

