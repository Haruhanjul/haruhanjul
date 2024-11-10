//
//  AdvicePage.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import SwiftUI
import ResourceKit

struct AdvicePage: View {
    
    let advice: AdviceEntity
    
    private let imageName = Images.advicePage.image
    
    var body: some View {
        Image(uiImage: imageName)
            .resizable()
            .scaledToFit()
            .overlay {
                VStack(alignment: .leading, spacing: 16) {
                    Text(advice.content)
                    Text(advice.adviceKorean ?? "")
                }
                .padding(.horizontal, 30)
                .font(Fonts.Diphylleia.regular.swiftUIFont(size: 16))
            }
            .padding(.horizontal, 20)
    }
}

//#Preview {
//    AdvicePage()
//}
