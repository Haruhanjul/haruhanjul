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
    @StateObject var bookmarkViewModel: BookmarkViewModel = BookmarkViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            if bookmarkViewModel.bookmarks.isEmpty {
                Text("즐겨찾기가 없습니다.")
            } else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                    ForEach(bookmarkViewModel.bookmarks, id: \.id) { advice in
                        NavigationLink {
                            BookmarkDetailView(advice: advice)
                        } label: {
                            Image(uiImage: Images.advicePage.image)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 10)
                                .overlay {
                                    VStack(alignment: .leading) {
                                        Text(toggleTitleLanguage ? advice.content : advice.adviceKorean ?? advice.content)
                                            .font(Fonts.Diphylleia.regular.swiftUIFont(size: 16))
                                            .foregroundStyle(.black)
                                            .lineLimit(8)
                                            .padding(30)
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await bookmarkViewModel.loadAdviceEntities(context: viewContext)
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
}

#Preview {
    BookmarkView()
}
