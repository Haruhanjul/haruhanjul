//
//  CDAdviceEntity+CoreDataProperties.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/4/24.
//
//

import Foundation
import CoreData


extension CDAdviceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAdviceEntity> {
        return NSFetchRequest<CDAdviceEntity>(entityName: "CDAdviceEntity")
    }

    @NSManaged public var adviceKorean: String?
    @NSManaged public var content: String
    @NSManaged public var id: Int64

}

extension CDAdviceEntity {
    func toAdviceEntity() -> AdviceEntity {
        return AdviceEntity(id: Int(self.id), content: self.content, adviceKorean: self.adviceKorean)
    }

    func update(from adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        self.id = Int64(adviceEntity.id)
        self.content = adviceEntity.content
        self.adviceKorean = adviceEntity.adviceKorean
    }
}
