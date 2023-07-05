//
//  SignupView.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var conformPassword: String = ""
    @State private var showPassword = false
    @State private var isLoading = false
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack {
                    Text("Sign up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    VStack{
                        TextField("First name", text: $firstName)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        
                        TextField("Last name", text: $lastName)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        
                        TextField("Email address", text: $email)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        
                        Spacer().frame(height: 10)

                        
                        PasswordField(password: $password, showPassword: false, text : "Password")
                        Spacer().frame(height: 9)

                        PasswordField(password: $conformPassword , showPassword: false , text: "Confirm password")
                        Spacer().frame(height: 10)
                    }
                    
                    

                    
//                    PrimaryButton(title: "Sign up", destination: MainView())

                    
                    NavigationLink(
                        destination: MainView() .navigationBarHidden(true),
                        label: {
                            if !isLoading{
                                PrimaryButton(title: "Login")
                            }else{
                                LoadingComponent()
                            }
                        })
                    
                    Spacer().frame(height: 16)

                    
                    Text("or login with Google & Apple")
                        .foregroundColor(Color.black.opacity(0.4))
                    VStack{
                        Divider()
                        Spacer().frame(height: 16)
                    }
                    
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple"))
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google").foregroundColor(Color("PrimaryColor")))
                        .padding(.vertical)
                    
                    
                    Spacer()
                    
                }
                
                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                Text("Read our Terms & Conditions.")
                    .foregroundColor(Color("PrimaryColor"))
                Spacer()
                
            }
            .padding()
        }
    }
}

struct SocalSignupButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
    }
}




struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
