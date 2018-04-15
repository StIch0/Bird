//
//  UserModel.swift
//  Bird
//
//  Created by Pavel Burdukovskii on 08/04/18.
//  Copyright © 2018 Pavel Burdukovskii. All rights reserved.
//
import CoreData
import Foundation
class UserModel {
    var id : Int = Int()
    var userName : String = String()
    var password : String = String()
    init(id: Int, userName: String, password: String) {
        self.id = id
        self.userName = userName
        self.password = password
    }
    func getUserInfo() {
        print(self.id,"/n", self.userName,"/n", self.password ,"/n")
    }
    required init() {}
   
}
