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
    
    @StateObject var cartManager = CartManager()
    @State private var selectedProduct: Product? = nil
    @State private var showMenu = false
    @State private var showProfile = false
    @State private var showSettings = false
    @State private var showRoot = false
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
                            showProfile = true
                        }) {
                            Label("Profile", systemImage: "person")
                        }
                        
                        Button(action: {
                            showSettings = true
                        }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        
                        Button(action: {
                            // Handle logout action
                            showRoot = true
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
        NavigationLink(
            destination: ContentView().navigationBarHidden(true),
            isActive: $showRoot){
                EmptyView()
            }.hidden()
        
        NavigationLink(
            destination: SettingsView(),
            isActive: $showSettings){
                EmptyView()
            }.hidden()
        
        NavigationLink(
            destination: ProfileView(),
            isActive: $showProfile){
                EmptyView()
            }.hidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}





struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
