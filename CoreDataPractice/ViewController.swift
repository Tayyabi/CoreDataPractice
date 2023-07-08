//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by M Tayyab on 08/07/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPeople()
        
        
    }
    
    func fetchPeople(){
        
        
        do{
            
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //let pred = NSPredicate(format: "name CONTAINS 'Ted'")
            //let pred = NSPredicate(format: "name CONTAINS %@", "Ted")
            //request.predicate = pred
            
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
        catch {
            
        }
        
    }

    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name", preferredStyle: .alert)
        alert.addTextField()
        
        
//        let textField = alert.textFields![0]
//        textField.text = person.name
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            
            let person = Person(context: self.context)
            person.name = textField.text
            person.age = 20
            person.gender = "Male"
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchPeople()
            
            
        }
        
        alert.addAction(submitButton)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    

}

extension ViewController:UITableViewDataSource, UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        
        cell.textLabel?.text = self.items![indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit name", preferredStyle: .alert)
        alert.addTextField()
        
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            
            person.name = textField.text
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchPeople()
            
            
        }
        
        
        alert.addAction(saveButton)
        
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete"){ (action,
            view, completionHandler) in
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            self.fetchPeople()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
