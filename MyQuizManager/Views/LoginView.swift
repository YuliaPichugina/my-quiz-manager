//
//  LoginView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import SwiftUI

struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var authenticationFailed: Bool = false
    
    @Binding var userID: Int64
    @Binding var userLoggedIn: Bool
    
    
    var body: some View {
        VStack {
            Text("My Quiz Manager")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            Image("loginPageImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 20)
            TextField("User name", text: $username)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
          
            //if username/password is incorrect, feedback will be displayed to the user
            if authenticationFailed {
                Text("Your username and/or password is incorrect. Please try again.")
                    .offset(y: -10)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                let dbManager: UsersDBManager = UsersDBManager()
                let userID = dbManager.getUserID(username: username, password: password)
                if dbManager.userProvidedCorrectCredentials(username: username, password: password) {
                    self.userLoggedIn = true
                    self.userID = userID
                } else {
                    authenticationFailed = true
                }
            }, label: {
                MainButton(buttonText: "Log In", width: 160)
            })
        }
        .navigationBarBackButtonHidden(true)
    }
}

