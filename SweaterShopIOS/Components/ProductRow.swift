//
//  ProductRows.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//
import SwiftUI

struct ProductRow: View {
    @State private var image: Image?
    @EnvironmentObject var cartManager: CartManager
    var product: Product
    
    var body: some View {
        HStack(spacing: 20) {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .cornerRadius(10)
            } else {
                Color.gray
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .cornerRadius(10)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    )
            }

            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name)
                    .bold()

                Text("$\(product.price)")
            }
            
            Spacer()

            Image(systemName: "trash")
                .foregroundColor(Color(hue: 1.0, saturation: 0.89, brightness: 0.835))
                .onTapGesture {
                    cartManager.removeFromCart(product: product)
                }
        }.onAppear {
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
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(product: productList[2])
            .environmentObject(CartManager())
    }
}
