//
//  PasswordField.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct PasswordField:View{
    @State var password = ""
    @State var showPassword = false
    let text : String
    var body: some View {
        ZStack(alignment: .trailing){
        if showPassword {
            TextField(text, text: $password)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
        } else {
            SecureField(text, text: $password)
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0.0, y: 16)
        }
        
        Button(action: {
            showPassword.toggle()
        }) {
            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                .foregroundColor(.gray)
                .padding(.trailing)
        }
    }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(text: "password")
    }
}


