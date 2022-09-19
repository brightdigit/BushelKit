// swift-tools-version: 5.6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BshillKit",
  defaultLocalization: "en",
  platforms: [.macOS(.v12)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "BushelUI",
      targets: ["BushelUI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/brightdigit/StringsLint.git", from: "0.1.5"), // dev
    // .package(url: "https://github.com/shibapm/Komondor", from: "1.1.2"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.41.0") // dev
    // .package(url: "https://github.com/shibapm/Rocket", from: "1.2.0") // dev
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "BushelUI",
      dependencies: ["BushelMachine", "BushelMachineMacOS"]
    ),
    .target(
      name: "BushelMachineMacOS",
      dependencies: ["BushelMachine"]
    ),
    .target(
      name: "BushelMachine"
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
