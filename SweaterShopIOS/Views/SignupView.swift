//
//  SignupView.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct SignupResult: Identifiable {
    var id = UUID()
    var result: Result<String, Error>
    
    var isSuccess: Bool {
        if case .success = result {
            return true
        } else {
            return false
        }
    }
    
    var error: String? {
        if case .failure(let error) = result {
            return error.localizedDescription
        } else {
            return nil
        }
    }
}



struct SignupView: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var conformPassword: String = ""
    @State private var showPassword = false
    @State private var isLoading = false
    @State private var navigateToMainView = false
    @State private var signupResult: SignupResult? = nil
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
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
                        if !isLoading {
                            PrimaryButton(title: "Sign up").onTapGesture {
                                performSignup()
                            }
                        } else {
                            LoadingComponent()
                        }
                        
                        NavigationLink(destination: MainView().navigationBarHidden(true), isActive: $navigateToMainView) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    .alert(isPresented: Binding(
                        get: { signupResult?.error != nil },
                        set: { _ in signupResult = nil }
                    )) {
                        Alert(
                            title: Text("Error"),
                            message: Text(signupResult?.error ?? ""),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    

                    
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

                
            }
            .padding()
        }
    }
    
    func performSignup() {
         // Validate input
         guard !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !password.isEmpty, password == conformPassword else {
             signupResult = SignupResult(result: .failure(AuthenticationError.invalidData))
             return
         }

         // Create a user object
         let user = User(firstName: firstName, lastName: lastName, email: email, password: password)

         // Call the sendSignup function
         sendSignup(user: user) { result in
             DispatchQueue.main.async {
                 // Update the signup result and loading state
                 signupResult = SignupResult(result: result)
                 isLoading = false

                 switch result {
                 case .success:
                     isAlertPresented = false
                 case .failure(let error):
                     isAlertPresented = true
                     alertMessage = error.localizedDescription
                 }
             }
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
