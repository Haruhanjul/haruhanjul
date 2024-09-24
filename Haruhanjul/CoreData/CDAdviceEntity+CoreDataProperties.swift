//
//  CDAdviceEntity+CoreDataProperties.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/22/24.
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
    @NSManaged public var slipId: Int64 // advice 서버 명언 id
    @NSManaged public var id: Int64 // data index id
}

extension CDAdviceEntity {
    func toAdviceEntity() -> AdviceEntity {
        return AdviceEntity(id: Int(self.id), slipId: Int(self.slipId), content: self.content, adviceKorean: self.adviceKorean)
    }

    func update(from adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        self.slipId = Int64(adviceEntity.id)
        self.id = self.id
        self.content = adviceEntity.content
        self.adviceKorean = adviceEntity.adviceKorean
    }
}
