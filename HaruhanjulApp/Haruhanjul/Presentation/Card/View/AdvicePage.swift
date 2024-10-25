//
//  AdvicePage.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import SwiftUI

struct AdvicePage: View {
    let imageName: UIImage
    let advice: AdviceEntity
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
            }
            .padding(.horizontal, 20)
    }
}

//#Preview {
//    AdvicePage()
//}
