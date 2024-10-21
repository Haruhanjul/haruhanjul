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

    var body: some View {
        @Environment(\.widgetFamily) var widgetFamily

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
<<<<<<< HEAD
                .foregroundStyle(Color(Colors.blackHaru.color))
=======
                .foregroundStyle(Color(Colors.blackText.color))
>>>>>>> a938c7c (feat: 리소스 프레임워크 추가)
        }
    }
    
    @ViewBuilder
    private func mediumView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
<<<<<<< HEAD
                .foregroundStyle(Color(Colors.blackHaru.color))
=======
                .foregroundStyle(Color(Colors.blackText.color))
>>>>>>> a938c7c (feat: 리소스 프레임워크 추가)
        }
    }
    
    @ViewBuilder
    private func largeView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .foregroundStyle(Color(Colors.blackHaru.color))
        }
    }
}
