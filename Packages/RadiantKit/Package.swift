// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RadiantKit",
  platforms: [.iOS(.v17), .macCatalyst(.v17), .macOS(.v14), .tvOS(.v17), .visionOS(.v1), .watchOS(.v10)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "RadiantKit",
      targets: ["RadiantKit"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "RadiantKit",
      swiftSettings: [
        SwiftSetting.enableUpcomingFeature("BareSlashRegexLiterals"),
        SwiftSetting.enableUpcomingFeature("ConciseMagicFile"),
        SwiftSetting.enableUpcomingFeature("ExistentialAny"),
        SwiftSetting.enableUpcomingFeature("ForwardTrailingClosures"),
        SwiftSetting.enableUpcomingFeature("ImplicitOpenExistentials"),
        SwiftSetting.enableUpcomingFeature("StrictConcurrency"),
        SwiftSetting.enableUpcomingFeature("DisableOutwardActorInference"),
        SwiftSetting.enableExperimentalFeature("StrictConcurrency"),
        SwiftSetting.unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
      ]
    ),
    .testTarget(
      name: "RadiantKitTests",
      dependencies: ["RadiantKit"]
    )
  ]
)
