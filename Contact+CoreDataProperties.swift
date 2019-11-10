//
//  Contact+CoreDataProperties.swift
//  Contacts
//
//  Created by Carmel Braga on 11/4/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var notes: String?
    @NSManaged public var rawImage: NSData?

}
