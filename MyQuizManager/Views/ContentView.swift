//
//  ContentView.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 15/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var userLoggedIn: Bool = false
    @State var userID: Int64 = 0
    
    var body: some View {
        if userLoggedIn {
            DashboardView(userLoggedIn: $userLoggedIn, userID: $userID)
        } else  {
            LoginView(userID: $userID, userLoggedIn: $userLoggedIn)
        }
    }
}

