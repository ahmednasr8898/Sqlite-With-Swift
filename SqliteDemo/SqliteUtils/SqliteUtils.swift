//
//  SqliteUtils.swift
//  SqliteDemo
//
//  Created by Ahmed Nasr on 11/14/20.
//

import UIKit
import SQLite

class SqliteUtils: NSObject {
    
    //singletone
    static var share = SqliteUtils()
    //init table
    private let personTable = Table("person")
    //init column
    private let id = Expression<Int>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let age = Expression<Int>("age")
    //for connection with sqlite database
    private func connectionWithDataBase() -> Connection?{
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        do{
            print("Path: ", path)
            return try Connection("\(path)/db.sqlite3")
        }catch{
            print("error in function connectionWithDataBase", error.localizedDescription)
        }
        return nil
    }
    //for create table in sqlite database
    func createTable(){
        if let db = self.connectionWithDataBase(){
            do{
                try db.run(personTable.create(ifNotExists: true){ t in
                    t.column(id, primaryKey: true)
                    t.column(email, unique: true)
                    t.column(name)
                    t.column(age)
                })
            }catch{
                print("error in function createTable", error.localizedDescription)
            }
        }
    }
    //for insert data in table sqlite database
    func insertData(nameText: String, emailText: String, ageText: Int){
        if let db = self.connectionWithDataBase(){
            do{
                try db.run(personTable.insert(name <- nameText, email <- emailText, age <- ageText))
                print("Add Data is Success")
            }catch{
                print("error in function insertData", error.localizedDescription)
            }
        }
    }
    //for get all data form sqlite database
    func fetchAllData() -> [PersonModel]{
        var arrayOfPerson = [PersonModel]()
        if let db = self.connectionWithDataBase(){
            do{
                for item in try db.prepare(personTable) {
                    let person = PersonModel(id: item[id], name: item[name], email: item[email], age: item[age])
                    arrayOfPerson.append(person)
                }
            }catch{
                print("error in function insertData", error.localizedDescription)
            }
        }
        return arrayOfPerson
    }
    //for get selected data from sqlite database
    func fetchSelectedData(idPerson: Int){
        if let db = self.connectionWithDataBase(){
            do{
                let selectedData = personTable.filter(id == idPerson)
                for item in try db.prepare(selectedData) {
                    print("id: \(item[id]), email: \(item[email]), name: \(item[name]), age: \(item[age])")
                }
            }catch{
                print("error in function fetchSelectedData", error.localizedDescription)
            }
        }
    }
    //for update data
    func updateSelectedData(idPerson: Int, nameText: String, emailText: String, ageText: Int){
        if let db = self.connectionWithDataBase(){
            do{
                let itemSelected = personTable.filter(id == idPerson)
                try db.run(itemSelected.update(name <- nameText, email <- emailText, age <- ageText))
                print("Item is Updating")
            }catch{
                print("error in function updateSelectedData", error.localizedDescription)
            }
        }
    }
    //for delete all data in sqlite database
    func deleteAllData(){
        if let db = self.connectionWithDataBase(){
            do{
                try db.run(personTable.delete())
                print("All data is deleted")
            }catch{
                print("error in function deleteAllData", error.localizedDescription)
            }
        }
    }
    //for delete selected data in sqlite database
    func deleteSelectedData(idPerson: Int){
        if let db = self.connectionWithDataBase(){
            do{
                let itemSelected = personTable.filter(id == idPerson)
                try db.run(itemSelected.delete())
                print("item is deleting")
            }catch{
                print("error in function deleteSelectedData", error.localizedDescription)
            }
        }
    }
}
