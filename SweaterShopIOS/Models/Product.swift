import SwiftUI
import Foundation

struct Product: Decodable, Hashable {
    var id: Int
    var name: String
    var image: String
    var price: Int
    var description: String
    var type: String
    var ratings: [String: Double]
    var numberOfRatings: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case price
        case description
        case type
        case ratings
        case numberOfRatings = "number_of_ratings"
    }
}

struct Comment: Decodable {
    var id: Int
    var username: String
    var text: String
}

var productList: [Product] = []

func fetchProductData() {
    let url = URL(string: "http://localhost:9000/products")!

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("Error: No data received")
            return
        }

        do {
            let decoder = JSONDecoder()
            productList = try decoder.decode([Product].self, from: data)
            print("Product data retrieved successfully")
        } catch {
            print("Error decoding product data: \(error)")
        }
    }.resume()
}

func fetchProductImage(imageName: String, completion: @escaping (Image?) -> Void) {
    guard let encodedImageName = imageName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion(nil)
        return
    }
    
    let imageUrlString = "http://localhost:9000/product/image?productName=\(encodedImageName)"
    
    guard let imageUrl = URL(string: imageUrlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
        guard let data = data, let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        
        completion(Image(uiImage: image))
    }.resume()
}


func fetchProductComments(productID: Int, completion: @escaping ([Comment]?) -> Void) {
    let url = URL(string: "http://localhost:9000/product/\(productID)/comment")!
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let comments = try decoder.decode([Comment].self, from: data)
            completion(comments)
        } catch {
            print("Error decoding comments data: \(error)")
            completion(nil)
        }
    }.resume()
}


func addRating(productID: Int, userEmail: String, rating: Double, completion: @escaping (Bool) -> Void) {
    let urlString = "http://localhost:9000/product/\(productID)/rating"
    guard let url = URL(string: urlString) else {
        completion(false)
        return
    }
    
    let parameters: [String: Any] = [
        "user_email": userEmail,
        "rating": rating
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data else {
                completion(false)
                return
            }
            
            completion(true)
        }.resume()
    } catch {
        completion(false)
    }
}




