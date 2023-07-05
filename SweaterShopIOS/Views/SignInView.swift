//
//  LoginView.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var navigateToMainView = false
    @State private var errorText: String = ""
    @State private var emailError: String = ""
    @State private var passwrodError: String = ""
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        
                        VStack {
                            TextField("Email address", text: $email)
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onChange(of: email) { newValue in
                                    errorText = ""
                                    validateEmail()
                                }
                            
                            if !emailError.isEmpty {
                                Text(emailError)
                                    .foregroundColor(.red)
//                                    .padding(.top, 8)
                            }
                        }
                        
                        
                        VStack {
                            ZStack(alignment: .trailing) {
                                if showPassword {
                                    TextField("Password", text: $password)
                                        .font(.title3)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(50.0)
                                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                        .padding(.vertical)
                                } else {
                                    SecureField("Password", text: $password)
                                        .font(.title3)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(50.0)
                                        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0.0, y: 4)
                                        .padding(.vertical)
                                }
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                            .onChange(of: password) { newValue in
                                errorText = ""
                                validatePassword()
                            }
                            if !passwrodError.isEmpty {
                                Text(passwrodError)
                                    .foregroundColor(.red)
//                                    .padding(.top, 8)
                            }
                        }
                        
                        
                        //                    PrimaryButton(title: "Login" , destination: MainView())
                        if !errorText.isEmpty {
                            Text(errorText)
                                .foregroundColor(.red)
//                                .padding(.top, 8)
                        }
                        
                        NavigationLink(
                            destination: MainView().navigationBarHidden(true),
                            isActive: $navigateToMainView,
                            label: {
                                if !isLoading {
                                    PrimaryButton(title: "Login").onTapGesture {
                                        performLogin()
                                    }
                                } else {
                                    LoadingComponent()
                                }
                            })
                        
                        Spacer()
                        
                        
                        Text("or login with Google & Apple")
                            .foregroundColor(Color.black.opacity(0.4))
                        VStack{
                            Divider()
                            Spacer().frame(height: 16)
                        }
                        
                        VStack{
                            SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple"))
                            
                            SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google").foregroundColor(Color("PrimaryColor")))
                                .padding(.vertical)
                        }
                        
                        
                        
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
    
    func performLogin() {
        // Validate input
        isLoading = true
        guard !email.isEmpty, !password.isEmpty else {
            // Handle invalid input
            isLoading = false
            return
        }
        
        // Create a user object
        
        // Call the sendLogin function
        sendLogin(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    navigateToMainView = true
                case .failure(let error):
                    // Handle login failure and show error message
                    errorText = "Username or Password is inccorect."
                    print("Login error:", error)
                }
            }
        }
    }
    
    private func validatePassword(){
        if password.contains(" "){
            passwrodError = "Password can not contain space."
        }else if password.count < 2 {
            passwrodError = "Password should be more than 2 char"
        }else{
            passwrodError = ""
        }

    }
    
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required."
        } else if !isValidEmail(email) {
            emailError = "Invalid email format."
        } else {
            emailError = ""
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Add your email validation logic here
        // Return true if email is valid, false otherwise
        
        // A simple email validation example
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


struct SocalLoginButton: View {
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


struct SignIn_Preview: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


