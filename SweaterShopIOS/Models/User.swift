//
//  User.swift
//  SweaterShopIOS
//
//  Created by Shayan Shabanzadeh on 4/13/1402 AP.
//

import Foundation

struct User:Identifiable{
    var id = UUID()
    var firstName : String
    var lastName : String
    var email : String
    var password : String
}
