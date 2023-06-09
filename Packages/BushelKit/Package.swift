// swift-tools-version: 5.6.0

import PackageDescription

let package = Package(
  name: "BshillKit",
  defaultLocalization: "en",
  platforms: [.macOS(.v12)],
  products: [
    .library(
      name: "BushelUI",
      targets: ["BushelUI"]
    ),

    .library(
      name: "BushelVirtualization",
      targets: ["BushelVirtualization"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
    .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "BushelUI",
      dependencies: ["BushelMachine", "BushelMachineMacOS", "BushelWax", "BushelReactive"]
    ),
    .target(
      name: "BushelReactive",
      dependencies: ["BushelMachine", "BushelMachineMacOS", "HarvesterKit", "BushelWax", "CombineExt"]
    ),
    .target(
      name: "BushelWax",
      dependencies: ["BushelVirtualization"]
    ),
    .target(
      name: "BushelVirtualization",
      dependencies: ["FelinePine"]
    ),
    .target(
      name: "BushelMachineMacOS",
      dependencies: ["BushelMachine"]
    ),
    .target(
      name: "BushelMachine",
      dependencies: ["BushelVirtualization"]
    ),
    .target(
      name: "FelinePine",
      dependencies: [
        .product(name: "Logging", package: "swift-log", condition: .when(platforms: [.linux]))
      ]
    ),
    .target(
      name: "HarvesterKit",
      dependencies: [
      ]
    ),
    .testTarget(
      name: "BushelVirtualizationTests",
      dependencies: ["BushelVirtualization", "BushelWax"]
    )
  ]
)
