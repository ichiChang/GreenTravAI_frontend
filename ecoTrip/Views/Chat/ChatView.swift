//
//  ChatView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/5/26.
//

import Combine
import SwiftUI

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @State var messages = DataSource.messages
    @State var newMessage: String = ""
    let buttons = ["行程規劃", "交通查詢", "票價查詢", "住宿推薦"]
    @State private var isEnabled = false
    
    //四個PopUp
    @State private var showChatPlan = false
    @State private var showChatTransport = false
    @State private var showChatTicket = false
    @State private var showChatAccom = false
    
    @EnvironmentObject var colorManager: ColorManager


    var body: some View {
        NavigationView{
            VStack(spacing:0) {
                HStack {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                        
                    }
                    Spacer()
                    
                    
                    Toggle(isOn: $isEnabled) {
                        // 無顯示的內容
                    }
                    .frame(width: 150)
                    .toggleStyle(ColoredToggleStyle(label: "減碳模式", onColor: .green, offColor: Color.init(hex: "413629", alpha: 0.6), thumbColor: .white))
                    .onChange(of: isEnabled) { newValue in
                        colorManager.mainColor = newValue ? Color(hex: "5E845B") : Color(hex: "8F785C")
                    }

                    
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(colorManager.mainColor)
                
                
                ScrollViewReader { proxy in
                    
                    //選單畫面
                    ScrollView{
                        Spacer()
                        
                        Image(.leafLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width:80)
                            .padding(.top,60)
                            .padding(.bottom,20)
                        
                        //四個按鈕
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                            ForEach(buttons, id: \.self) { buttonLabel in
                                Button(action: {
                                    handleButtonTap(buttonLabel: buttonLabel)
                                }) {
                                    Text(buttonLabel)
                                        .font(.system(size: 18))
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(width: 120, height: 80)
                                        .background(Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(colorManager.mainColor, lineWidth: 2)
                                        )
                                }
                                
                            }
                        }
                    }
                    .frame(width:280)
                    .padding()
                    
                    
                }
                
                //對話
                //                ScrollView {
                //                    LazyVStack {
                //                        ForEach(messages, id: \.self) { message in
                //                            MessageView(currentMessage: message)
                //                                .id(message)
                //                        }
                //                    }
                //                    .onReceive(Just(messages)) { _ in
                //                        withAnimation {
                //                            proxy.scrollTo(messages.last, anchor: .bottom)
                //                        }
                //
                //                    }.onAppear {
                //                        withAnimation {
                //                            proxy.scrollTo(messages.last, anchor: .bottom)
                //                        }
                //                    }
                //                }
                
                
                // Textfield
                HStack {
                    TextField("Aa", text: $newMessage)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.init(hex: "F5EFCF", alpha: 1.0)))
                        .padding(.top,10)
                        .padding(.leading,10)
                    
                    
                    
                    Button(action: sendMessage)   {
                        Image(systemName: "paperplane.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                            .padding(.top,5)
                            .padding(.trailing,10)
                        
                        
                    }
                }
                .frame(height: 80)
                .padding(.horizontal)
                .background(colorManager.mainColor)
                
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatPlan) {
                        ChatPlan(showChatPlan: $showChatPlan)
                    }
            .popupNavigationView(horizontalPadding: 40, show: $showChatTransport) {
                ChatTransport(showChatTransport: $showChatTransport)
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatTicket) {
                ChatTicket(showChatTicket: $showChatTicket)
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatAccom) {
                ChatAccom(showChatAccom: $showChatAccom)
            }
            
        }
    }
    func sendMessage() {
        
        if !newMessage.isEmpty{
            messages.append(Message(content: newMessage, isCurrentUser: true))
            messages.append(Message(content: "Reply of " + newMessage , isCurrentUser: false))
            newMessage = ""
        }
    }
    
    func handleButtonTap(buttonLabel: String) {
        switch buttonLabel {
        case "行程規劃":
            showChatPlan.toggle()
        case "交通查詢":
            showChatTransport.toggle()
        case "票價查詢":
            showChatTicket.toggle()
        case "住宿推薦":
            showChatAccom.toggle()
        default:
            break
        }
    }
        
}

struct OvalBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.init(hex: "F5EFCF", alpha: 1.0))
            )
    }
}
    
struct MessageView : View {
    var currentMessage: Message
    
    var body: some View {
   
            HStack(alignment: .top, spacing: 10) {
                if !currentMessage.isCurrentUser {
                    Image(.travelAgent)
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .cornerRadius(20)
                        .padding(.leading,20)
                    
                    MessageCell(
                        contentMessage:currentMessage.content,
                        isCurrentUser:currentMessage.isCurrentUser)
                    .frame(width: 270,alignment: currentMessage.isCurrentUser ? .trailing : .leading)
                    Spacer()
                        
                } else {
                    Spacer()
                    
                    MessageCell(
                        contentMessage:currentMessage.content,
                        isCurrentUser:currentMessage.isCurrentUser)
                    .frame(width: 250,alignment: currentMessage.isCurrentUser ? .trailing : .leading)
                    .padding(.trailing,20)

                }
          
            }
            .padding(.top,12)
        }
        
    }

struct MessageCell: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {

            Text(contentMessage)
                .padding(10)
                .foregroundColor(isCurrentUser ? Color.white : Color.black)
                .background(isCurrentUser ? Color.init(hex: "8F785C", alpha: 1.0) : Color.init(hex: "F5EFCF", alpha: 1.0))
                .cornerRadius(10)
  
       
            
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color.green
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
                .font(.system(size: 15))
                .bold()
      
            Button(action: { configuration.isOn.toggle() }) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(0.7)
                            .offset(x: configuration.isOn ? 10 : -10)
                    )
                 
            }
        }
    }
}



extension Color {
    static let cloloABC = Color(hex: "#FFFFFF", alpha: 0.5)

    init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        assert(hex.count == 3 || hex.count == 6 || hex.count == 8, "Invalid hex code used. hex count is #(3, 6, 8).")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(alpha)
        )
    }
}




#Preview {
    ChatView()
        .environmentObject(ColorManager()) // 提供 ColorManager 給預覽

}



