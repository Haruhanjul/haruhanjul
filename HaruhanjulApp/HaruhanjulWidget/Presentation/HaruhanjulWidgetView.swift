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
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: AdviceEntry
    
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
                .font(Fonts.Diphylleia.regular.swiftUIFont(size: 16))
                .foregroundStyle(Color(Colors.blackText.color))
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    private func mediumView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .font(Fonts.Diphylleia.regular.swiftUIFont(size: 18))
                .foregroundStyle(Color(Colors.blackText.color))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func largeView(entry: AdviceEntry) -> some View {
        VStack {
            Text(entry.advice)
                .font(Fonts.Diphylleia.regular.swiftUIFont(size: 22))
                .foregroundStyle(Color(Colors.blackText.color))
                .multilineTextAlignment(.center)
        }
    }
}
