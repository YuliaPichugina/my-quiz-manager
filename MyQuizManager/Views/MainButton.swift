//
//  MainButton.swift
//  MyQuizManager
//
//  Created by Yulia Pichugina on 16/02/2021.
//

import SwiftUI

//this is the big green button that is used across the app, it was saved as a separate view that can be re-used with different text and width where needed
struct MainButton: View {
    
    var buttonText: String
    var width: CGFloat
    
    var body: some View {
        
        ZStack {
        RoundedRectangle(cornerRadius: 10.0)
            .font(.headline)
            .frame(width: width, height: 60)
            .foregroundColor(Color.green)
        Text(buttonText)
            .font(.headline)
            .foregroundColor(.white)
        }
    }
}

struct MainButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(buttonText: "This is a long button name", width: 160)
    }
}
