//
//  PeelEffect.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/16/24.
//

import SwiftUI

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
