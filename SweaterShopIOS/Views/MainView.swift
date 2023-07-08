//
//  MainScreen.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    init() {
        self.current_user_binding = Binding<User?>(get: { current_user }, set: { current_user = $0! })
        fetchProductData()
    }
    
    @StateObject var cartManager = CartManager()
    @State private var selectedProduct: Product? = nil
    
    @State private var showMenu = false
    @State private var showProfile = false
    @State private var showSettings = false
    @State private var showRoot = false
    var current_user_binding: Binding<User?>
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    @State private var sortOption: SortOption = .none
    @State private var searchText: String = ""
    @State private var showFilterByType: Bool = false
    @State private var selectedType: String? = nil
    
    var sortedAndFilteredProducts: [Product] {
        let filteredProducts = searchText.isEmpty ? productList : productList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        switch sortOption {
        case .none:
            return filteredProducts
        case .name:
            return filteredProducts.sorted { $0.name < $1.name }
        case .price:
            return filteredProducts.sorted { $0.price < $1.price }
        }
    }
    
    var productTypes: [String] {
        let types = productList.map { $0.type }
        return Array(Set(types))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                Picker("Sort by", selection: $sortOption) {
                    Text("None").tag(SortOption.none)
                    Text("Name").tag(SortOption.name)
                    Text("Price").tag(SortOption.price)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom)
                
                Button(action: {
                    showFilterByType.toggle()
                    selectedType = nil // Deselect the type when hiding the filter
                }) {
                    HStack {
                        Text("Filter by Type")
                            .font(.headline)
                        
                        Image(systemName: showFilterByType ? "chevron.up" : "chevron.down")
                            .foregroundColor(.primary)
                            .rotationEffect(.degrees(showFilterByType ? 180 : 0))
                            .animation(.easeInOut)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                if showFilterByType {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Button(action: {
                                selectedType = nil // Deselect the type when clicked again
                            }) {
                                Text("All")
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .foregroundColor(selectedType == nil ? .white : .primary)
                                    .background(selectedType == nil ? Color.blue : Color.gray.opacity(0.3))
                                    .cornerRadius(8)
                            }
                            
                            ForEach(productTypes, id: \.self) { type in
                                Button(action: {
                                    selectedType = type
                                }) {
                                    Text(type)
                                        .font(.subheadline)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(selectedType == type ? .white : .primary)
                                        .background(selectedType == type ? Color.blue : Color.gray.opacity(0.3))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50)
                    .padding(.bottom)
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedAndFilteredProducts, id: \.id) { product in
                            if selectedType == nil || product.type == selectedType {
                                ProductCard(selectedProduct: $selectedProduct, product: product)
                                    .environmentObject(cartManager)
                                    .onTapGesture {
                                        selectedProduct = product
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(Text("Sweater shop"))
            .navigationBarItems(leading: leadingNavigationMenu)
            .toolbar {
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
            destination: ProfileView(user: current_user_binding),
            isActive: $showProfile){
                EmptyView()
            }.hidden()
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var leadingNavigationMenu: some View {
        Menu {
            Button(action: {
                showProfile = true
            }) {
                Label("Profile", systemImage: "person")
            }
            
            Button(action: {
                isDarkMode.toggle() // Toggle the dark mode state
            }) {
                Label("Theme" , systemImage: isDarkMode ? "sun.max.fill" : "moon.fill") // Use different images based on the theme state
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            
            Button(action: {
                // Handle logout action
                current_user = nil
//                current_user_binding = nil
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
}

enum SortOption {
    case none
    case name
    case price
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        return MainView()
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.leading, 8)
                .padding(.vertical, 10)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
                .transition(.scale)
                .animation(.default)
            }
        }
    }
}
