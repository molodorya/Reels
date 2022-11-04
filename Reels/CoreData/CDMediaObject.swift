//
//  MediaObject.swift
//  Reels
//
//  Created by Nikita Molodorya on 04.11.2022.
//

import Foundation
import CoreData


public class CDMediaObject: NSManagedObject {

}


extension CDMediaObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMediaObject> {
        return NSFetchRequest<CDMediaObject>(entityName: "CDMediaObject")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var caption: String?
    @NSManaged public var videoData: Data?
    @NSManaged public var imageData: Data?

}
