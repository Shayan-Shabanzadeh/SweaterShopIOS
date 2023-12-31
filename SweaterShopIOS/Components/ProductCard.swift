//
//  ProductCard.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI


struct ProductCard: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var image: Image?
    @Binding var selectedProduct: Product?
    
    var product: Product
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                if let image = image {
                    image
                        .resizable()
                        .cornerRadius(20)
                        .frame(width: 180)
                        .scaledToFit()
                } else {
                    Color.gray
                        .frame(width: 180, height: 250)
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                        )
                }
                
                VStack(alignment: .leading) {
                    Text(product.name)
                        .bold()
                    
                    Text("\(product.price)$")
                        .font(.caption)
                }
                .padding()
                .frame(width: 180, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 180, height: 250)
            .shadow(radius: 3)
            
            Button {
                cartManager.addToCart(product: product)
            } label: {
                Image(systemName: "plus")
                    .padding(10)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(50)
                    .padding()
            }
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
        .background(
            NavigationLink(
                destination: ProductDetailView(product: product).environmentObject(cartManager),
                isActive: Binding(
                    get: { selectedProduct == product },
                    set: { newValue in
                        if !newValue {
                            selectedProduct = nil
                        }
                    }
                ),
                label: {
                    EmptyView()
                }
            )
            .hidden()
        )
    }
}





    
//struct ProductCard_Preview: PreviewProvider {
//    static var previews: some View {
//        Group {
//            if productList.isEmpty {
//                Text("No product")
//            } else {
//                ProductCard(product: productList[0], selectedProduct: .constant(nil))
//                    .environmentObject(CartManager())
//            }
//        }
//        .previewLayout(.fixed(width: 200, height: 300)) // Adjust preview size as needed
//    }
//}


