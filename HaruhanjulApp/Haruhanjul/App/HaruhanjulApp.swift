//
//  HaruhanjulApp.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/4/24.
//

import SwiftUI

@main
struct HaruhanjulApp: App {
    @State var isSplashView = true
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if isSplashView {
                LaunchScreen()
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isSplashView = false
                        }
                    }
                
            } else {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
