//
//  CoreDataEntity.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataEntity: class {

    static var entityName: String { get }

    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension CoreDataEntity where Self: NSManagedObject {

    static var entityName: String {
        return "\(Self.self)"
    }

    static var fetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }

    static func entity(context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
}
