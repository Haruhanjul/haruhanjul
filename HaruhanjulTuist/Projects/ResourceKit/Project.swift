import ProjectDescription

let resourceKit = Project(
    name: "ResourceKit",
    targets: [
        .target(
            name: "ResourceKit",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.daehaa.ResourceKit",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        ),
    ]
)
