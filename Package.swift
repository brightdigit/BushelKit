// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BushelKit",
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "BushelKit",
      targets: ["BushelKit"]
    )
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/shibapm/Komondor", from: "1.0.6"), // dev
    .package(url: "https://github.com/eneko/SourceDocs", from: "1.2.1"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.41.0"), // dev
    .package(url: "https://github.com/brightdigit/Rocket", .branch("feature/yams-4.0.0")), // dev
    .package(url: "https://github.com/mattpolzin/swift-test-codecov", .branch("master")) // dev
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "BushelKit",
      dependencies: []
    ),
    .testTarget(
      name: "BushelKitTests",
      dependencies: ["BushelKit"]
    )
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let requiredCoverage: Int = 0

  let config = PackageConfiguration([
    "komondor": [
      "pre-push": [
        "swift test --enable-code-coverage --enable-test-discovery",
        "swift run swift-test-codecov .build/debug/codecov/BushelKit.json -v \(requiredCoverage)"
      ],
      "pre-commit": [
        "swift test --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate build -cra",
        "git add .",
        "swift run swiftformat --lint .",
        "swift run swiftlint"
      ]
    ]
  ]).write()
#endif
