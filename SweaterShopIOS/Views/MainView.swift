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
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns,spacing: 20) {
                    ForEach(productList , id: \.id){ product in
                        ProductCard(product: product)
                            .environmentObject(cartManager)
                    }
                }.padding()
            }.navigationTitle(Text("Sweater shop")).toolbar{
                NavigationLink{
                    CartView()
                        .environmentObject(cartManager)
                } label: {
                    CartButton(numberOfProducts: cartManager.products.count)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
