//
//  HaruhanjulApp.swift
//  Haruhanjul
//
//  Created by 임대진 on 10/4/24.
//

import SwiftUI
import BackgroundTasks

import ResourceKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.daehaa.Haruhanjul.refresh", using: nil) { task in
            self.handleAdviceRefresh(task: task as! BGAppRefreshTask)
        }
        return true
    }
    
    // 백그라운드 작업 예약
    func scheduleAdviceRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.daehaa.Haruhanjul.refresh")

        let currentDate = Date()
        let calendar = Calendar.current

        let today = calendar.startOfDay(for: currentDate)

        let nextDay = calendar.date(byAdding: .day, value: 1, to: today)!
        let scheduleTime = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: nextDay)!

        request.earliestBeginDate = scheduleTime

        do {
            try BGTaskScheduler.shared.submit(request)
//            print("[BGTaskScheduler] submitted task with id: \(request.identifier)")
        } catch let error {
            print("[BGTaskScheduler] error:", error)
        }
    }

    // 백그라운드 작업이 트리거될 때 호출되는 함수
    func handleAdviceRefresh(task: BGAppRefreshTask) {
        CardViewModel.shared.removeAdvice(at: 0)
        
        task.setTaskCompleted(success: true)
        
        scheduleAdviceRefreshTask()
    }
}

@main
struct HaruhanjulApp: App {
    @State var isSplashView = true
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let adviceRefreshIdentifier = "com.daehaa.Haruhanjul.refresh"
    let persistenceController = PersistenceController.shared
    
    init() {
        Fonts.registerAllCustomFonts()
    }

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
        .onChange(of: scenePhase) { newValue in
            if newValue == .background {
                appDelegate.scheduleAdviceRefreshTask()
            }
        }
    }
}
