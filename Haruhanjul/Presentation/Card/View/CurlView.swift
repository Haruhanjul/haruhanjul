//
//  CurlView.swift
//  Haruhanjul
//
//  Created by 임대진 on 8/30/24.
//

import SwiftUI

struct CurlView: View {
    @State private var advices: [AdviceEntity] = []
    @State private var removedAdvices: [AdviceEntity] = []
    @State private var removedCount = 0
    @State private var lastIndex = 0
    @State private var dragProgresses: [CGFloat] = []
    @State private var isLoading: Bool = true
    @State private var updateTrigger = false
    @StateObject var cardStore = CardViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            if isLoading {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.yellow)
                    .frame(height: 200)
                    .padding()
                ProgressView()
            } else {
                ForEach(Array(advices.enumerated()), id: \.element.uuid) { index, advice in
                    PeelEffect(dragProgress: $dragProgresses[index]) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.yellow)
                                .overlay(alignment: .topTrailing) {
                                    Text("\(advice.id)")
                                        .padding()
                                }
                            
                            VStack(alignment: .center, spacing: 16) {
                                Text(advice.adviceKorean ?? "")
                                Text(advice.content)
                            }
                            .padding()
                        }
                        .frame(height: 200)
                    } onDelete: {
                        removedAdvices.append(advices.removeFirst())
                        removedCount -= 1
                        lastIndex += 1
                    } setBack: {
                        if !removedAdvices.isEmpty {
                            dragProgresses[index] = 1
                            advices.insert(removedAdvices.removeLast(), at: 0)
                            removedCount += 1
                            lastIndex -= 1
                        }
                    }
                    .zIndex(zIndex(index))
                }
                .padding()
            }
        }
        .onChange(of: advices.count) { value in
            // 불러온 명언 4개 이하 남을시 5개 불러옴
            if value <= 4 { fetchAdvice(count: 5) }
        }
        .onAppear {
            Task {
                if !cardStore.isTranslatorReady {
                    await cardStore.downloadTranslatorModel()
                }
                
                lastIndex = AdviceDefaults.cardIndex
                
                cardStore.loadAdviceEntities(context: viewContext) { result, count in
                    if count < 10 {
                        fetchAdvice(count: 10)
                    } else {
                        dragProgresses = Array(repeating: 0, count: count)
                        removedAdvices = Array(result[0..<lastIndex])
                        advices = Array(result[lastIndex..<result.count])
                        removedCount = count
                        isLoading = false
                        print("명언 카드 \(count)개 로드")
                    }
                }
            }
        }
        .onDisappear {
            AdviceDefaults.cardIndex = lastIndex
            print(AdviceDefaults.cardIndex)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
//                        isLoading = true
//                        await cardStore.deleteAllAdviceEntities(context: viewContext)
//                        removedCount = 0
//                        lastIndex = 0
//                        fetchAdvice(count: 10)
                    }
                } label: {
                    Text("초기화")
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isLoading)
            }
        }
    }
    
    private func fetchAdvice(count: Int) {
        print("fetchAdvice")
        Task {
            await MainActor.run {
                cardStore.downloadAdvices(count: count, context: viewContext) { result in
                    dragProgresses.append(contentsOf: Array(repeating: 0, count: result.count))
                    advices.append(contentsOf: result)
                    removedCount += result.count
                    removedCount += count
                }
            }
            isLoading = false
            print(advices.map { $0.adviceKorean })
        }
    }
    
    private func zIndex(_ index: Int) -> Double {
        return Double(advices.count - index)
    }
}


struct PeelEffect<Content: View>: View {
    var content: Content
    var onDelete: () -> ()
    var setBack: () -> ()
    @Binding var dragProgress: CGFloat
    
    init(dragProgress: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content, onDelete: @escaping () -> (), setBack: @escaping () -> ()) {
        self._dragProgress = dragProgress
        self.content = content()
        self.onDelete = onDelete
        self.setBack = setBack
    }
    
    var body: some View {
        content
            .clipShape(.rect(cornerRadius: 16))
            .mask {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .padding(.trailing, dragProgress * rect.width)
                }
            }
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let minOpacity = dragProgress / 0.05
                    let opacity = min(1, minOpacity)
                    
                    content
                    //                      RoundedRectangle(cornerRadius: 16)
                    //                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0), radius: 5, x: 15, y: 0)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        }
                        .overlay(alignment: .trailing) {
                            // 가장자리 빛 반사
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.linearGradient(colors: [.clear, .white, .clear, .clear], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60)
                                .offset(x: 40)
                                .offset(x: -30 + (30 * opacity))
                                .offset(x: size.width * -dragProgress)
                        }
                        .scaleEffect(x: -1)
                        .offset(x: size.width - (size.width * dragProgress))
                        .offset(x: size.width * -dragProgress)
                        .mask {
                            RoundedRectangle(cornerRadius: 16)
                                .offset(x: size.width * -dragProgress)
                        }
                        .contentShape(.rect(cornerRadius: 16))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translationX = value.translation.width
                                    let progress = min(1, max(-translationX, 0) / size.width)
                                    dragProgress = progress
                                }
                                .onEnded { value in
                                    // 왼쪽 드래그 넘기기
                                    withAnimation {
                                        if dragProgress > 0.4 {
                                            dragProgress = 1
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                onDelete()
                                                dragProgress = .zero
                                            }
                                        } else {
                                            dragProgress = .zero
                                        }
                                    }
                                    
                                    //오른쪽 드래그 되돌리기
                                    if value.translation.width / size.width > 0.4 {
                                        setBack()
                                        withAnimation {
                                            dragProgress = .zero
                                        }
                                    }
                                }
                        )
                }
            }
        // 넘길때 그림자
            .background {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Rectangle()
                        .fill(.black)
                        .padding(.vertical, 20)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 30, y: 0)
                        .padding(.trailing, rect.width * dragProgress)
                }
                .mask(content)
            }
    }
}

#Preview {
    CurlView()
}
