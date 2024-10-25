//
//  BookmarkView.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/16/24.
//

import SwiftUI
import CoreData
import ResourceKit

struct BookmarkView: View {
    @State var toggleTitleLanguage: Bool = false
    @State var advices: [AdviceEntity] = []
    @Environment(\.managedObjectContext) private var viewContext
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(advices, id: \.id) { advice in
                    Image(uiImage: Images.advicePage.image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 10)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text(toggleTitleLanguage ? advice.content : advice.adviceKorean ?? advice.content)
                                    .font(.system(size: 16))
                                    .lineLimit(8)
                                    .padding(30)
                            }
                        }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                advices = await loadAdviceEntities(context: viewContext)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    toggleTitleLanguage.toggle()
                } label: {
                    Text("한/영")
                        .foregroundStyle(.black)
                }
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
