import ProjectDescription

let project = Project(
    name: "Haruhanjul",
//    settings: .settings(configurations: [
//        .debug(name: "Debug", xcconfig: "./xcconfigs/Haruhanjul-Project.xcconfig"),
//        .debug(name: "Release", xcconfig: "./xcconfigs/Haruhanjul-Project.xcconfig"),
//    ]),
    organizationName: "com.daehaa",
    settings: .settings(
        base: [
            "CODE_SIGN_STYLE": "Automatic",
            "DEVELOPMENT_TEAM": "3URYLCPH2H",
        ]
    ),
    targets: [
        .target(
            name: "Haruhanjul",
            destinations: .iOS,
            product: .app,
            bundleId: "com.daehaa.Haruhanjul",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIBackgroundModes": ["fetch", "processing"],
                    "BGTaskSchedulerPermittedIdentifiers": ["com.daehaa.Haruhanjul.refresh"]
                ]
            ),
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Sources/App/LaunchScreen.storyboard",
                .glob(pattern: "Sources/CoreData/Haruhanjul.xcdatamodeld")
            ],
            entitlements: "Config/Haruhanjul.entitlements",
            dependencies: [
                .project(target: "ResourceKit", path: "../ResourceKit"),
                .project(target: "NetworkKit", path: "../NetworkKit"),
                .target(name: "HaruhanjulWidget")
            ],
            settings: .settings(base: [
                "APP_GROUP": "group.com.daehaa.Haruhanjul"
            ])
        ),
        .target(
            name: "HaruhanjulWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.daehaa.Haruhanjul.HaruhanjulWidget",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDisplayName": "$(PRODUCT_NAME)",
                "UIUserInterfaceStyle": "Light",
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
            ]),
            sources: ["HaruhanjulWidget/Sources/**","Sources/Utils/UserDefault.swift"],
            resources: "HaruhanjulWidget/Resources/**",
            entitlements: "HaruhanjulWidget/Config/HaruhanjulWidgetExtension.entitlements",
            settings: .settings(base: [
                "APP_GROUP": "group.com.daehaa.Haruhanjul"
            ])
        )
//        .target(
//            name: "HaruhanjulTests",
//            destinations: .iOS,
//            product: .unitTests,
//            bundleId: "com.daehaa.HaruhanjulTests",
//            infoPlist: .default,
//            sources: ["Projects/App/Tests/**"],
//            resources: [],
//            dependencies: [
//                .target(name: "Haruhanjul")
//            ]
//        ),
    ]
)
