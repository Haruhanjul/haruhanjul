//
//  HaruhanjulWidget.swift
//  HaruhanjulWidget
//
//  Created by 최하늘 on 10/4/24.
//

import WidgetKit
import SwiftUI

struct HaruhanjulWidget: Widget {
    let kind: String = "HaruhanjulWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HaruhanjulWidgetView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HaruhanjulWidgetView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    HaruhanjulWidget()
} timeline: {
    AdviceEntry(date: .now, emoji: "😀")
    AdviceEntry(date: .now, emoji: "🤩")
}
