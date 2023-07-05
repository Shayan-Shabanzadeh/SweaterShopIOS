//
//  MainScreen.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct MainView: View {
    init() {
        fetchProductData()
    }
    @Environment(\.presentationMode) var presentationMode

    @StateObject var cartManager = CartManager()
    @State private var selectedProduct: Product? = nil
    
    @State private var showMenu = false
    
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(productList, id: \.id) { product in
                        ProductCard(selectedProduct: $selectedProduct, product: product)
                            .environmentObject(cartManager)
                            .onTapGesture {
                                selectedProduct = product
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(Text("Sweater shop"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            // Handle profile action
                        }) {
                            Label("Profile", systemImage: "person")
                        }
                        
                        Button(action: {
                            // Handle settings action
                        }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()  // Dismiss the current view (logout)
                        }) {
                            Label("Logout", systemImage: "person.crop.circle.badge.xmark")
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView().environmentObject(cartManager)) {
                        CartButton(numberOfProducts: cartManager.products.count)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
