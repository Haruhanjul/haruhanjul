//
//  BookmarkDetailViewModel.swift
//  Haruhanjul
//
//  Created by 최하늘 on 11/4/24.
//

import UIKit
import SwiftUI
import Combine

final class BookmarkDetailViewModel: ObservableObject {
    
    var advice: AdviceEntity
    
    init(advice: AdviceEntity) {
        self.advice = advice
    }
    
    func shareAdvice() {
        if let image = captureAdviceAsImage() {
            guard let imageData = image.pngData() else { return }
           
            let fileName = "Haruhanjul_\(UUID().uuidString).png"
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let fileURL = temporaryDirectory.appendingPathComponent(fileName)

            do {
                try imageData.write(to: fileURL)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let currentVC = windowScene.windows.first?.rootViewController {
                    currentVC.present(UIActivityViewController(activityItems: [fileURL], applicationActivities: nil), animated: true)
                }
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }

    private func captureAdviceAsImage() -> UIImage? {
        let hostingController = UIHostingController(rootView: AdvicePage(advice: advice))
        let screenSize = UIScreen.main.bounds.size
        hostingController.view.frame = CGRect(origin: .zero, size: screenSize)

        let renderer = UIGraphicsImageRenderer(size: screenSize)
        return renderer.image { context in
            context.cgContext.clear(CGRect(origin: .zero, size: screenSize))
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
    }
}
