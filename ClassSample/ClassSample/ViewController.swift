//
//  ViewController.swift
//  ClassSample
//
//  Created by Tran Thanh Trung on 19/01/2022.
//

import UIKit

class ViewController: UIViewController {

    var names: [String] = ["Mạnh Đạt", "Văn Khánh", "Duy Dũng", "Mai Trang"]
    
    var db:DBHelper = DBHelper()
    var persons: [Student] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bảng Điểm Lớp XX"
        
        // dang ki cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //delegate & datasouce
        tableView.delegate = self
        tableView.dataSource = self
        
        // Insert data vao database
        db.insert(id: 1, name: "Thanh Trung", age: 17, yearOfBirth: 2005, math: 9.5, physic: 9.5, science: 9, address: "Royal City")
        db.insert(id: 2, name: "Manh Dat", age: 17, yearOfBirth: 2005, math: 8, physic: 9, science: 7, address: "Times City")
        db.insert(id: 3, name: "Van Khanh", age: 17, yearOfBirth: 2005, math: 9.5, physic: 7, science: 8.5, address: "Royal City")
        db.insert(id: 4, name: "Duy Dung", age: 17, yearOfBirth: 2005, math: 9, physic: 8, science: 10, address: "Smart City")
        db.insert(id: 5, name: "Mai Trang", age: 17, yearOfBirth: 2005, math: 10, physic: 7.5, science: 8.5, address: "An Hung")
        
        persons = db.read()
        print("TOAN BO PERSON VUA INSERT \(persons.count)")
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
