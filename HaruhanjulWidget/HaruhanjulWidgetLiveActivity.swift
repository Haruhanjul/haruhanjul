//
//  HaruhanjulWidgetLiveActivity.swift
//  HaruhanjulWidget
//
//  Created by 최하늘 on 8/26/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HaruhanjulWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HaruhanjulWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HaruhanjulWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
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
