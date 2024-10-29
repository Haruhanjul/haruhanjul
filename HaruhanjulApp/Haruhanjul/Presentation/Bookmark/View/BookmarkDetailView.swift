//
//  BookmarkDetailView.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import SwiftUI
import ResourceKit

struct BookmarkDetailView: View {
    @State var advice: AdviceEntity
    @StateObject private var viewModel = CardViewModel.shared
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    advice.isBookmarked.toggle()
                    viewModel.toggleBookmark(id: advice.id, isBookmarked: advice.isBookmarked, context: viewContext)
                } label: {
                    Image(systemName: advice.isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 30))
                        .foregroundStyle(.brown.opacity(0.8))
                        .scaleEffect(y: -1)
                        .mask {
                            Rectangle()
                                .frame(width: 20, height: 28)
                                .offset(y: -2)
                        }
                        .offset(y: 6)
                }
                .padding(.trailing, 40)
            }
            
            AdvicePage(imageName: Images.advicePage.image, advice: advice)
        }
    }
}

//#Preview {
//    BookmarkDetailView()
//}
