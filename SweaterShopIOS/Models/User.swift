//
//  User.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import Foundation

struct User: Identifiable, Decodable , Encodable {
    var id = UUID()
    var first_name: String
    var last_name: String
    var email: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case password = "password"
    }
}

var current_user : User? = nil


enum AuthenticationError: Error {
    case invalidResponse
    case requestFailed
    case invalidData
    case invalidCredentials
    case userExists
}

func updateUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
    let endpoint = "http://localhost:9000/user/\(user.email)"
    
    guard let url = URL(string: endpoint) else {
        completion(.failure(AuthenticationError.invalidData))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    do {
        let userData = try encoder.encode(user)
        request.httpBody = userData
    } catch {
        completion(.failure(error))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(AuthenticationError.invalidResponse))
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(AuthenticationError.requestFailed))
            return
        }
        
        guard let data = data else {
            completion(.failure(AuthenticationError.invalidData))
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let updatedUser = try decoder.decode(User.self, from: data)
            completion(.success(updatedUser))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}



func sendLogin(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
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
                print("Response data: \(String(data: data!, encoding: .utf8) ?? "")") // Print the response data
                do {
                    if let userData = data {
                        let user = try JSONDecoder().decode(User.self, from: userData)
                        current_user = user  // Update current_user with the user object
                        completion(.success(user))
                    } else {
                        completion(.failure(AuthenticationError.invalidData))
                    }
                } catch {
                    completion(.failure(AuthenticationError.invalidData))
                }
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
        "first_name": user.first_name,
        "last_name": user.last_name
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


