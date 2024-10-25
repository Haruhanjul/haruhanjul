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
                Image(uiImage: Images.advidePage.image)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 10)
                ProgressView()
            } else {
                ForEach(Array(viewModel.advices.enumerated()), id: \.element.id) { index, advice in
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            Button {
                                viewModel.toggleBookmark(id: advice.id, at: index, advice: advice, context: viewContext)
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
                            ZStack {
                                Image(uiImage: Images.advidePage.image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 10)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(advice.content)
                                        .font(Fonts.Diphylleia.regular.swiftUIFont(size: 20))
                                        .multilineTextAlignment(.center)
                                    Text(advice.adviceKorean ?? "")
                                        .font(Fonts.Diphylleia.regular.swiftUIFont(size: 16))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.horizontal, 50)
                            }
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
                .padding()
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
