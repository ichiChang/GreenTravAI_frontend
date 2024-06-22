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
                
                    
                    Text("Travel Agent")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                    Spacer()
                    
                    Image(systemName: "chevron.down")  
                    // 使用透明的假按钮保持平衡
                      .opacity(0)  // 使其透明
                      .font(.system(size: 30))

                       
                        
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color.init(hex: "5E845B", alpha: 1.0))
                
                ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages, id: \.self) { message in
                            MessageView(currentMessage: message)
                                .id(message)
                        }
                    }
                    .onReceive(Just(messages)) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last, anchor: .bottom)
                        }
                        
                    }.onAppear {
                        withAnimation {
                            proxy.scrollTo(messages.last, anchor: .bottom)
                        }
                    }
                }
                
                // send new message
                HStack {
                    TextField("傳送訊息", text: $newMessage)
                        .padding(15)
                        .textFieldStyle(.roundedBorder)
                        .cornerRadius(20)
                    
                    
                    Button(action: sendMessage)   {
                        Image(systemName: "paperplane")
                        .foregroundStyle(.white)
                        .font(.system(size: 30))
                    }
                }
                .padding(20)
                .background(Color.init(hex: "5E845B", alpha: 1.0))

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
}

struct MessageView : View {
    var currentMessage: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !currentMessage.isCurrentUser {
                Image(.customerService)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .cornerRadius(20)
                    
            } else {
                Spacer()
            }
            MessageCell(contentMessage: currentMessage.content,
                        isCurrentUser: currentMessage.isCurrentUser)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(15)
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
}



