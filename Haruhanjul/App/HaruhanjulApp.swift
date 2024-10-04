//
//  HaruhanjulApp.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/4/24.
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
