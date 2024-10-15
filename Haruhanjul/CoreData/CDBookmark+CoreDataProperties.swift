//
//  CDBookmark+CoreDataProperties.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/16/24.
//
//

import Foundation
import CoreData


extension CDBookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBookmark> {
        return NSFetchRequest<CDBookmark>(entityName: "CDBookmark")
    }
    
    @NSManaged public var savedDate: String
    @NSManaged public var adviceKorean: String?
    @NSManaged public var content: String
    @NSManaged public var id: Int64

}

extension CDBookmark : Identifiable {
    func toAdviceEntity() -> (AdviceEntity, String) {
        return (AdviceEntity(id: Int(self.id), content: self.content, adviceKorean: self.adviceKorean), self.savedDate)
    }

    func update(from adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        self.savedDate = formatter.string(from: Date())
        self.id = Int64(adviceEntity.id)
        self.content = adviceEntity.content
        self.adviceKorean = adviceEntity.adviceKorean
    }
}
