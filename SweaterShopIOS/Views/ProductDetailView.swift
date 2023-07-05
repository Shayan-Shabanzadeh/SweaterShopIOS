//
//  ProductDetailView.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/14/1402 AP.
//

import SwiftUI

struct ProductDetailView: View {
    @State var product: Product
    @State private var image: Image?
    @State private var selectedSize: String = "Small"
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Product Image
            if let image = image {
                image
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 180)
                    .scaledToFit()
                    .frame(width: 180, height: 250)
                    .shadow(radius: 3)
            } else {
                Color.gray
                    .frame(width: 180, height: 250)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    )
            }
            
            // Product Description
            Text(product.description)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            // Size Options
            VStack(spacing: 10) {
                Text("Size:")
                    .font(.headline)
                HStack {
                    Button(action: {
                        selectedSize = "Small"
                    }) {
                        Text("Small")
                            .font(.subheadline)
                            .padding(10)
                            .background(selectedSize == "Small" ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        selectedSize = "Medium"
                    }) {
                        Text("Medium")
                            .font(.subheadline)
                            .padding(10)
                            .background(selectedSize == "Medium" ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        selectedSize = "Large"
                    }) {
                        Text("Large")
                            .font(.subheadline)
                            .padding(10)
                            .background(selectedSize == "Large" ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Text("Selected Size: \(selectedSize)")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            // Price
            Text("Price: $\(product.price)")
                .font(.headline)
            
            // Add to Cart Button
            Button(action: {
                cartManager.addToCart(product: product)
            }) {
                Text("Add to Cart")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .onAppear {
            fetchProductImage(imageName: product.name) { fetchedImage in
                if let fetchedImage = fetchedImage {
                    DispatchQueue.main.async {
                        self.image = fetchedImage
                    }
                } else {
                    // Handle the case when image retrieval fails
                    print("Failed to fetch product image")
                }
            }
        }
        .padding()
        .navigationTitle(Text(product.name))
        .toolbar {
            NavigationLink(destination: CartView().environmentObject(cartManager)) {
                CartButton(numberOfProducts: cartManager.products.count)
            }
        }
    }
}




//struct ProductDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetailView(product: Product(id: 0, image: "localhost:9000/product/image?productName=Cream%20sweater", price: 56, description: "Test", name: "Cream sweater", type: "sweater"))
//    }
//}
