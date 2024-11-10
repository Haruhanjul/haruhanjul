//
//  SettingView.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/26/24.
//

import SwiftUI

struct SettingView: View {
    let viewModel = CardViewModel.shared
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                viewModel.resetAdvices(context: viewContext)
            } label: {
                Text("데이터 초기화")
            }
        }
    }
}

#Preview {
    SettingView()
}
