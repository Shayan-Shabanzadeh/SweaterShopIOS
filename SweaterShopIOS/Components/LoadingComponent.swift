//
//  LoadingComponent.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import SwiftUI

struct LoadingComponent: View {
    var body: some View {
        ProgressView() // Show loading indicator
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("PrimaryColor"))
            .cornerRadius(50)
    }
}

struct LoadingComponent_Previews: PreviewProvider {
    static var previews: some View {
        LoadingComponent()
    }
}
