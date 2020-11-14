//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Ahmed Nasr on 11/14/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var persons = [PersonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        SqliteUtils.share.createTable()
        loadDataInTableView()
    }
    //reload data in tableView
    func loadDataInTableView(){
        persons = SqliteUtils.share.fetchAllData()
        self.tableView.reloadData()
    }
    //insert new data in table sqlite
    @IBAction func addDataOnClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Person", message: "", preferredStyle: .alert)
        alert.addTextField { (txt) in txt.placeholder = "put name"}
        alert.addTextField { (txt) in txt.placeholder = "put email"}
        alert.addTextField { (txt) in txt.placeholder = "put age"}
        let addButton = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = alert.textFields?[0].text, !name.isEmpty, let email = alert.textFields?[1].text, !email.isEmpty, let age = alert.textFields?[2].text, !age.isEmpty else{return}
            //add new column in table sqlite
            SqliteUtils.share.insertData(nameText: name, emailText: email, ageText: Int(age)!)
            self.loadDataInTableView()
        }
        alert.addAction(addButton)
        self.present(alert, animated: true, completion: nil)
    }
    //delete all data in table sqlite
    @IBAction func deleteAllDataOnClick(_ sender: Any) {
        SqliteUtils.share.deleteAllData()
        self.loadDataInTableView()
    }
}
//Tableview With DataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        cell.detailTextLabel?.text = persons[indexPath.row].email
        return cell
    }
}
//TableView With Delegate
extension ViewController: UITableViewDelegate{
    //for delete and edit row in tableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (_, _, _) in
            //selected item to delete
            let idPresonSelected = self.persons[indexPath.row].id
            //delete item
            SqliteUtils.share.deleteSelectedData(idPerson: idPresonSelected)
            self.loadDataInTableView()
        }
        let edit = UIContextualAction(style: .normal, title: "edit") { (_, _, _) in
            let alert = UIAlertController(title: "Edit Person", message: "", preferredStyle: .alert)
            alert.addTextField()
            alert.addTextField()
            alert.addTextField()
            //selected item to edit
            let personSelected = self.persons[indexPath.row]
            alert.textFields?[0].text = personSelected.name
            alert.textFields?[1].text = personSelected.email
            alert.textFields?[2].text = String(personSelected.age)
            
            let editButton = UIAlertAction(title: "Edit", style: .default) { (_) in
                guard let name = alert.textFields?[0].text, !name.isEmpty, let email = alert.textFields?[1].text, !email.isEmpty, let age = alert.textFields?[2].text, !age.isEmpty else{return}
                //edit item
                SqliteUtils.share.updateSelectedData(idPerson: personSelected.id, nameText: name, emailText: email, ageText: Int(age)!)
                self.loadDataInTableView()
            }
            alert.addAction(editButton)
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personSelected = persons[indexPath.row]
        //for get selected data
        SqliteUtils.share.fetchSelectedData(idPerson: personSelected.id)
    }
}

