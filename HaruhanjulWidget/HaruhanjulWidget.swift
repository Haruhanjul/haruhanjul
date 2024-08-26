//
//  HaruhanjulWidget.swift
//  HaruhanjulWidget
//
//  Created by 최하늘 on 8/26/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    // 위젯이 초기 상태에서 데이터를 로드하기 전, 임시로 표시할 내용을 제공
    // 위젯을 추가할 때 로딩 중에 보여질 기본적인 뷰 생성
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    // 위젯 갤러리에서 위젯을 미리볼 때 사용
    // 실제 데이터를 가져오기 전에 빠르게 표시할 수 있는 샘플 데이터를 제공하거나 API를 통해 데이터를 가져오는 데 시간이 걸릴 경우 하드코딩된 데이터를 사용
    // context.isPreview가 true인 경우 위젯 갤러리에서 미리보기를 제공할 때 사용
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    // 위젯이 홈화면에서 언제 어떤 데이터를 표시할 지 결정
    // 위젯의 타임라인을 구성하고 타임라인 내의 각 항목(엔트리)이 어떤 시점에 표시될 지 정의
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        // 현재 날짜부터 시작하여 1시간 간격으로 5개의 항목으로 구성된 타임라인을 생성합니다.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            // 1시간뒤, 2시간뒤, ... 4시간뒤 엔트리 값으로 업데이트
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        // .atEnd: 마지막 date가 끝난 후 타임라인 reloading
        // .after: 다음 data가 지난 후 타임라인 reloading
        // .never: 즉시 타임라인 reloading
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    // 위젯이 언제 해당 항목을 화면에 표시할 지를 정함
    // 각 타임라인 항목이 특정 시점에 표시될 시간을 정의하고 시점에 맞춰 내용을 업데이트
    let date: Date
    
    // 위젯에 대한 사용자 설정, 사용자가 위젯 설정 화면에서 지정한 설정 값을 포함
    // 이 설정 값은 위젯의 UI나 동작에 영향을 미침
    let configuration: ConfigurationAppIntent
}

struct HaruhanjulWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    // 위젯의 데이터 모델로, 각 항목의 표시될 정보가 포함되어 있음
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }
        case .systemMedium:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .systemLarge:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .systemExtraLarge:  // ExtraLarge는 iPad의 위젯에만 표출
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .accessoryCorner:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .accessoryCircular:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .accessoryRectangular:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        case .accessoryInline:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
                
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
        @unknown default:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }
        }
    }
}

struct HaruhanjulWidget: Widget {
    // 위젯의 고유 식별자
    let kind: String = "HaruhanjulWidget"

    var body: some WidgetConfiguration {
        // IntentConfiguration: 사용자가 위젯에서 Edit을 통해 위젯에 보여지는 내용 변경이 가능
        // StaticConfiguration: 사용자가 변경 불가능한 정적 데이터 표출
        AppIntentConfiguration(
            kind: kind, // 위젯 ID
            intent: ConfigurationAppIntent.self, // 사용자가 위젯을 설정하는 인텐트
            provider: Provider() // 위젯 생성자: 언제 어떤 데이터를 표시할지 결정
        ) { entry in
            
            // 실제 표시될 UI 정의
            HaruhanjulWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("하루 한줄") // 위젯 설정 화면에서 표시될 위젯의 이름
        .description("하루에 한줄씩 읽어보세요.") // 위젯에 대한 설명을 정의
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    HaruhanjulWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
