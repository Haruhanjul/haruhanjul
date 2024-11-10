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
        let advice = AdviceDefaults.defaultText
        return AdviceEntry(date: Date(), advice: advice)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AdviceEntry) -> ()) {
        let advice = AdviceDefaults.defaultText
        let entry = AdviceEntry(date: Date(), advice: advice)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<AdviceEntry>) -> Void) {
        var entries: [AdviceEntry] = []
        let currentDate = Date()
        
        // 1시간 간격으로 5개의 타임라인 엔트리를 생성
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let advice = AdviceDefaults.firstAdvice
            let entry = AdviceEntry(date: entryDate, advice: advice)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
