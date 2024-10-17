//
//  Provider.swift
//  Haruhanjul
//
//  Created by 최하늘 on 10/4/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> AdviceEntry {
        return AdviceEntry(date: Date(), advice: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (AdviceEntry) -> ()) {
        let entry = AdviceEntry(date: Date(), advice: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<AdviceEntry>) -> Void) {
        var entries: [AdviceEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = AdviceEntry(date: entryDate, advice: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
