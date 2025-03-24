//
//  AuthView.swift
//  slaog
//
//  Created by 董梓涵 on 2025/3/25.
//

import SwiftUI

struct AuthView: View {
    @State private var isLogin = true
    @State private var userId = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @Binding var isAuthenticated: Bool
    
    // 模拟用户数据库
    @State private var users: [User] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Slaog")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            // 切换登录/注册
            Picker("", selection: $isLogin) {
                Text("登录").tag(true)
                Text("注册").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                TextField("用户ID", text: $userId)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                
                SecureField("密码", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                if !isLogin {
                    SecureField("确认密码", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    TextField("昵称", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button {
                if isLogin {
                    login()
                } else {
                    register()
                }
            } label: {
                Text(isLogin ? "登录" : "注册")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text("错误"), message: Text(errorMessage), dismissButton: .default(Text("确定")))
        }
    }
    
    // 登录功能
    func login() {
        // 在实际应用中，这里应该从数据库或服务器验证用户
        if let user = users.first(where: { $0.id == userId && $0.password == password }) {
            // 登录成功
            UserDefaults.standard.set(user.id, forKey: "currentUserId")
            UserDefaults.standard.set(user.name, forKey: "currentUserName")
            isAuthenticated = true
        } else {
            errorMessage = "用户ID或密码不正确"
            showError = true
        }
    }
    
    // 注册功能
    func register() {
        // 验证输入
        if userId.isEmpty || password.isEmpty || name.isEmpty {
            errorMessage = "所有字段都必须填写"
            showError = true
            return
        }
        
        if password != confirmPassword {
            errorMessage = "两次输入的密码不一致"
            showError = true
            return
        }
        
        // 检查ID是否已存在
        if users.contains(where: { $0.id == userId }) {
            errorMessage = "该用户ID已被使用"
            showError = true
            return
        }
        
        // 创建新用户
        let newUser = User(id: userId, password: password, name: name)
        users.append(newUser)
        
        // 在实际应用中，这里应该将用户保存到数据库或服务器
        
        // 自动登录
        UserDefaults.standard.set(newUser.id, forKey: "currentUserId")
        UserDefaults.standard.set(newUser.name, forKey: "currentUserName")
        isAuthenticated = true
    }
}
