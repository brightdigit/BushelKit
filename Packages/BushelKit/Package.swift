// swift-tools-version: 5.6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BshillKit",
  platforms: [.macOS(.v12)],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "BushelUI",
      targets: ["BushelUI"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0")
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
      name: "BushelMachine",
      dependencies: [.product(name: "Crypto", package: "swift-crypto")]
    ),
    .testTarget(
      name: "BushelKitTests",
      dependencies: ["BushelUI"]
    )
  ]
)
