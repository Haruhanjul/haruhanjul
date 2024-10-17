//
//  HaruhanjulWidgetView.swift
//  Haruhanjul
//
//  Created by 최하늘 on 10/4/24.
//

import WidgetKit
import SwiftUI

struct HaruhanjulWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text(AdviceDefaults.content.first ?? "")
            Text(AdviceDefaults.content.last ?? "")
        }
    }
}