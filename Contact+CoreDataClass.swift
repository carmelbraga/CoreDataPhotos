//
//  Contact+CoreDataClass.swift
//  Contacts
//
//  Created by Carmel Braga on 11/4/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    
     var image: UIImage? {
           get {
               if let rawData = rawImage as Data? {
                   return UIImage(data: rawData)
               } else {
                   return nil
               }
           }
           set {
               if let image = newValue {
                   rawImage = convertImageToNSData(image: image)
               }
           }
       }
    
    convenience init?(firstName: String, lastName: String, phone: String, email: String, notes: String?, image: UIImage?) {
        
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
        guard let managedContext = appDelegate?.persistentContainer.viewContext, !firstName.isEmpty else {
                   return nil
               }
            
            self.init(entity: Contact.entity(), insertInto: managedContext)
        
            self.firstName = firstName
            self.lastName = lastName
            self.phone = phone
            self.email = email
            self.notes = notes
            
            if let image = image {
                self.rawImage = convertImageToNSData(image: image)
            }
        }
        
        func convertImageToNSData(image: UIImage) -> NSData? {
            return processImage(image: image).pngData() as NSData?
        }
        
    
        func processImage(image: UIImage) -> UIImage {
            if (image.imageOrientation == .up) {
                return image
            }
            
            UIGraphicsBeginImageContext(image.size)
            
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
            let copy = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let unwrappedCopy = copy else {
                return image
            }
            
            return unwrappedCopy
        }
    }

