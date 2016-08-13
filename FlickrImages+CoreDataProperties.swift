//
//  FlickrImages+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/13/16.
//  Copyright © 2016 kishidak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FlickrImages {

    @NSManaged var image: NSData?
    @NSManaged var photos: Location?

}
