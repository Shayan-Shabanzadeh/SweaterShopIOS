import SwiftUI
import Foundation

struct Product:Decodable {
    var id : Int
    var image: String
    var price: Int
    var description: String
    var name : String
    var type: String
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

