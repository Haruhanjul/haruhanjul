//
//  CurlView.swift
//  Haruhanjul
//
//  Created by 임대진 on 8/30/24.
//

import SwiftUI
import WidgetKit
import ResourceKit

struct CurlView: View {
    let bookmarkSize: CGFloat = 30
    let bookmarkOffset: CGFloat = 6
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = CardViewModel.shared
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Image(uiImage: Images.advicePage.image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .padding(.top, bookmarkSize + bookmarkOffset)
                ProgressView()
            } else {
                ForEach(Array(viewModel.advices.enumerated()), id: \.element.id) { index, advice in
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Button {
                                viewModel.advices[index].isBookmarked.toggle()
                                viewModel.toggleBookmark(id: advice.id, isBookmarked: viewModel.advices[index].isBookmarked, context: viewContext)
                            } label: {
                                Image(systemName: viewModel.advices[index].isBookmarked ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: bookmarkSize))
                                    .foregroundStyle(index == 0 ? .brown.opacity(0.8) : .clear)
                                    .scaleEffect(y: -1)
                                    .mask {
                                        Rectangle()
                                            .frame(width: 20, height: 28)
                                            .offset(y: -2)
                                    }
                                    .offset(y: bookmarkOffset)
                            }
                            .padding(.trailing, 40)
                        }
                        
                        PeelEffect(dragProgress: $viewModel.dragProgresses[index]) {
                            AdvicePage(advice: advice)
                        } onDelete: {
                            viewModel.removeAdvice(at: index)
                        } setBack: {
                            viewModel.restoreAdvice(at: index)
                        }
                        .contentShape(Rectangle())
                        .allowsHitTesting(true)
                    }
                    .zIndex(zIndex(index))
                }
            }
        }
        .navigationTitle("하루한줄")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadAdvices(context: viewContext)
        }
        .onChange(of: viewModel.lastIndex) { value in
            AdviceDefaults.cardIndex = value
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
            }
        }
    }
    
    private func zIndex(_ index: Int) -> Double {
        return Double(viewModel.advices.count - index)
    }
}

#Preview {
    CurlView()
}
