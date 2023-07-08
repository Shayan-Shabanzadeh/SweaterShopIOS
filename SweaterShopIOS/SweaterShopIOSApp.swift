//
//  SweaterShopIOSApp.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

@main
struct SweaterShopIOSApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)

        }
    }
}
