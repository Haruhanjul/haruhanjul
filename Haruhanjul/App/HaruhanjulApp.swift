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
    @StateObject var cardViewModel = CardViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
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
                    .environmentObject(cardViewModel)
            }
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background {
                scheduleAdviceRefreshTask()
            }
        }
        .backgroundTask(.appRefresh(adviceRefreshIdentifier)) {
            await cardViewModel.removeAdvice(at: 0)
        }
    }
    
    // 매일 오전 9시 명언 업데이트 백그라운드 작업
    private func scheduleAdviceRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: adviceRefreshIdentifier)

        let currentDate = Date()
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: currentDate)

        let nextDay = calendar.date(byAdding: .day, value: 1, to: today)!
        let scheduleTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: nextDay)!

        request.earliestBeginDate = scheduleTime

        do {
            try BGTaskScheduler.shared.submit(request)
            print("[BGTaskScheduler] submitted task with id: \(request.identifier)")
        } catch let error {
            print("[BGTaskScheduler] error:", error)
        }
    }
}
