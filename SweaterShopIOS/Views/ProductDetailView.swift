import SwiftUI

struct ProductDetailView: View {
    @State var product: Product
    @State private var image: Image?
    @State private var selectedSize: String = "Small"
    @EnvironmentObject var cartManager: CartManager
    @State private var isRatingSheetPresented = false
    @State private var userRating: Double = 0
    @State private var isCommentsExpanded = false
    @State private var comments: [Comment] = []
    @State private var commentText:String  = ""
    
    
    
    var body: some View {
        ScrollView{
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
                        .foregroundColor(.primary)
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
                
                Button {
                    cartManager.addToCart(product: product)
                } label: {
                    Text("Add to the cart")
                        .font(.headline)
                        .frame(minWidth: 100, maxWidth: 400)
                        .frame(height: 45)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)


                }
                
                // Rate Button
                Button(action: {
                    isRatingSheetPresented = true
                }) {
                    Text("Rate Product")
                        .frame(minWidth: 100, maxWidth: 400)
                        .frame(height: 45)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Comments Section
                DisclosureGroup(
                    isExpanded: $isCommentsExpanded,
                    content: {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(comments, id: \.id) { comment in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(comment.username)
                                        .font(.headline)
                                    Text(comment.text)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                .padding(10)
                                .cornerRadius(10)
                                
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    },
                    label: {
                        Text("Comments")
                            .font(.headline)
                    }
                )

                
                VStack {
                    Text("Write a Comment")
                        .font(.headline)
                        .padding(.top)
                    
                    TextField("Enter your comment", text: $commentText)
                        .font(.title3)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(Color.primary.colorInvert())
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !commentText.isEmpty {
                            addComment(productID: product.id, username: current_user!.email, text: commentText) { success in
                                if success {
                                    // Comment added successfully
                                    fetchProductComments(productID: product.id) { comments in
                                        if let comments = comments {
                                            self.comments = comments
                                            self.commentText = "" // Clear the comment text
                                        }
                                    }
                                } else {
                                    // Failed to add comment
                                    print("Failed to add comment")
                                }
                            }
                        }
                    }) {
                        Text("Add Comment")
                            .frame(minWidth: 100, maxWidth: 400)
                            .frame(height: 45)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .padding()
                
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
                
                fetchProductComments(productID: product.id) { comments in
                    if let comments = comments{
                        DispatchQueue.main.async {
                            self.comments = comments
                        }
                    }else{
                        print("Failed to fetch comments")
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
            .sheet(isPresented: $isRatingSheetPresented) {
                RatingSelectionView(
                    userRating: $userRating,
                    submitRating: {
                        addRating(productID: product.id, userEmail: "current_user@example.com", rating: userRating) { success in
                            if success {
                                print("Rating submitted successfully")
                            } else {
                                print("Failed to submit rating")
                            }
                        }
                    },
                    cancelRating: {
                        isRatingSheetPresented = false
                    }
                )
            }
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




