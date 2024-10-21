//
//  LaunchScreen.swift
//  Haruhanjul
//
//  Created by 최하늘 on 10/17/24.
//

import SwiftUI

struct LaunchScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()!
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
