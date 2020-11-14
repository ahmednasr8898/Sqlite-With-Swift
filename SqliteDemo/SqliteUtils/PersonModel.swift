//
//  PersonModel.swift
//  SqliteDemo
//
//  Created by Ahmed Nasr on 11/14/20.
//

import Foundation

class PersonModel{
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var age: Int = 0
    
    init(id: Int, name: String, email: String, age: Int ) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
    }
}
