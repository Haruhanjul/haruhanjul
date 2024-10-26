//
//  BookmarkViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import Foundation
import CoreData

final class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [AdviceEntity] = []
    
    func loadAdviceEntities(context: NSManagedObjectContext) async {
        let fetchRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isBookmarked == %d", true)
        
        do {
            let cdAdviceEntities = try context.fetch(fetchRequest)
            Task {
                await MainActor.run {
                    bookmarks = cdAdviceEntities.map { $0.toAdviceEntity() }
                }
            }
        } catch {
            print("데이터 로드 실패: \(error)")
        }
    }
}
