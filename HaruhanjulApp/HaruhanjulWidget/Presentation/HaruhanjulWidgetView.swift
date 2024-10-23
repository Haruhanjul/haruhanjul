//
//  HaruhanjulWidgetView.swift
//  Haruhanjul
//
//  Created by 최하늘 on 10/4/24.
//

import WidgetKit
import SwiftUI

import ResourceKit

struct HaruhanjulWidgetView : View {
    var entry: AdviceEntry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {

        switch widgetFamily {
        case .systemSmall:
            smallView(entry: entry)
        case .systemMedium:
            mediumView(entry: entry)
        case .systemLarge:
            largeView(entry: entry)
        default:
            smallView(entry: entry)
        }
    }
    
    @ViewBuilder
    private func smallView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .foregroundStyle(Color(Colors.blackText.color))
                .font(.body)
        }
    }
    
    @ViewBuilder
    private func mediumView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .foregroundStyle(Color(Colors.blackText.color))
        }
    }
    
    @ViewBuilder
    private func largeView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .foregroundStyle(Color(Colors.blackText.color))
        }
    }
}


@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    HaruhanjulWidget()
} timeline: {
    AdviceEntry(date: .now, advice: "새로운 하루 한줄을 만나보세요.")
    AdviceEntry(date: .now, advice: "🤩")
}
