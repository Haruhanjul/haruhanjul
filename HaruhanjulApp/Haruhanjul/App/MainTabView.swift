//
//  MainTabView.swift
//  Haruhanjul
//
//  Created by 최하늘 on 8/20/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                CurlView()
            }
            .tabItem {
                Image(systemName: "text.page")
                    .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                Text("명언")
            }
            .tag(0)
            
            NavigationView {
                BookmarkView()
            }
            .tabItem {
                Image(systemName: "bookmark")
                    .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                Text("북마크")
            }
            .tag(1)
            
            NavigationView {
                SettingView()
            }
            .tabItem {
                Image(systemName: "gearshape")
                    .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                Text("설정")
            }
            .tag(2)
        }
        .tint(.brown)
    }
}

#Preview {
    MainTabView()
}
