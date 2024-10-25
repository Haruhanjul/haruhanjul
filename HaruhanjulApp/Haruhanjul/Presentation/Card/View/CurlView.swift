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
                    .padding(.top, 36)
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
                                    .font(.system(size: 30))
                                    .foregroundStyle(index == 0 ? .yellow : .clear)
                                    .scaleEffect(y: -1)
                                    .mask {
                                        Rectangle()
                                            .frame(width: 20, height: 28)
                                            .offset(y: -2)
                                    }
                                    .offset(y: 6)
                            }
                            .padding(.trailing, 30)
                        }
                        
                        PeelEffect(dragProgress: $viewModel.dragProgresses[index]) {
                            AdvicePage(imageName: Images.advicePage.image, advice: advice)
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
        .onAppear {
            viewModel.loadAdvices(context: viewContext)
        }
        .onChange(of: viewModel.lastIndex) { value in
            AdviceDefaults.cardIndex = value
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.resetAdvices(context: viewContext)
                } label: {
                    Text("초기화")
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.isLoading)
            }
        }
    }
    
    private func zIndex(_ index: Int) -> Double {
        return Double(viewModel.advices.count - index)
    }
}

#Preview {
    CurlView()
//        .environmentObject(CardViewModel())
}
