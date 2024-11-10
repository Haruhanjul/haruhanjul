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
            if #available(iOS 17.0, *) {
                HaruhanjulWidgetView(entry: entry)
                    .containerBackground(Color(Colors.background.color), for: .widget)
                    .padding()
            } else {
                HaruhanjulWidgetView(entry: entry)
                    .background(Color(Colors.background.color))
                    .padding()
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
    AdviceEntry(date: .now, advice: "나는 너를 응원해, 아자아자 화이팅")
    AdviceEntry(date: .now, advice: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book")
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    HaruhanjulWidget()
} timeline: {
    AdviceEntry(date: .now, advice: "나는 너를 응원해, 아자아자 화이팅")
    AdviceEntry(date: .now, advice: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book")
}

@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    HaruhanjulWidget()
} timeline: {
    AdviceEntry(date: .now, advice: "나는 너를 응원해, 아자아자 화이팅")
    AdviceEntry(date: .now, advice: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book")
}
