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
    @State private var navigateToMainView = false
    @State private var errorText = ""
    @State private var firstNameError = ""
    @State private var lastNameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Sign up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        VStack{
                            VStack{
                                TextField("First name", text: $firstName)
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(50.0)
                                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                    .onChange(of: firstName) { newValue in
                                        validateFirstName()
                                    }
                                if !firstNameError.isEmpty {
                                    Text(firstNameError)
                                        .foregroundColor(.red)
    //                                    .padding(.top, 8)
                                }
                            }
                            
                            VStack{
                                TextField("Last name", text: $lastName)
                                    .font(.title3)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(50.0)
                                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                                    .onChange(of: lastName) { newValue in
                                        validateLastName()
                                    }
                                if !lastNameError.isEmpty {
                                    Text(lastNameError)
                                        .foregroundColor(.red)
    //                                    .padding(.top, 8)
                                }
                            }
                            
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
                            
                            Spacer().frame(height: 10)

                            VStack{
                                PasswordField(password: $password, showPassword: false, text : "Password")
                                    .onChange(of: password) { newValue in
                                        validatePassword()
                                    }
                                if !passwordError.isEmpty{
                                    Text(passwordError).foregroundColor(.red)
                                }
                            }
                            Spacer().frame(height: 9)
                            VStack{
                                PasswordField(password: $conformPassword , showPassword: false , text: "Confirm password")
                                    .onChange(of: conformPassword) { newValue in
                                        validatePasswordConfirm()
                                    }
                                if !confirmPasswordError.isEmpty{
                                    Text(confirmPasswordError).foregroundColor(.red)
                                }
                            }
                            Spacer().frame(height: 10)
                        }

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
                                    PrimaryButton(title: "Sign up").onTapGesture {
                                        performSignup()
                                    }
                                } else {
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
    
    func performSignup() {
        // Validate input
        isLoading = true
        guard !email.isEmpty, !password.isEmpty , !firstName.isEmpty , !lastName.isEmpty , !conformPassword.isEmpty else {
            // Handle invalid input
            isLoading = false
            return
        }
        
        // Create a user object
        var user = User(firstName: firstName, lastName: lastName, email: email, password: password)
        sendSignup(user: user) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    navigateToMainView = true
                case .failure(let error):
                    // Handle login failure and show error message
                    errorText = "Username is already taken."
                    print("Login error:", error)
                }
            }
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
    
    private func validateFirstName() {
        if firstName.isEmpty {
            firstNameError = "First name is required."
        } else if firstName.count <= 2 {
            firstNameError = "First name should be longer than 2 characters."
        } else {
            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+$")
            let range = NSRange(location: 0, length: firstName.utf16.count)
            let matches = regex.matches(in: firstName, range: range)
            if matches.isEmpty {
                firstNameError = "First name should only contain alphabetic characters."
            } else {
                firstNameError = ""
            }
        }
    }

    
    private func validateLastName() {
        if lastName.isEmpty {
            lastNameError = "Last name is required."
        } else if lastName.count <= 2 {
            lastNameError = "Last name should be longer than 2 characters."
        } else {
            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+$")
            let range = NSRange(location: 0, length: lastName.utf16.count)
            let matches = regex.matches(in: lastName, range: range)
            if matches.isEmpty {
                lastNameError = "Last name should only contain alphabetic characters."
            } else {
                lastNameError = ""
            }
        }
    }

    
    
    private func validatePassword(){
        if password.contains(" "){
            passwordError = "Password can not contain space."
        }else if password.count < 2 {
            passwordError = "Password should be more than 2 char"
        }else{
            passwordError = ""
        }

    }
    
    private func validatePasswordConfirm() {
        if conformPassword.isEmpty {
            confirmPasswordError = "Confirm password is required."
        } else if conformPassword != password {
            confirmPasswordError = "Passwords do not match."
        }else if password.contains(" "){
            confirmPasswordError = "Password can not contain space."
        }else {
            confirmPasswordError = ""
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
