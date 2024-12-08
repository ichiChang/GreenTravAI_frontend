//
//  SignupView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/16.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @State private var mail: String = ""
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {  // Added ZStack to overlay alert
                VStack {
                    // Previous code remains the same until the form section
                    Image(.loginlogo2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 73.54,height: 107.46)
                        .padding()
                    
                    ZStack{
                        Text("註冊")
                            .bold()
                            .font(.system(size: 25))
                            .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.init(hex: "F5EFCF", alpha: 0.5))
                    .padding(.bottom)
                    
                    VStack(alignment: .leading){
                        Text("暱稱")
                            .padding(.leading)
                            .padding(.top)
                        
                        TextField("", text: $username)
                            .frame(width:250, height: 30)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2))
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("電子郵件")
                            .padding(.leading)
                            .padding(.top)
                        
                        TextField("", text: $mail)
                            .frame(width:250, height: 30)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2))
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("密碼")
                            .padding(.leading)
                            .padding(.top)
                        
                        SecureField("", text: $password)
                            .frame(width:250, height: 30)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2))
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("確認密碼")
                            .padding(.leading)
                            .padding(.top)
                        
                        SecureField("", text: $password2)
                            .frame(width:250, height: 30)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.init(hex: "5E845B", alpha: 1.0), lineWidth: 2))
                            .padding(.leading)
                            .padding(.bottom)
                    }
                    
                    if let error = authViewModel.registrationError {
                        Text(error.description)
                            .foregroundColor(.red)
                            .padding()
                            .bold()
                    }
                    
                    Button(action: {
                        authViewModel.register(email: mail,
                                            password: password,
                                            confirmPassword: password2,
                                            username: username) { success in
                            if success {
                                showSuccessAlert = true
                            }
                        }
                    }) {
                        Text("註冊").bold()
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                            .background(Color.init(hex: "5E845B", alpha: 1.0))
                            .frame(width: 100, height: 40)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.init(hex: "5E845B", alpha: 1.0))
                    .buttonBorderShape(.capsule)
                    .padding(10)
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                            Text("返回")
                                .foregroundColor(Color.init(hex: "5E845B", alpha: 1.0))
                        }
                    }
                }
                
                // Custom Alert
                CustomAlertView(
                    isPresented: $showSuccessAlert,
                    title: "註冊成功",
                    message: "您已成功完成註冊，請重新登入。",
                    primaryButtonText: "確定",
                    primaryButtonAction: {
                        dismiss()  // Return to login view
                    }
                )
            }
        }
    }
}
