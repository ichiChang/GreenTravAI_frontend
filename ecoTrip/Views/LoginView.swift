//
//  LoginView.swift
//  ecoTrip
//
//  Created by 陳萭鍒 on 2024/6/16.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    @State private var navigateToMenu = false
    @State private var navigateToSignup = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(.loginlogo2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 73.54,height: 107.46)
                    .padding()
                
                ZStack{
                    
                    Text("登入")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundStyle(Color.init(hex: "5E845B", alpha: 1.0))
                        .padding()
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.init(hex: "F5EFCF", alpha: 0.5))
                .padding(.bottom)
                
                
                VStack(alignment: .leading){
                    Text("電子郵件")
                        .padding(.leading)
                        .padding(.top)
                    
                    TextField("", text: $email)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
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
                }
                
                if let error = authViewModel.loginError {
                    Text(error.description)
                        .foregroundColor(.red)
                        .padding()
                        .bold()
                }
                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    Text("登入").bold()
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
                
                Button(action: {
                    self.navigateToSignup = true
                }, label: {
                    Text("還不是會員？ 立即註冊")
                        .foregroundStyle(.black)
                        .underline()
                        .padding()
                })
            }
            .navigationDestination(isPresented: $navigateToMenu) {
                MenuView()
            }
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
