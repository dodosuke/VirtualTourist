//
//  Location.swift
//  VirtualTourist
//
//  Created by Keisuke Kishida on 8/13/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {

    convenience init (lat: Double, lon:Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Location", inManagedObjectContext: context){
            self.init(entity:ent, insertIntoManagedObjectContext: context)
            self.lat = lat
            self.lon = lon
        }else {
            fatalError("")
        }
    }

}
