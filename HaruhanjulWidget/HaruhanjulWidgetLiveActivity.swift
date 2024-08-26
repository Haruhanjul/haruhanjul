//
//  HaruhanjulWidgetLiveActivity.swift
//  HaruhanjulWidget
//
//  Created by 최하늘 on 8/26/24.
//

import ActivityKit
import WidgetKit
import SwiftUI


// 활동의 속성과 상태를 정의하는 데 사용
// 동적이고 지속적인 콘텐츠를 제공하는 기능
struct HaruhanjulWidgetAttributes: ActivityAttributes {
    
    // 활동의 동적 상태를 정의
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // 활동의 정적 상태를 정의
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HaruhanjulWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HaruhanjulWidgetAttributes.self) { context in
            
            // 위젯의 잠금화면 또는 배너에서 표시될 UI를 정의
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            
            // 다이나믹 아일랜드의 UI를 정의
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HaruhanjulWidgetAttributes {
    fileprivate static var preview: HaruhanjulWidgetAttributes {
        HaruhanjulWidgetAttributes(name: "World")
    }
}

extension HaruhanjulWidgetAttributes.ContentState {
    fileprivate static var smiley: HaruhanjulWidgetAttributes.ContentState {
        HaruhanjulWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HaruhanjulWidgetAttributes.ContentState {
         HaruhanjulWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HaruhanjulWidgetAttributes.preview) {
   HaruhanjulWidgetLiveActivity()
} contentStates: {
    HaruhanjulWidgetAttributes.ContentState.smiley
    HaruhanjulWidgetAttributes.ContentState.starEyes
}
