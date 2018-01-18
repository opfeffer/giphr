//
//  ManagedGiphy+CoreDataClass.swift
//  Giphr
//
//  Created by Oli Pfeffer on 1/17/18.
//  Copyright © 2018 Oliver Pfeffer. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedGiphy)
public class ManagedGiphy: NSManagedObject, CoreDataEntity {

    static var defaultSortDescriptors: [NSSortDescriptor] = [
        NSSortDescriptor(keyPath: \ManagedGiphy.archiveDate, ascending: false)
    ]

    @NSManaged public var mp4: URL
    @NSManaged public var webURL: URL
    @NSManaged public var id: String
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var archiveDate: Date

    public init(context: NSManagedObjectContext, id: String, webURL: URL, mp4: URL, width: Float, height: Float) {
        super.init(entity: ManagedGiphy.entity(context: context), insertInto: context)

        self.id = id
        self.webURL = webURL
        self.mp4 = mp4
        self.width = width
        self.height = height
        self.archiveDate = Date()
    }

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}

// MARK: -

import GiphyClient

extension ManagedGiphy {

    public class func newGiphy(in context: NSManagedObjectContext, giphy: Giphy) -> ManagedGiphy {
        return ManagedGiphy(context: context,
                            id: giphy.id,
                            webURL: giphy.webURL,
                            mp4: giphy.mp4,
                            width: Float(giphy.size.width),
                            height: Float(giphy.size.height))
    }
}
