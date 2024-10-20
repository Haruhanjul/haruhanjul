//
//  HaruhanjulApp.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/4/24.
//

import SwiftUI
import BackgroundTasks

@main
struct HaruhanjulApp: App {
    @State var isSplashView = true
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var cardViewModel: CardViewModel
    
    let adviceRefreshIdentifier = "com.daehaa.Haruhanjul.refresh"
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
                    .environmentObject(CardViewModel())
            }
        }
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .background {
                scheduleAdviceRefreshTask()
            }
        })
        .backgroundTask(.appRefresh(adviceRefreshIdentifier)) {
            await cardViewModel.removeAdvice(at: 0, context: viewContext)
        }
    }
    
    private func scheduleAdviceRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: adviceRefreshIdentifier)

        let currentDate = Date()
        let calendar = Calendar.current
        
        let midnight = calendar.nextDate(after: currentDate, matching: .init(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime)!
        let nineAM = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: midnight)!

        if currentDate > nineAM {
            let nextDay = calendar.date(byAdding: .day, value: 1, to: midnight)!
            request.earliestBeginDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: nextDay)!
        } else {
            request.earliestBeginDate = nineAM
        }

        do {
            try BGTaskScheduler.shared.submit(request)
            print("[BGTaskScheduler] submitted task with id: \(request.identifier)")
        } catch let error {
            print("[BGTaskScheduler] error:", error)
        }
    }
}
