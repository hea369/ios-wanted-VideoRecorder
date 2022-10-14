//
//  Title+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by 엄철찬 on 2022/10/15.
//
//

import Foundation
import CoreData


extension Title {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
        return NSFetchRequest<Title>(entityName: "Title")
    }

    @NSManaged public var title: String?

}

extension Title : Identifiable {

}
