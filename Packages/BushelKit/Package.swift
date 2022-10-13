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
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Faire/StringsLint.git", from: "0.1.7"), // dev
    // .package(url: "https://github.com/shibapm/Komondor", from: "1.1.2"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.41.0"), // dev
    // .package(url: "https://github.com/shibapm/Rocket", from: "1.2.0") // dev
    .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
  ],
  targets: [
    .target(
      name: "BushelUI",
      dependencies: ["BushelMachine", "BushelMachineMacOS", "HarvesterKit"]
    ),
    .target(
      name: "BushelMachineMacOS",
      dependencies: ["BushelMachine"]
    ),
    .target(
      name: "BushelMachine",
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
      name: "BushelUITests",
      dependencies: ["BushelUI"]
    ),
    .testTarget(
      name: "BushelMachineMacOSTests",
      dependencies: ["BushelMachineMacOS"]
    ),
    .testTarget(
      name: "BushelMachineTests",
      dependencies: ["BushelMachine"]
    )
  ]
)
