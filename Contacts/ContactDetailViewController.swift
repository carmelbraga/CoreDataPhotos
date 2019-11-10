//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Carmel Braga on 11/4/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var notesText: UITextView!
    @IBOutlet weak var lastLabel: UITextField!
    
    let imagePickerController = UIImagePickerController()
     
    var contact: Contact?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLabel.delegate = self
        lastLabel.delegate = self
        phoneLabel.delegate = self
        emailLabel.delegate = self
        notesText.delegate = self as? UITextViewDelegate
            
        if let contact = contact {
            firstLabel.text = contact.firstName
            lastLabel.text = contact.lastName
            phoneLabel.text = contact.phone
            emailLabel.text = contact.email
            notesText.text = contact.notes
            
            image = contact.image
            imageView.image = image
    
            }else {
            
                   firstLabel.text = ""
                   lastLabel.text = ""
                   phoneLabel.text = ""
                   emailLabel.text = ""
                   notesText.text = ""
                   imageView.image = nil
               }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        guard let requiredName = firstLabel.text, !requiredName.isEmpty else {
            
                    print("First name required.")
                    return
                }
         
                if let contact = contact {
                    contact.firstName = firstLabel.text
                    contact.lastName = lastLabel.text
                    contact.phone = phoneLabel.text
                    contact.email = emailLabel.text
                    contact.notes = notesText.text
                    contact.image = image
 
                } else {
                    contact = Contact(firstName: firstLabel.text!, lastName: lastLabel.text!, phone: phoneLabel.text!, email: emailLabel.text!, notes: notesText.text, image: image)
                }
                
                if let contact = contact {
                    do {
                        let managedContext = contact.managedObjectContext
                        try managedContext?.save()
                    } catch {
                        print("The contact note could not be saved.")
                    }
                    
                }
                
        navigationController?.popViewController(animated: true)
            }
    
    @IBAction func cameraWasClicked(_ sender: Any) {
        
        choosePhoto()
    }
    
        func cameraWasClicked() {
            let alert = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
                (alertAction) in
                self.takePhoto()
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
                (alertAction) in
                self.choosePhoto()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        func takePhoto() {
            if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                print("No camera available.")
                return
            }
            
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
        
        func choosePhoto() {
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            defer {
                imagePickerController.dismiss(animated: true, completion: nil)
            }
            
            guard let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            image = selectedPhoto
            imageView.image = image
            if let contact = contact {
                contact.image = selectedPhoto
            }
        }
}

extension ContactDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
  }
}

