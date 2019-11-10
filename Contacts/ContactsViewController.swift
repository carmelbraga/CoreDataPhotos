//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Carmel Braga on 11/4/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var contacts = [Contact]()
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchContacts()
        contactsTableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.firstName! + " " + contact.lastName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.deleteContact(indexPath: indexPath)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              guard let destination = segue.destination as? ContactDetailViewController else {
                  return
              }
              
              if let segueIdentifier = segue.identifier, segueIdentifier == "existingContact", let indexPathForSelectedRow = contactsTableView.indexPathForSelectedRow {
                  destination.contact = contacts[indexPathForSelectedRow.row]
              }
          }
    
    func fetchContacts() {
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             contacts = [Contact]()
             return
         }
         
         let managedContext = appDelegate.persistentContainer.viewContext
         let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
         
         do {
             contacts = try managedContext.fetch(fetchRequest)
         } catch {
            
            print("Fetch for contacts failed.")
         }
     }
     
     func deleteContact(indexPath: IndexPath) {
         let contact = contacts[indexPath.row]
         
         if let managedObjectContext = contact.managedObjectContext {
             managedObjectContext.delete(contact)
             
             do {
                 try managedObjectContext.save()
                 self.contacts.remove(at: indexPath.row)
                 contactsTableView.reloadData()
             } catch {
                 print("Delete failed.")
                 contactsTableView.reloadData()
             }
         }
     }
}


