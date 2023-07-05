//
//  ProfileView.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/14/1402 AP.
//

import SwiftUI

struct ProfileView: View {
    @Binding var user: User?
    
    var body: some View {
        if let user = user {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    
                    Text("\(user.first_name) \(user.last_name)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(user.email)
                        .font(.subheadline)
                    
                    EditProfileView(user: $user)
                    
                    
                    
                    Spacer()
                }
                .padding()
            }
        } else {
            Text("User not available")
        }
    }
}

struct EditProfileView: View {
    @Binding var user: User?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = "*****"
    @State private var conformPassword: String = "*****"
    @State private var errorText = ""
    @State private var firstNameError = ""
    @State private var lastNameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var confirmPasswordError = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
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

            VStack{
                PasswordField(password: $password, showPassword: false, text : "Password")
                    .onChange(of: password) { newValue in
                        validatePassword()
                    }
                if !passwordError.isEmpty{
                    Text(passwordError).foregroundColor(.red)
                }
            }
            VStack{
                PasswordField(password: $conformPassword , showPassword: false , text: "Confirm password")
                    .onChange(of: conformPassword) { newValue in
                        validatePasswordConfirm()
                    }
                if !confirmPasswordError.isEmpty{
                    Text(confirmPasswordError).foregroundColor(.red)
                }
            }
            
            Button(action: {
                saveChanges()
            }) {
                Text("Save changes")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryColor"))
                    .cornerRadius(50)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            setupFields()
        }
    }
    
    private func setupFields() {
        if let user = user {
            firstName = user.first_name
            lastName = user.last_name
            email = user.email
        }
    }
    
    private func saveChanges() {
        // Perform validation and save changes to user object
        
        // Example: Update the user object with the new values
        user?.first_name = firstName
        user?.last_name = lastName
        user?.email = email
        
        // Perform API request or database update to save changes
        
        // Example: Print updated user details
        if let updatedUser = user {
            print("Updated User: \(updatedUser)")
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



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(first_name: "John", last_name: "Doe", email: "john.doe@example.com", password: "******")
        return ProfileView(user: .constant(user))
    }
}

