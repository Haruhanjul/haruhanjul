//
//  MainTabView.swift
//  Haruhanjul
//
//  Created by 최하늘 on 8/20/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                CurlView(count: 11)
            }
            .tabItem {
                Image(systemName: "plus.circle")
                Text("첫번째")
            }
            
            NavigationView {
                Text("zz")
            }
            .tabItem {
                Image(systemName: "trophy.circle")
                Text("두번째")
            }
            
            NavigationView {
                Text("zz")
            }
            .tabItem {
                Image(systemName: "info.circle")
                Text("세번째")
            }
        }
    }
}

#Preview {
    MainTabView()
}
