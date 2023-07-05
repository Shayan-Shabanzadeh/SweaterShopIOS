//
//  User.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import Foundation

struct User: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}

enum AuthenticationError: Error {
    case invalidResponse
    case requestFailed
    case invalidData
    case invalidCredentials
    case userExists
}

func sendLogin(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
    let loginURL = URL(string: "http://localhost:9000/login")!

    var request = URLRequest(url: loginURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let loginData: [String: Any] = [
        "email": email,
        "password": password
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: loginData)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthenticationError.invalidResponse))
                return
            }

            if httpResponse.statusCode == 200 {
                completion(.success("Login successful."))
            } else if httpResponse.statusCode == 401 {
                completion(.failure(AuthenticationError.invalidCredentials))
            } else {
                completion(.failure(AuthenticationError.requestFailed))
            }
        }

        task.resume()
    } catch {
        completion(.failure(AuthenticationError.invalidData))
    }
}

func sendSignup(user: User, completion: @escaping (Result<String, Error>) -> Void) {
    let signupURL = URL(string: "http://localhost:9000/signup")!

    var request = URLRequest(url: signupURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let signupData: [String: Any] = [
        "email": user.email,
        "password": user.password,
        "first_name": user.firstName,
        "last_name": user.lastName
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: signupData)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(AuthenticationError.invalidResponse))
                return
            }

            if httpResponse.statusCode == 201 {
                completion(.success("User created successfully."))
            } else if httpResponse.statusCode == 400 {
                completion(.failure(AuthenticationError.userExists))
            } else {
                completion(.failure(AuthenticationError.requestFailed))
            }
        }

        task.resume()
    } catch {
        completion(.failure(AuthenticationError.invalidData))
    }
}

//// Example usage:
//let user = User(firstName: "John", lastName: "Doe", email: "john@example.com", password: "password")
//
//sendSignup(user: user) { result in
//    switch result {
//    case .success(let message):
//        print(message)
//    case .failure(let error):
//        print("Signup failed: \(error.localizedDescription)")
//    }
//}
//
//sendLogin(email: "john@example.com", password: "password") { result in
//    switch result {
//    case .success(let message):
//        print(message)
//    case .failure(let error):
//        print("Login failed: \(error.localizedDescription)")
//    }
//}

