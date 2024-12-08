import SwiftUI

struct LowCarbonView: View {
    var name: String
    var address: String
    var image: Image
    var websiteURL: String
    var phoneNumber: String
    var openingHours: String
    @Binding var showJPicker: Bool
    @Binding var selectedRecommendation: Recommendation?
    @Binding var navigateToPlanView: Bool
    
    @EnvironmentObject var travelPlanViewModel: TravelPlanViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                HStack {
                    // Display lowCarbon icon
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                        
                        Image(systemName: "leaf.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color(hex: "5E845B", alpha: 1.0))
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    // Heart button for favoriting a place
                    FavoriteButton()
                }
                .frame(width: 280, height: 60)
                .zIndex(1)
                
                // Place image
                NavigationLink(destination: LowCarbonSiteInfoView(
                            name: name,
                            address: address,
                            image: image,
                            websiteURL: websiteURL,
                            phoneNumber: phoneNumber,
                            openingHours: openingHours
                        )) {
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
                    // Convert placeModel to Recommendation
                    let recommendation = Recommendation(
                        Activity: name,
                        Address: address,
                        Location: name,
                        description: "推薦的地方",
                        latency: "30"
                    )
                    selectedRecommendation = recommendation
                    showJPicker.toggle()
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
    @Binding var showJPicker: Bool
    @Binding var selectedRecommendation: Recommendation?
    @Binding var navigateToPlanView: Bool

    @ObservedObject var travelPlanViewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    
let places = [
    (
        name: "Blue磚塊廚房",
        address: "106台北市大安區敦南街38號",
        image: Image("2"),
        websiteURL: "https://www.facebook.com/BlueBricks.tw/?locale=zh_TW",
        phoneNumber: "無提供",
        openingHours: "星期一: 11:00–15:00、17:00–20:00\n星期二: 11:00–15:00、17:00–20:00\n星期三: 11:00–15:00、17:00–20:00\n星期四: 11:00–15:00、17:00–20:00\n星期五: 11:00–15:00、17:00–20:00\n星期六: 休息\n星期日: 休息"
    ),
    (
        name: "陽明山國家公園",
        address: "台北市士林區竹子湖路1-20號",
        image: Image("3"),
        websiteURL: "http://www.ymsnp.gov.tw/",
        phoneNumber: "02 2861 3601",
        openingHours: "每日: 08:00–17:00"
    ),
    (
        name: "臺大農場農藝分場",
        address: "106台北市大安區基隆路四段42巷5號",
        image: Image("4"),
        websiteURL: "https://www.bluebrickcafe.com/",
        phoneNumber: "02 3366 2560",
        openingHours: "星期一: 09:00–17:00\n星期二: 09:00–17:00\n星期三: 09:00–17:00\n星期四: 09:00–17:00\n星期五: 09:00–17:00\n星期六: 休息\n星期日: 休息"
    ),
    (
        name: "meet蘋果咖啡館",
        address: "100台北市中正區博愛路86號",
        image: Image("5"),
        websiteURL: "https://www.cax.com.tw/",
        phoneNumber: "02 2382 0025",
        openingHours: "星期一: 08:00–22:00\n星期二: 08:00–22:00\n星期三: 08:00–22:00\n星期四: 08:00–22:00\n星期五: 08:00–22:00\n星期六: 12:00–22:00\n星期日: 12:00–22:00"
    ),
    (
        name: "Chinese Whispers 悄悄話餐酒館",
        address: "106台北市大安區仁愛路四段345巷2弄11號",
        image: Image("6"),
        websiteURL: "https://shop.ichefpos.com/store/YX36NfJV/reserve",
        phoneNumber: "02 2778 3978",
        openingHours: "每日: 18:00–01:00"
    ),
    (
        name: "臺北市立動物園",
        address: "116台北市文山區新光路二段30號",
        image: Image("1"),
        websiteURL: "http://www.zoo.gov.taipei/",
        phoneNumber: "02 2938 2300",
        openingHours: "每日: 09:00–17:00"
    ),
    (
        name: "Chao 炒炒蔬食熱炒",
        address: "106070台北市大安區大安路一段52巷21號",
        image: Image("7"),
        websiteURL: "https://www.thefuturetw.com/",
        phoneNumber: "02 2775 3005",
        openingHours: "星期一: 17:00–23:00\n星期二: 17:00–23:00\n星期三: 17:00–23:00\n星期四: 17:00–23:00\n星期五: 17:00–23:00\n星期六: 11:00–14:30、17:00–23:00\n星期日: 11:00–14:30、17:00–23:00"
    ),
    (
        name: "福華國際文教會館",
        address: "106台北市大安區新生南路三段30號",
        image: Image("8"),
        websiteURL: "https://www.howard-hotels.com.tw/zh_TW/HotelBusiness/96",
        phoneNumber: "02 7712 2323",
        openingHours: "每日: 00:00–24:00"
    ),
    (
        name: "小公館人文旅舍",
        address: "105台北市松山區南京東路五段399號5F",
        image: Image("9"),
        websiteURL: "http://www.nkhostel.com/",
        phoneNumber: "02 2769 0200",
        openingHours: "每日: 00:00–24:00"
    ),
    (
        name: "初點良食 Dim sum shop",
        address: "10491台北市中山區龍江路394巷2號1樓",
        image: Image("10"),
        websiteURL: "https://www.facebook.com/p/初點良食-Dim-sum-shop-100083217608064/",
        phoneNumber: "無提供",
        openingHours: "星期一: 11:30–19:00\n星期二: 11:30–19:00\n星期三: 11:30–19:00\n星期四: 11:30–19:00\n星期五: 11:30–19:00\n星期六: 11:30–19:00\n星期日: 休息"
    ),
    (
        name: "臺北典藏植物園",
        address: "10491台北市中山區濱江街16號",
        image: Image("11"),
        websiteURL: "http://www.future.url.tw/",
        phoneNumber: "02 2585 2955",
        openingHours: "星期一: 休息\n星期二: 09:00–17:00\n星期三: 09:00–17:00\n星期四: 09:00–17:00\n星期五: 09:00–17:00\n星期六: 09:00–17:00\n星期日: 09:00–17:00"
    ),
    (
        name: "芝山文化生態綠園",
        address: "111台北市士林區雨聲街120號",
        image: Image("12"),
        websiteURL: "https://www.zcegarden.org.tw/",
        phoneNumber: "02 8866 6258",
        openingHours: "星期一: 休息\n星期二: 09:00–17:00\n星期三: 09:00–17:00\n星期四: 09:00–17:00\n星期五: 09:00–17:00\n星期六: 09:00–17:00\n星期日: 09:00–17:00"
    ),
]

    
    var body: some View {
        ScrollView {
            ForEach(places, id: \.name) { place in
                LowCarbonView(
                    name: place.name,
                    address: place.address,
                    image: place.image,
                    websiteURL: place.websiteURL,
                    phoneNumber: place.phoneNumber,
                    openingHours: place.openingHours,
                    showJPicker: $showJPicker,
                    selectedRecommendation: $selectedRecommendation,
                    navigateToPlanView: $navigateToPlanView
                )
                .environmentObject(travelPlanViewModel)
                .environmentObject(authViewModel)
            }

        }

    }
}

struct FavoriteButton: View {
    var body: some View {
        Button(action: {
            // TODO: Implement favorite action
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(5)
                
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(Color(hex: "5E845B", alpha: 1.0))
                    .bold()
            }
        })
    }
}
