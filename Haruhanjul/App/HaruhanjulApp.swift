//
//  HaruhanjulApp.swift
//  Haruhanjul
//
//  Created by 최하늘 on 8/20/24.
//

import SwiftUI

@main
struct HaruhanjulApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
