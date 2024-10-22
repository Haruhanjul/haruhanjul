//
//  HaruhanjulWidget.swift
//  HaruhanjulWidget
//
//  Created by 최하늘 on 10/4/24.
//

import WidgetKit
import SwiftUI

import ResourceKit

struct HaruhanjulWidget: Widget {
    let kind: String = "HaruhanjulWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ZStack {
                Color(Colors.background.color)
                    .ignoresSafeArea()
                if #available(iOS 17.0, *) {
                    HaruhanjulWidgetView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                } else {
                    HaruhanjulWidgetView(entry: entry)
                }
            }
        }
        .configurationDisplayName("하루한줄")
        .description("하루에 새로운 한 줄, 내일을 바꾸는 시작!")
        .contentMarginsDisabled()
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    HaruhanjulWidget()
} timeline: {
    AdviceEntry(date: .now, advice: "😀")
    AdviceEntry(date: .now, advice: "🤩")
}
