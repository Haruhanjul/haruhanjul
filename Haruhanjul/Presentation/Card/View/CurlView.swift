//
//  CurlView.swift
//  Haruhanjul
//
//  Created by 임대진 on 8/30/24.
//

import SwiftUI
import WidgetKit

struct CurlView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewModel: CardViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.yellow)
                    .frame(height: 200)
                    .padding()
                ProgressView()
            } else {
                ForEach(Array(viewModel.advices.enumerated()), id: \.element.id) { index, advice in
                    VStack {
                        PeelEffect(dragProgress: $viewModel.dragProgresses[index]) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.yellow)
                                
                                VStack(alignment: .center, spacing: 16) {
                                    Text(advice.adviceKorean ?? "")
                                    Text(advice.content)
                                }
                                .padding()
                            }
                            .frame(height: 200)
                        } onDelete: {
                            viewModel.removeAdvice(at: index)
                        } setBack: {
                            viewModel.restoreAdvice(at: index)
                        }
                        Button {
                            viewModel.toggleBookmark(id: advice.id, at: index, advice: advice, context: viewContext)
                        } label: {
                            Image(systemName: viewModel.advices[index].isBookmarked ? "star.fill" : "star")
                                .resizable()
                                .foregroundStyle(index == 0 ? .brown : .clear)
                                .frame(width: 25, height: 25)
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
        .environmentObject(CardViewModel())
}
