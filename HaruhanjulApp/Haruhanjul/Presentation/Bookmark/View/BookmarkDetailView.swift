//
//  BookmarkDetailView.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import SwiftUI
import ResourceKit

struct BookmarkDetailView: View {
    private let viewModel: BookmarkDetailViewModel
    @StateObject private var cardViewModel = CardViewModel.shared
    @Environment(\.managedObjectContext) private var viewContext
    
    init(viewModel: BookmarkDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    viewModel.advice.isBookmarked.toggle()
                    cardViewModel.toggleBookmark(id: viewModel.advice.id, isBookmarked: viewModel.advice.isBookmarked, context: viewContext)
                } label: {
                    Image(systemName: viewModel.advice.isBookmarked ? "bookmark.fill" : "bookmark")
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
            
            AdvicePage(advice: viewModel.advice)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.shareAdvice()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

//#Preview {
//    BookmarkDetailView()
//}
