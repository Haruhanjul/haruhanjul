//
//  BookmarkView.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/16/24.
//

import SwiftUI
import CoreData

struct BookmarkView: View {
    @State var advices: [AdviceEntity] = []
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        ScrollView {
            VStack {
                ForEach(advices, id: \.id) { advice in
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 200)
                        .foregroundStyle(.gray.opacity(0.3))
                        .overlay {
                            VStack(alignment: .leading) {
                                Text(advice.adviceKorean ?? "")
                                Text(advice.content)
                            }
                        }
                        .padding(5)
                }
            }
        }
        .onAppear {
            Task {
                advices = await loadAdviceEntities(context: viewContext)
            }
        }
    }
    
    // 임시
    func loadAdviceEntities(context: NSManagedObjectContext) async -> [AdviceEntity] {
        let fetchRequest: NSFetchRequest<CDBookmark> = CDBookmark.fetchRequest()
        do {
            let cdAdviceEntities = try context.fetch(fetchRequest)
            return cdAdviceEntities.map { $0.toAdviceEntity().0 }
        } catch {
            print("데이터 로드 실패: \(error)")
            return []
        }
    }
}

#Preview {
    BookmarkView()
}
