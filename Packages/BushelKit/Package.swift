// swift-tools-version: 5.9
//
// Array+Depedencies.swift
// Copyright (c) 2023 BrightDigit.
//

extension Array: Dependencies where Element == Dependency {
  func appending(_ dependencies: any Dependencies) -> [Dependency] {
    self + dependencies
  }
}
//
// Array+SupportedPlatforms.swift
// Copyright (c) 2023 BrightDigit.
//

extension Array: SupportedPlatforms where Element == SupportedPlatform {
  func appending(_ platforms: any SupportedPlatforms) -> Self {
    self + .init(platforms)
  }
}
//
// Array+TestTargets.swift
// Copyright (c) 2023 BrightDigit.
//

extension Array: TestTargets where Element == TestTarget {
  func appending(_ testTargets: any TestTargets) -> [TestTarget] {
    self + testTargets
  }
}
//
// Dependencies.swift
// Copyright (c) 2023 BrightDigit.
//

protocol Dependencies: Sequence where Element == Dependency {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == Dependency, S: Sequence
  func appending(_ dependencies: any Dependencies) -> Self
}
//
// Dependency.swift
// Copyright (c) 2023 BrightDigit.
//

protocol Dependency {
  var targetDepenency: _PackageDescription_TargetDependency { get }
}
//
// DependencyBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

@resultBuilder
enum DependencyBuilder {
  static func buildPartialBlock(first: Dependency) -> any Dependencies {
    [first]
  }

  static func buildPartialBlock(accumulated: any Dependencies, next: Dependency) -> any Dependencies {
    accumulated + [next]
  }
}
//
// LanguageTag.swift
// Copyright (c) 2023 BrightDigit.
//

extension LanguageTag {
  static let english: LanguageTag = "en"
}
//
// Package+Extensions.swift
// Copyright (c) 2023 BrightDigit.
//

extension Package {
  convenience init(
    name: String? = nil,
    @ProductsBuilder entries: @escaping () -> [Product],
    @TestTargetBuilder testTargets: @escaping () -> any TestTargets = { [TestTarget]() }
  ) {
    let packageName: String
    if let name {
      packageName = name
    } else {
      var pathComponents = #filePath.split(separator: "/")
      pathComponents.removeLast()
      // swiftlint:disable:next force_unwrapping
      packageName = String(pathComponents.last!)
    }
    let allTestTargets = testTargets()
    let entries = entries()
    let products = entries.map(_PackageDescription_Product.entry)
    var targets = entries.flatMap(\.productTargets)
    let allTargetsDependencies = targets.flatMap { $0.allDependencies() }
    let allTestTargetsDependencies = allTestTargets.flatMap { $0.allDependencies() }
    let dependencies = allTargetsDependencies + allTestTargetsDependencies
    let targetDependencies = dependencies.compactMap { $0 as? Target }
    let packageDependencies = dependencies.compactMap { $0 as? PackageDependency }
    targets += targetDependencies
    targets += allTestTargets.map { $0 as Target }
    assert(targetDependencies.count + packageDependencies.count == dependencies.count)

    let packgeTargets = Dictionary(
      grouping: targets,
      by: { $0.name }
    ).values.compactMap(\.first).map(_PackageDescription_Target.entry(_:))

    let packageDeps = Dictionary(
      grouping: packageDependencies,
      by: { $0.productName }
    ).values.compactMap(\.first).map(\.dependency)

    self.init(name: packageName, products: products, dependencies: packageDeps, targets: packgeTargets)
  }
}

extension Package {
  func supportedPlatforms(
    @SupportedPlatformBuilder supportedPlatforms: @escaping () -> any SupportedPlatforms
  ) -> Package {
    self.platforms = .init(supportedPlatforms())
    return self
  }

  func defaultLocalization(_ defaultLocalization: LanguageTag) -> Package {
    self.defaultLocalization = defaultLocalization
    return self
  }
}
//
// PackageDependency.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

protocol PackageDependency: Dependency {
  var dependency: _PackageDescription_PackageDependency { get }
}

extension PackageDependency {
  var productName: String {
    "\(Self.self)"
  }

  var targetDepenency: _PackageDescription_TargetDependency {
    switch self.dependency.kind {
    case let .sourceControl(name: name, location: location, requirement: _):
      let packageName = name ?? location.packageName
      return .product(name: productName, package: packageName)

    @unknown default:
      return .byName(name: productName)
    }
  }
}
//
// PackageDescription.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable type_name

import PackageDescription

typealias _PackageDescription_Product = PackageDescription.Product
typealias _PackageDescription_Target = PackageDescription.Target
typealias _PackageDescription_TargetDependency = PackageDescription.Target.Dependency
typealias _PackageDescription_PackageDependency = PackageDescription.Package.Dependency
//
// PlatformSet.swift
// Copyright (c) 2023 BrightDigit.
//

protocol PlatformSet {
  @SupportedPlatformBuilder
  var body: any SupportedPlatforms { get }
}
//
// Product+Target.swift
// Copyright (c) 2023 BrightDigit.
//

extension Product where Self: Target {
  var productTargets: [Target] {
    [self]
  }

  var targetType: TargetType {
    switch self.productType {
    case .library:
      .regular

    case .executable:
      .executable
    }
  }
}
//
// Product.swift
// Copyright (c) 2023 BrightDigit.
//

protocol Product: _Named {
  var productTargets: [Target] { get }
  var productType: ProductType { get }
}

extension Product {
  var productType: ProductType {
    .library
  }
}
//
// ProductType.swift
// Copyright (c) 2023 BrightDigit.
//

enum ProductType {
  case library
  case executable
}
//
// ProductsBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

@resultBuilder
enum ProductsBuilder {
  static func buildPartialBlock(first: Product) -> [Product] {
    [first]
  }

  static func buildPartialBlock(accumulated: [Product], next: Product) -> [Product] {
    accumulated + [next]
  }
}
//
// String.swift
// Copyright (c) 2023 BrightDigit.
//

extension String {
  var packageName: String? {
    self.split(separator: "/").last?.split(separator: ".").first.map(String.init)
  }
}
//
// SupportedPlatformBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

@resultBuilder
enum SupportedPlatformBuilder {
  static func buildPartialBlock(first: SupportedPlatform) -> any SupportedPlatforms {
    [first]
  }

  static func buildPartialBlock(first: PlatformSet) -> any SupportedPlatforms {
    first.body
  }

  static func buildPartialBlock(first: any SupportedPlatforms) -> any SupportedPlatforms {
    first
  }

  static func buildPartialBlock(
    accumulated: any SupportedPlatforms,
    next: any SupportedPlatforms
  ) -> any SupportedPlatforms {
    accumulated.appending(next)
  }

  static func buildPartialBlock(
    accumulated: any SupportedPlatforms,
    next: SupportedPlatform
  ) -> any SupportedPlatforms {
    accumulated.appending([next])
  }
}
//
// SupportedPlatforms.swift
// Copyright (c) 2023 BrightDigit.
//

protocol SupportedPlatforms: Sequence where Element == SupportedPlatform {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == SupportedPlatform, S: Sequence
  func appending(_ platforms: any SupportedPlatforms) -> Self
}
//
// Target.swift
// Copyright (c) 2023 BrightDigit.
//

protocol Target: _Depending, Dependency, _Named {
  var targetType: TargetType { get }
}

extension Target {
  var targetType: TargetType {
    .regular
  }

  var targetDepenency: _PackageDescription_TargetDependency {
    .target(name: self.name)
  }
}
//
// TargetType.swift
// Copyright (c) 2023 BrightDigit.
//

enum TargetType {
  case regular
  case executable
  case test
}
//
// TestTarget.swift
// Copyright (c) 2023 BrightDigit.
//

protocol TestTarget: Target {}

extension TestTarget {
  var targetType: TargetType {
    .test
  }
}
//
// TestTargetBuilder.swift
// Copyright (c) 2023 BrightDigit.
//

@resultBuilder
enum TestTargetBuilder {
  static func buildPartialBlock(first: TestTarget) -> any TestTargets {
    [first]
  }

  static func buildPartialBlock(accumulated: any TestTargets, next: TestTarget) -> any TestTargets {
    accumulated + [next]
  }
}
//
// TestTargets.swift
// Copyright (c) 2023 BrightDigit.
//

protocol TestTargets: Sequence where Element == TestTarget {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == TestTarget, S: Sequence
  func appending(_ testTargets: any TestTargets) -> Self
}
//
// _Depending.swift
// Copyright (c) 2023 BrightDigit.
//

protocol _Depending {
  @DependencyBuilder
  var dependencies: any Dependencies { get }
}

extension _Depending {
  var dependencies: any Dependencies {
    [Dependency]()
  }
}

extension _Depending {
  func allDependencies() -> [Dependency] {
    self.dependencies.compactMap {
      $0 as? _Depending
    }
    .flatMap {
      $0.allDependencies()
    }
    .appending(self.dependencies)
  }
}
//
// _Named.swift
// Copyright (c) 2023 BrightDigit.
//

protocol _Named {
  var name: String { get }
}

extension _Named {
  var name: String {
    "\(Self.self)"
  }
}
//
// _PackageDescription_Product.swift
// Copyright (c) 2023 BrightDigit.
//

extension _PackageDescription_Product {
  static func entry(_ entry: Product) -> _PackageDescription_Product {
    let targets = entry.productTargets.map(\.name)

    switch entry.productType {
    case .executable:
      return Self.executable(name: entry.name, targets: targets)

    case .library:
      return Self.library(name: entry.name, targets: targets)
    }
  }
}
//
// _PackageDescription_Target.swift
// Copyright (c) 2023 BrightDigit.
//

extension _PackageDescription_Target {
  static func entry(_ entry: Target) -> _PackageDescription_Target {
    let dependencies = entry.dependencies.map(\.targetDepenency)
    switch entry.targetType {
    case .executable:
      return .executableTarget(name: entry.name, dependencies: dependencies)

    case .regular:
      return .target(name: entry.name, dependencies: dependencies)

    case .test:
      return .testTarget(name: entry.name, dependencies: dependencies)
    }
  }
}
//
// ArgumentParser.swift
// Copyright (c) 2023 BrightDigit.
//

struct ArgumentParser: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
  }
}
//
// FelinePine.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

struct FelinePine: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/FelinePine.git", from: "0.1.0-alpha.4")
  }
}
//
// WWDC2023.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

struct WWDC2023: PlatformSet {
  var body: any SupportedPlatforms {
    SupportedPlatform.macOS(.v14)
    SupportedPlatform.iOS(.v17)
    SupportedPlatform.watchOS(.v10)
    SupportedPlatform.tvOS(.v17)
  }
}
//
// BushelApp.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelApp: Product, Target {
  var dependencies: any Dependencies {
    BushelViews()
    BushelVirtualization()
    BushelMachine()
    BushelLibrary()
    BushelSystem()
    BushelData()
    BushelHub()
    BushelFactory()
    BushelMarket()
    BushelWax()
  }
}
//
// BushelCommand.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelCommand: Target, Product {
  var name: String {
    "bushel"
  }

  var dependencies: any Dependencies {
    BushelArgs()
  }

  var productType: ProductType {
    .executable
  }
}
//
// BushelLibraryApp.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryApp: Product, Target {
  var dependencies: any Dependencies {
    BushelLibraryViews()
    BushelLibraryMacOS()
  }
}
//
// BushelMachineApp.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineApp: Target, Product {
  var dependencies: any Dependencies {
    BushelMachineViews()
    BushelMachineMacOS()
  }
}
//
// BushelSettingsApp.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelSettingsApp: Product, Target {
  var dependencies: any Dependencies {
    BushelSettingsViews()
  }
}
//
// BushelArgs.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelArgs: Target {
  var dependencies: any Dependencies {
    ArgumentParser()
    BushelCore()
  }
}
//
// BushelCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelCore: Target {}
//
// BushelCoreWax.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelCoreWax: Target {
  var dependencies: any Dependencies {
    BushelCore()
  }
}
//
// BushelData.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelData: Target {
  var dependencies: any Dependencies {
    BushelLibraryData()
    BushelMachineData()
  }
}
//
// BushelDataCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelDataCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
//
// BushelFactory.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelFactory: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelMachine()
    BushelLibrary()
    BushelLogging()
    BushelData()
  }
}
//
// BushelHub.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelHub: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelViewsCore()
  }
}
//
// BushelHubEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelHubEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelHub()
    BushelLocalization()
  }
}
//
// BushelHubMacOS.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelHubMacOS: Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelMacOSCore()
  }
}
//
// BushelHubViews.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelHubViews: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelHub()
    BushelLocalization()
    BushelHubEnvironment()
    BushelLibraryEnvironment()
  }
}
//
// BushelLibrary.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibrary: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
  }
}
//
// BushelLibraryData.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryData: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelLogging()
    BushelDataCore()
  }
}
//
// BushelLibraryEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelLibraryEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelLibrary()
    BushelLocalization()
  }
}
//
// BushelLibraryMacOS.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryMacOS: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelMacOSCore()
  }
}
//
// BushelLibraryViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryViews: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelLibraryData()
    BushelLibraryEnvironment()
    BushelLogging()
    BushelUT()
    BushelViewsCore()
    BushelProgressUI()
  }
}
//
// BushelLibraryWax.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryWax: Target {
  var dependencies: any Dependencies {
    BushelLibrary()
  }
}
//
// BushelLocalization.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLocalization: Target {}
//
// BushelLogging.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLogging: Target {
  var dependencies: any Dependencies {
    FelinePine()
  }
}
//
// BushelMacOSCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMacOSCore: Target {
  var dependencies: any Dependencies {
    BushelCore()
  }
}
//
// BushelMachine.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachine: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
  }
}
//
// BushelMachineData.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineData: Target {
  var dependencies: any Dependencies {
    BushelDataCore()
    BushelMachine()
    BushelLogging()
  }
}
//
// BushelMachineEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelMachineEnvironment: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelCore()
    BushelMachine()
    BushelLocalization()
  }
}
//
// BushelMachineMacOS.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineMacOS: Target {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelMacOSCore()
    BushelSessionUI()
  }
}
//
// BushelMachineViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineViews: Target {
  var dependencies: any Dependencies {
    BushelMachineData()
    BushelLogging()
    BushelUT()
    BushelLocalization()
    BushelViewsCore()
    BushelSessionUI()
    BushelMachineEnvironment()
  }
}
//
// BushelMachineWax.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelMachineWax: Target {
  var dependencies: any Dependencies {
    BushelCoreWax()
    BushelMachine()
  }
}
//
// BushelMarket.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelMarket: Target {
  var dependencies: any Dependencies {
    BushelViewsCore()
  }
}
//
// BushelMarketEnvironment.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
  }
}
//
// BushelMarketStore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketStore: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
  }
}
//
// BushelMarketViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMarketViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelMarket()
    BushelMarketStore()
    BushelMarketEnvironment()
    BushelViewsCore()
  }
}
//
// BushelProgressUI.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelProgressUI: Target {}
//
// BushelSessionUI.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
struct BushelSessionUI: Target {}
//
// BushelSettingsViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelSettingsViews: Target {
  var dependencies: any Dependencies {
    BushelData()
    BushelLocalization()
    BushelMarketEnvironment()
  }
}
//
// BushelSystem.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelSystem: Target {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelLibrary()
    BushelHub()
    BushelHubEnvironment()
    BushelLibraryEnvironment()
    BushelMachineEnvironment()
  }
}
//
// BushelTestUtlities.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelTestUtlities: Target {}
//
// BushelUT.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelUT: Target {
  var dependencies: any Dependencies {
    BushelCore()
  }
}
//
// BushelViews.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelViews: Target {
  var dependencies: any Dependencies {
    BushelLibraryViews()
    BushelMachineViews()
    BushelSettingsViews()
    BushelWelcomeViews()
    BushelHubViews()
    BushelMarketViews()
  }
}
//
// BushelViewsCore.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelViewsCore: Target {
  var dependencies: any Dependencies {
    BushelLogging()
    BushelUT()
  }
}
//
// BushelVirtualization.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelVirtualization: Target {
  var dependencies: any Dependencies {
    BushelLibraryMacOS()
    BushelMachineMacOS()
    BushelHubMacOS()
    BushelSystem()
  }
}
//
// BushelWax.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelWax: Target {
  var dependencies: any Dependencies {
    BushelHub()
    BushelSystem()
    BushelMacOSCore()
  }
}
//
// BushelWelcomeViews.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

struct BushelWelcomeViews: Target {
  var dependencies: any Dependencies {
    BushelData()
    BushelLocalization()
  }
}
//
// BushelCoreTests.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelCoreTests: TestTarget {
  var dependencies: any Dependencies {
    BushelCore()
    BushelCoreWax()
    BushelTestUtlities()
  }
}
//
// BushelLibraryTests.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelLibraryTests: TestTarget {
  var dependencies: any Dependencies {
    BushelLibrary()
    BushelCoreWax()
    BushelLibraryWax()
    BushelTestUtlities()
  }
}
//
// BushelMachineTests.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelMachineTests: TestTarget {
  var dependencies: any Dependencies {
    BushelMachine()
    BushelMachineWax()
    BushelTestUtlities()
  }
}
//
// Index.swift
// Copyright (c) 2023 BrightDigit.
//

import PackageDescription

let package = Package {
  BushelCommand()
  BushelLibraryApp()
  BushelMachineApp()
  BushelSettingsApp()
  BushelApp()
}
testTargets: {
  BushelCoreTests()
  BushelLibraryTests()
  BushelMachineTests()
}
.supportedPlatforms {
  WWDC2023()
}
.defaultLocalization(.english)
