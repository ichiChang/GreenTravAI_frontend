//
//  ChatView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/5/26.
//

import SwiftUI
import Combine

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ChatViewModel()

    @State private var newMessage: String = ""
    let buttons = ["行程規劃", "交通查詢", "票價查詢", "住宿推薦"]
    @State private var isEnabled = false
    @State private var isChatView = false
    @State private var showJPicker = false
    @State private var showAlert = false
    @State private var showPlanMenuView = false // State to control navigation


    // Four PopUps
    @State private var showChatPlan = false
    @State private var showChatTransport = false
    @State private var showChatTicket = false
    @State private var showChatAccom = false
    @State private var navigateToMyPlans = false

    @State private var navigateToPlanView = false
    @State private var selectedPlanId: String?
    
    @EnvironmentObject var colorManager: ColorManager
    @ObservedObject var travelPlanViewModel = TravelPlanViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                            .font(.system(size: 30))
                    }
                    Spacer()
                    
                    Toggle(isOn: $isEnabled) {
                        // No display content
                    }
                    .frame(width: 150)
                    .toggleStyle(ColoredToggleStyle(label: "減碳模式", onColor: .green, offColor: Color.init(hex: "413629", alpha: 0.6), thumbColor: .white))
                    .onChange(of: isEnabled) { newValue in
                        colorManager.mainColor = newValue ? Color(hex: "5E845B") : Color(hex: "8F785C")
                    }
                    
                    if isChatView {
                        Button {
                            isChatView = false
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(colorManager.mainColor)
                
                // Chat content
                ScrollViewReader { proxy in
                    ScrollView {
                        if !isChatView{
                            // Initial view when no messages
                            VStack {
                                Spacer()
                                Image(.leafLogo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                                    .padding(.top, 60)
                                    .padding(.bottom, 20)
                                
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
                            .frame(width: 280)
                            .padding()
                            
                        } else {
                            LazyVStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.init(hex: "5E845B", alpha: 1.0)))
                                        .padding()

                                } else {
                                    ForEach(viewModel.messages) { message in
                                        MessageView(currentMessage: message)
                                            .id(message.id)
                                    }
                                    .onChange(of: viewModel.messages) { _ in
                                        if let idString = viewModel.lastCurrentUserMessageID, let uuid = UUID(uuidString: idString) {
                                                     withAnimation {
                                                         proxy.scrollTo(idString, anchor: .bottom)
                                            }
                                        }
                                    }
                                    
                                    Button(action: {
                                                if let token = authViewModel.accessToken { // 使用可選綁定來安全地獲取 token
                                                    self.showAlert = true // 只有在 token 存在時才設置 showAlert 為 true
                                                    travelPlanViewModel.copyPlan(token: token) { success, error in
                                                        if success {
                                                            print("Plan copied successfully")
                                                        } else {
                                                            print("Error copying plan: \(error ?? "Unknown error")")
                                                        }
                                                    }
                                                } else {
                                                    print("No token available")
                                                }
                                            }) {
                                                Text("複製此旅行計劃")
                                                    .bold()
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.white)
                                                    .frame(width: 150, height: 40)
                                                    .background(Color(hex: "8F785C", alpha: 1.0))
                                                    .cornerRadius(15)
                                            }
                                            .padding(10)
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("成功複製此旅行計劃"),
                                                    primaryButton: .default(Text("查看此旅行計劃"), action: {
                                                        navigateToMyPlans = true
                                                    }),
                                                    secondaryButton: .cancel(Text("確認"))
                                                )
                                            }
                                }

                            }
                        }
                    }
                    .padding()
                }
                
                // Input area
                HStack {
                   
                   
                    
                    TextField("Aa", text: $newMessage)
                        .padding(10)
                        .padding(.leading,10)
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.init(hex: "F5EFCF", alpha: 1.0)))
                        .padding(.top, 5)
                        .padding(.leading, 5)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.white)
                            .font(.system(size: 25))
                            .padding(.top, 10)
                            .padding(.leading, 5)
                            .padding(.trailing ,10)

                    }
                }
                .frame(height: 80)
                .padding(.horizontal)
                .background(colorManager.mainColor)
            }
            .navigationDestination(isPresented: $navigateToPlanView) {
                           PlanView()
                               .environmentObject(travelPlanViewModel)
                               .environmentObject(authViewModel)
                       }
            .navigationDestination(isPresented: $navigateToMyPlans) {
                            PlanMenuView()
                                .environmentObject(travelPlanViewModel)
                                .environmentObject(authViewModel)
            }
            .popupNavigationView(horizontalPadding: 40, show: $showJPicker) {
                JourneyPicker(showJPicker: $showJPicker,
                              chatContent: viewModel.messages.last?.content ?? "",
                              recommendation: viewModel.lastRecommendation,
                              navigateToPlanView: $navigateToPlanView)
                    .environmentObject(travelPlanViewModel)
                    .environmentObject(authViewModel)
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatPlan) {
                ChatPlan(showChatPlan: $showChatPlan, onSubmit: { message in
                    sendMessage(with: message)
                    isChatView = true
                })
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatTransport) {
                ChatTransport(showChatTransport: $showChatTransport, onSubmit: { message in
                    sendMessage(with: message)
                    isChatView = true
                })
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatTicket) {
                ChatTicket(showChatTicket: $showChatTicket, onSubmit: { message in
                    sendMessage(with: message)
                    isChatView = true
                })
            }
            .popupNavigationView(horizontalPadding: 40, show: $showChatAccom) {
                ChatAccom(showChatAccom: $showChatAccom, onSubmit: { message in
                    sendMessage(with: message)
                    isChatView = true
                })
            }
        }
    }

    func sendMessage() {
        sendMessage(with: newMessage)
        isChatView = true

    }
    
    func sendMessage(with content: String? = nil) {
        guard let token = authViewModel.accessToken else {
            return
        }
        
        let messageToSend = content ?? newMessage
        if !messageToSend.isEmpty {
            if isEnabled {
                viewModel.sendGreenMessage(query: messageToSend, token: token)
                newMessage = ""
            }else{
                viewModel.sendMessage(query: messageToSend, token: token)
                newMessage = ""
            }
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

struct MessageView: View {
    var currentMessage: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !currentMessage.isCurrentUser {
                Image(.travelAgent)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(20)
                    .padding(.leading, 20)
                
                MessageCell(contentMessage: currentMessage.content, isCurrentUser: currentMessage.isCurrentUser)
                    .frame(width: 270, alignment: .leading)
                Spacer()
            } else {
                Spacer()
                MessageCell(contentMessage: currentMessage.content, isCurrentUser: currentMessage.isCurrentUser)
                    .frame(width: 250, alignment: .trailing)
                    .padding(.trailing, 20)
            }
        }
        .padding(.top, 12)
    }
}

struct MessageCell: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if let attributedString = try? AttributedString(markdown: contentMessage, options: AttributedString.MarkdownParsingOptions(allowsExtendedAttributes: false, interpretedSyntax: .inlineOnly)) {
                Text(attributedString)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? Color.white : Color.black)
                    .background(isCurrentUser ? Color.init(hex: "8F785C", alpha: 1.0) : Color.init(hex: "F5EFCF", alpha: 1.0))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)

            } else {
                Text("無法解析 Markdown")
            }
            
        }
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
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
