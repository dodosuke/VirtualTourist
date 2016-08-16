//
//  FlickrImages.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/13/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation
import CoreData


class FlickrImages: NSManagedObject {

    convenience init (image: NSData, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("FlickrImages", inManagedObjectContext: context){
            self.init(entity:ent, insertIntoManagedObjectContext: context)
            self.image = image
        } else {
            fatalError("")
        }
    }

}
