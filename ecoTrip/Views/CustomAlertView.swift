//
//  CustomAlertView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/11/22.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool  // Binding to control visibility from the parent view
    let title: String
    let message: String
    let primaryButtonText: String
    let secondaryButtonText: String
    var primaryButtonAction: () -> Void
    var secondaryButtonAction: () -> Void

    var body: some View {
        ZStack {
            if isPresented {
                Color.gray.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack(spacing: 20) {
                    Text(title)
                        .font(.title2).bold()
                        .foregroundStyle(.tint)
                        .padding(8)

                    VStack {
                        Text(message)
                    }
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true) // Ensures text can expand vertically as needed

                    HStack {
                        Button(action: {
                            withAnimation {
                                secondaryButtonAction()
                                isPresented = false
                            }
                        }) {
                            Text(secondaryButtonText)
                            .font(.headline)
                            .foregroundStyle(.tint)
                            .padding()
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                            .background(Material.regular)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        }

                        Button(action: {
                            withAnimation {
                                primaryButtonAction()
                                isPresented = false
                            }
                        }) {
                            Text(primaryButtonText)
                                .font(.headline).bold()
                                .foregroundStyle(Color.white)
                                .padding()
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .background(.tint)
                                .clipShape(RoundedRectangle(cornerRadius: 30.0))
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(35)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .zIndex(.greatestFiniteMagnitude)
            }
        }
    }
}

// Example usage in a preview
struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(
            isPresented: .constant(true),
            title: "行程新增成功",
            message: "您的行程已成功新增至旅行計劃中。",
            primaryButtonText: "查看行程",
            secondaryButtonText: "取消",
            primaryButtonAction: { print("查看行程") },
            secondaryButtonAction: { print("取消") }
        )
    }
}
