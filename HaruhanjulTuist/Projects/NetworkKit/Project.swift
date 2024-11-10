import ProjectDescription

let NetworkKit = Project(
    name: "NetworkKit",
    targets: [
        .target(
            name: "NetworkKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.daehaa.NetworkKit",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "Alamofire")
            ]
        ),
//        .target(
//            name: "NetworkKitTests",
//            destinations: .iOS,
//            product: .unitTests,
//            bundleId: "com.daehaa.NetworkKitTests",
//            infoPlist: .default,
//            sources: ["Haruhanjul/Tests/**"],
//            resources: [],
//            dependencies: [
//                .target(name: "NetworkKit")
//            ]
//        ),
    ]
)
