import SwiftUI

struct ProductDetailView: View {
    @State var product: Product
    @State private var image: Image?
    @State private var selectedSize: String = "Small"
    @EnvironmentObject var cartManager: CartManager
    @State private var isRatingSheetPresented = false
    @State private var userRating: Double = 0.0
    
    
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
            
            // Rating
            let averageRating = product.numberOfRatings > 0 ? product.ratings.values.reduce(0, +) / Double(product.numberOfRatings) : 0
            HStack(spacing: 4) {
                Text("Rating:")
                    .font(.headline)
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(averageRating) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.vertical, 4)
            
            // Rate Button
            Button(action: {
                isRatingSheetPresented = true
            }) {
                Text("Rate Product")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
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
            }        }
        .padding()
        .navigationTitle(Text(product.name))
        .toolbar {
            NavigationLink(destination: CartView().environmentObject(cartManager)) {
                CartButton(numberOfProducts: cartManager.products.count)
            }
        }
        .sheet(isPresented: $isRatingSheetPresented) {
            RatingSelectionView(
                userRating: $userRating,
                submitRating: {
                    addRating(productID: product.id,userEmail: current_user!.email , rating: userRating) { success in
                        if success {
                            print("Rating submitted successfully")
                        } else {
                            print("Failed to submit rating")
                        }
                    }
                    isRatingSheetPresented = false
                },
                cancelRating: {
                    isRatingSheetPresented = false
                }
            )
        }
    }
}

struct RatingSelectionView: View {
    @Binding var userRating: Double
    var submitRating: () -> Void
    var cancelRating: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: cancelRating) {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
            .padding()
            
            Spacer()
            
            Text("Select a rating:")
                .font(.headline)
            
            HStack(spacing: 10) {
                ForEach(1...5, id: \.self) { rating in
                    Button(action: {
                        userRating = Double(rating)
                    }) {
                        Image(systemName: rating <= Int(userRating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 20))
                    }
                }
            }
            
            Spacer()
            
            Button(action: submitRating) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .padding()
    }
}




