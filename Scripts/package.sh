#!/bin/sh

# Default values
swift_tools_version="6.0"
MINIMIZE=false

# Parse flags
while [ "$#" -gt 0 ]; do
  case "$1" in
    --version)
      swift_tools_version="$2"
      shift 2
      ;;
    --minimize)
      MINIMIZE=true
      shift 1
      ;;
    *)
      PACKAGE_DIR="$1"
      shift 1
      ;;
  esac
done

echo "⚙️  Generating package..."

input_file=.package.source
output_file=Package.swift

cd $PACKAGE_DIR

# Hardcoded PackageDSL content
cat << 'PACKAGEDSL' > $input_file
extension _PackageDescription_Product {
static func entry(_ entry: any Product) -> _PackageDescription_Product {
let targets = entry.productTargets.map(\.name)
switch entry.productType {
case .executable:
return Self.executable(name: entry.name, targets: targets)
case .library:
return Self.library(name: entry.name, type: entry.libraryType, targets: targets)
}
}
}
@resultBuilder
public enum SwiftSettingsBuilder {
public static func buildPartialBlock(first: SwiftSetting) -> [SwiftSetting] {
[first]
}
public static func buildPartialBlock(
accumulated: [SwiftSetting],
next: SwiftSetting
) -> [SwiftSetting] {
accumulated + [next]
}
public static func buildPartialBlock(
accumulated: [SwiftSetting],
next: [SwiftSetting]
) -> [SwiftSetting] {
accumulated + next
}
public static func buildPartialBlock(first: [SwiftSetting]) -> [SwiftSetting] {
first
}
public static func buildPartialBlock(
first: any SwiftSettingsConvertible
) -> [SwiftSetting] {
first.swiftSettings()
}
public static func buildPartialBlock(
accumulated: [SwiftSetting],
next: any SwiftSettingsConvertible
) -> [SwiftSetting] {
accumulated + next.swiftSettings()
}
}
extension _PackageDescription_Target {
internal static func entry(
_ entry: Target,
swiftSettings: [SwiftSetting] = []
) -> _PackageDescription_Target {
let dependencies = entry.dependencies.map(\.targetDependency)
switch entry.targetType {
case .executable:
return .executableTarget(
name: entry.name,
dependencies: dependencies,
path: entry.path,
resources: entry.resources,
swiftSettings: swiftSettings + entry.swiftSettings
)
case .regular:
return .target(
name: entry.name,
dependencies: dependencies,
path: entry.path,
resources: entry.resources,
swiftSettings: swiftSettings + entry.swiftSettings
)
case .test:
return .testTarget(
name: entry.name,
dependencies: dependencies,
path: entry.path,
resources: entry.resources,
swiftSettings: swiftSettings + entry.swiftSettings
)
}
}
}
public enum ProductType {
case library
case executable
}
public protocol UnsafeFlag: SwiftSettingConvertible, _Named {
var unsafeFlagArguments: [String] { get }
}
extension UnsafeFlag {
public var unsafeFlagArguments: [String] {
[name.camelToSnakeCaseFlag()]
}
public var setting: SwiftSetting {
.unsafeFlags(unsafeFlagArguments)
}
}
extension Product where Self: Target {
var productTargets: [Target] {
[self]
}
var targetType: TargetType {
switch productType {
case .library:
return .regular
case .executable:
return .executable
}
}
}
extension Package {
static var defaultName: String {
var pathComponents = #filePath.split(separator: "/")
pathComponents.removeLast()
return String(pathComponents.last!)
}
public convenience init(
name: String? = nil,
@ProductsBuilder entries: @escaping () -> [any Product],
@PackageDependencyBuilder dependencies packageDependencies: @escaping () ->
[any PackageDependency] = { [any PackageDependency]() },
@TestTargetBuilder testTargets:
@escaping () -> any TestTargets = { [any TestTarget]() },
@SwiftSettingsBuilder swiftSettings:
@escaping () -> [SwiftSetting] = { [SwiftSetting]() }
) {
let packageName = name ?? Self.defaultName
let allTestTargets = testTargets()
let entries = entries()
let products = entries.map(_PackageDescription_Product.entry)
let targets = entries.flatMap(\.productTargets)
let swiftSettings = swiftSettings()
let packageDeps = Self.dependencies(
packageDependencies(),
targets,
.init(allTestTargets),
swiftSettings: swiftSettings
)
let packgeTargets = Self.targets(
targets,
.init(allTestTargets),
swiftSettings: swiftSettings
)
self.init(
name: packageName,
products: products,
dependencies: packageDeps,
targets: packgeTargets
)
}
static func dependencies(
_ packageDependencies: [any PackageDependency],
_ targetSets: [_Depending & _Named]...,
swiftSettings: [SwiftSetting] = []
) -> [Package.Dependency] {
let dependencies = targetSets.flatMap {
$0.flatMap {
$0.allDependencies()
}
}
let packageTargetDependencies = dependencies.compactMap { $0 as? TargetDependency }
let allPackageDependencies =
packageTargetDependencies.map(\.package) + packageDependencies
let packageDeps = Dictionary(
grouping: allPackageDependencies
) { $0.packageName }
.values.compactMap(\.first).map(\.dependency)
return packageDeps
}
static func targets(
_ targetSets: [any Target]...,
swiftSettings: [SwiftSetting] = []
) -> [_PackageDescription_Target] {
let targets = targetSets.flatMap {
$0.flatMap {
[$0] + $0.allDependencies().compactMap { $0 as? Target }
}
}
return Dictionary(
grouping: targets
) { $0.name }
.values
.compactMap(\.first)
.map { _PackageDescription_Target.entry($0, swiftSettings: swiftSettings) }
}
}
extension Package {
public func supportedPlatforms(
@SupportedPlatformBuilder supportedPlatforms: @escaping () -> any SupportedPlatforms
) -> Package {
platforms = .init(supportedPlatforms())
return self
}
public func defaultLocalization(_ defaultLocalization: LanguageTag) -> Package {
self.defaultLocalization = defaultLocalization
return self
}
}
@resultBuilder
public enum PackageDependencyBuilder {
public static func buildPartialBlock(
first: PackageDependency
) -> [any PackageDependency] {
[first]
}
public static func buildPartialBlock(
accumulated: [any PackageDependency],
next: PackageDependency
) -> [any PackageDependency] {
accumulated + [next]
}
}
public protocol PackageDependency: _Named {
var packageName: String { get }
var dependency: _PackageDescription_PackageDependency { get }
}
extension PackageDependency where Self: TargetDependency {
var package: any PackageDependency {
self
}
var targetDependency: _PackageDescription_TargetDependency {
switch dependency.kind {
case .sourceControl(let name, let location, requirement: _):
let packageName = name ?? location.packageName ?? self.packageName
return .product(
name: productName,
package: packageName,
condition: self.condition
)
case .fileSystem(let name, let path):
if let packageName = name ?? path.components(separatedBy: "/").last {
return .product(
name: productName,
package: packageName,
condition: self.condition
)
} else {
return .byName(name: productName)
}
case .registry: return .byName(name: productName)
@unknown default: return .byName(name: productName)
}
}
}
extension PackageDependency {
var packageName: String {
switch dependency.kind {
case .sourceControl(let name, let location, requirement: _):
return name ?? location.packageName ?? self.name
case .fileSystem(let name, let path):
return name ?? path.packageName ?? self.name
case .registry(let id, requirement: _):
return id
@unknown default:
return name
}
}
}
public enum TargetType {
case regular
case executable
case test
}
public protocol _Depending {
@DependencyBuilder var dependencies: any Dependencies { get }
}
extension _Depending {
public var dependencies: any Dependencies {
[Dependency]()
}
}
extension _Depending {
public func allDependencies() -> [Dependency] {
dependencies.compactMap {
$0 as? _Depending
}
.flatMap {
$0.allDependencies()
}
.appending(dependencies)
}
}
public protocol TestTarget: Target, GroupBuildable {}
extension TestTarget {
public var targetType: TargetType {
.test
}
}
@resultBuilder
public enum DependencyBuilder {
public static func buildPartialBlock(first: Dependency) -> any Dependencies {
[first]
}
public static func buildPartialBlock(
accumulated: any Dependencies,
next: Dependency
) -> any Dependencies {
accumulated + [next]
}
}
extension LanguageTag {
nonisolated(unsafe) static let english: LanguageTag = "en"
}
public protocol FrontendFlag: UnsafeFlag, _Named {
var flagArguments: [String] { get }
}
extension FrontendFlag {
public var flagArguments: [String] {
[name.camelToSnakeCaseFlag()]
}
public var unsafeFlagArguments: [String] {
["-Xfrontend", flagArguments.joined(separator: "=")]
}
}
public protocol Target: _Depending, Dependency, _Named {
var targetType: TargetType { get }
@SwiftSettingsBuilder var swiftSettings: [SwiftSetting] { get }
@ResourcesBuilder var resources: [Resource] { get }
var path: String? { get }
}
extension Target {
public var targetType: TargetType {
.regular
}
public var targetDependency: _PackageDescription_TargetDependency {
.target(name: name)
}
public var swiftSettings: [SwiftSetting] {
[]
}
public var resources: [Resource] {
[]
}
public var path: String? {
nil
}
}
public protocol Dependencies: Sequence where Element == Dependency {
init<S>(_ sequence: S) where S.Element == Dependency, S: Sequence
func appending(_ dependencies: any Dependencies) -> Self
}
public protocol SwiftSettingConvertible: SwiftSettingsConvertible {
var setting: SwiftSetting { get }
}
extension SwiftSettingConvertible {
public func swiftSettings() -> [SwiftSetting] {
[setting]
}
}
@resultBuilder
public enum ProductsBuilder {
public static func buildPartialBlock(first: [any Product]) -> [any Product] {
first
}
public static func buildPartialBlock(first: any Product) -> [any Product] {
[first]
}
public static func buildPartialBlock(
accumulated: [any Product],
next: any Product
) -> [any Product] {
accumulated + [next]
}
public static func buildPartialBlock(
accumulated: [any Product],
next: [any Product]
) -> [any Product] {
accumulated + next
}
}
@resultBuilder
public enum SupportedPlatformBuilder {
public static func buildPartialBlock(
first: SupportedPlatform
) -> any SupportedPlatforms {
[first]
}
public static func buildPartialBlock(first: PlatformSet) -> any SupportedPlatforms {
first.body
}
public static func buildPartialBlock(
first: any SupportedPlatforms
) -> any SupportedPlatforms {
first
}
public static func buildPartialBlock(
accumulated: any SupportedPlatforms,
next: any SupportedPlatforms
) -> any SupportedPlatforms {
accumulated.appending(next)
}
public static func buildPartialBlock(
accumulated: any SupportedPlatforms,
next: SupportedPlatform
) -> any SupportedPlatforms {
accumulated.appending([next])
}
}
extension Array: Dependencies where Element == Dependency {
public func appending(_ dependencies: any Dependencies) -> [Dependency] {
self + dependencies
}
}
@resultBuilder
public enum ResourcesBuilder {
public static func buildPartialBlock(first: Resource) -> [Resource] {
[first]
}
public static func buildPartialBlock(
accumulated: [Resource],
next: Resource
) -> [Resource] {
accumulated + [next]
}
}
public protocol GroupBuildable {
associatedtype Output = Self
static func output(from array: [Self]) -> [Self.Output]
}
extension GroupBuildable where Output == Self {
public static func output(from array: [Self]) -> [Self.Output] {
array
}
}
public enum FeatureState {
case upcoming
case experimental
}
extension FeatureState {
public func swiftSetting(name: String) -> SwiftSetting {
switch self {
case .experimental: .enableExperimentalFeature(name)
case .upcoming: .enableUpcomingFeature(name)
}
}
}
public protocol PlatformSet {
@SupportedPlatformBuilder var body: any SupportedPlatforms { get }
}
public typealias _PackageDescription_Product = PackageDescription.Product
public typealias _PackageDescription_Target = PackageDescription.Target
public typealias _PackageDescription_TargetDependency =
PackageDescription.Target.Dependency
public typealias _PackageDescription_PackageDependency =
PackageDescription.Package.Dependency
public typealias LibraryType = PackageDescription.Product.Library.LibraryType
public struct SolverShrinkUnsolvedThreshold: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Ounchecked: UnsafeFlag {}
public struct DigesterMode: UnsafeFlag {
public let api: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(api)"]
}
public init(_ api: String) {
self.api = api
}
}
public struct ParseableOutput: UnsafeFlag {}
public struct EmitObjcHeader: UnsafeFlag {}
public struct EnableLibraryEvolution: UnsafeFlag {}
public struct ExperimentalPackageInterfaceLoad: UnsafeFlag {}
public struct SignClassRo: UnsafeFlag {}
public struct EnableBridgingPch: UnsafeFlag {}
public struct EnforceExclusivity: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableIncrementalImports: UnsafeFlag {}
public struct Incremental: UnsafeFlag {}
public struct ModuleName: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SwiftPtrauthMode: UnsafeFlag {
public let mode: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(mode)"]
}
public init(_ mode: String) {
self.mode = mode
}
}
public struct NoStdlibRpath: UnsafeFlag {}
public struct ApplicationExtensionLibrary: UnsafeFlag {}
public struct WarnImplicitOverrides: UnsafeFlag {}
public struct ResourceDir: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DefineAvailability: UnsafeFlag {
public let macro: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(macro)"]
}
public init(_ macro: String) {
self.macro = macro
}
}
public struct ToolsDirectory: UnsafeFlag {
public let directory: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(directory)"]
}
public init(_ directory: String) {
self.directory = directory
}
}
public struct ParseSil: UnsafeFlag {}
public struct CxxInteroperabilityMode: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ValidateClangModulesOnce: UnsafeFlag {}
public struct Sanitize: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitModuleSummary: UnsafeFlag {}
public struct PrintAstDecl: UnsafeFlag {}
public struct TrackSystemDependencies: UnsafeFlag {}
public struct DisableAutolinkingRuntimeCompatibility: UnsafeFlag {}
public struct ClangScannerModuleCachePath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct IndexFilePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct I: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DumpTypeRefinementContexts: UnsafeFlag {}
public struct GlineTablesOnly: UnsafeFlag {}
public struct EmitSil: UnsafeFlag {}
public struct UserModuleVersion: UnsafeFlag {
public let vers: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(vers)"]
}
public init(_ vers: String) {
self.vers = vers
}
}
public struct IndexFile: UnsafeFlag {}
public struct EmitSilgen: UnsafeFlag {}
public struct RuntimeCompatibilityVersion: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitAssembly: UnsafeFlag {}
public struct DisableClangTarget: UnsafeFlag {}
public struct DwarfVersion: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct IndexStorePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitModuleInterfacePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableSandbox: UnsafeFlag {}
public struct ImportUnderlyingModule: UnsafeFlag {}
public struct Static: UnsafeFlag {}
public struct PrintPreprocessedExplicitDependencyGraph: UnsafeFlag {}
public struct DriverBatchCount: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitClangHeaderNonmodularIncludes: UnsafeFlag {}
public struct LtoLibrary: UnsafeFlag {
public let ltolibrary: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(ltolibrary)"]
}
public init(_ ltolibrary: String) {
self.ltolibrary = ltolibrary
}
}
public struct Xllvm: UnsafeFlag {
public let arg: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(arg)"]
}
public init(_ arg: String) {
self.arg = arg
}
}
public struct DriverShowJobLifecycle: UnsafeFlag {}
public struct SaveOptimizationRecord: UnsafeFlag {}
public struct RcacheCompileJob: UnsafeFlag {}
public struct Xlinker: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ExperimentalPackageBypassResilience: UnsafeFlag {}
public struct Fsystem: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableAutolinkingRuntimeCompatibilityConcurrency: UnsafeFlag {}
public struct RmoduleRecovery: UnsafeFlag {}
public struct EmitIr: UnsafeFlag {}
public struct V: UnsafeFlag {}
public struct DisableInferPublicSendable: FrontendFlag {}
public struct DisablePlaygroundTransform: FrontendFlag {}
public struct DisableAstVerifier: FrontendFlag {}
public struct IndexIgnoreStdlib: FrontendFlag {}
public struct ModuleLoadMode: FrontendFlag {}
public struct CasBackendMode: FrontendFlag {
public let casid: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(casid)"]
}
public init(_ casid: String) {
self.casid = casid
}
}
public struct EnableThrowWithoutTry: FrontendFlag {}
public struct WarnLongExpressionTypeChecking: FrontendFlag {
public let n: Int
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct PrebuiltModuleCachePath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct UseStaticResourceDir: FrontendFlag {}
public struct SolverDisableShrink: FrontendFlag {}
public struct EnableVerifyExclusivity: FrontendFlag {}
public struct Interpret: FrontendFlag {}
public struct EnableExperimentalAsyncTopLevel: FrontendFlag {}
public struct EnableSpecDevirt: FrontendFlag {}
public struct FrontendParseableOutput: FrontendFlag {}
public struct EnableImportPtrauthFieldFunctionPointers: FrontendFlag {}
public struct DebugCycles: FrontendFlag {}
public struct DisableSilPartialApply: FrontendFlag {}
public struct EnableDeserializationRecovery: FrontendFlag {}
public struct DisableLayoutStringValueWitnessesInstantiation: FrontendFlag {}
public struct SwiftModuleFile: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct BridgingHeaderDirectoryForPrint: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct SilVerifyNone: FrontendFlag {}
public struct LoadDependencyScanCache: FrontendFlag {}
public struct DumpApiPath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct BadFileDescriptorRetryCount: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct PlaceholderDependencyModuleMapFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableObjectiveCProtocolSymbolicReferences: FrontendFlag {}
public struct DisableSilOpaqueValues: FrontendFlag {}
public struct CasEmitCasidFile: FrontendFlag {}
public struct DisableSwiftSpecificLlvmOptzns: FrontendFlag {}
public struct EnableRequirementMachineOpaqueArchetypes: FrontendFlag {}
public struct ModuleCanImportVersion: FrontendFlag {
public let modulename: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(modulename)"]
}
public init(_ modulename: String) {
self.modulename = modulename
}
}
public struct DisableFragileRelativeProtocolTables: FrontendFlag {}
public struct EnableDeterministicCheck: FrontendFlag {}
public struct SilVerifyAll: FrontendFlag {}
public struct DisableRequirementMachineLoopNormalization: FrontendFlag {}
public struct DisableAutolinkLibrary: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DebugEmitInvalidSwiftinterfaceSyntax: FrontendFlag {}
public struct TargetVariantSdkVersion: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SerializedPathObfuscate: FrontendFlag {
public let prefix: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct DisableLlvmVerify: FrontendFlag {}
public struct DisableLlvmOptzns: FrontendFlag {}
public struct SkipImportInPublicInterface: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct RequirementMachineMaxRuleCount: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct AlwaysCompileOutputFiles: FrontendFlag {}
public struct StackPromotionLimit: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableLayoutStringValueWitnessesInstantiation: FrontendFlag {}
public struct BypassBatchModeChecks: FrontendFlag {}
public struct DisableLifetimeDependenceDiagnostics: FrontendFlag {}
public struct IgnoreModuleSourceInfo: FrontendFlag {}
public struct OutputFilelist: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct UseMalloc: FrontendFlag {}
public struct DisableArcOpts: FrontendFlag {}
public struct PcMacro: FrontendFlag {}
public struct VerifyIgnoreUnknown: FrontendFlag {}
public struct DisableNewOperatorLookup: FrontendFlag {}
public struct DisableDebuggerShadowCopies: FrontendFlag {}
public struct DisableNskeyedarchiverDiagnostics: FrontendFlag {}
public struct SuppressStaticExclusivitySwap: FrontendFlag {}
public struct VerifyApplyFixes: FrontendFlag {}
public struct PchDisableValidation: FrontendFlag {}
public struct DisableExperimentalLifetimeDependenceInference: FrontendFlag {}
public struct EmitPch: FrontendFlag {}
public struct DisablePreviousImplementationCallsInDynamicReplacements: FrontendFlag {}
public struct ExperimentalSkipAllFunctionBodies: FrontendFlag {}
public struct AnalyzeRequirementMachine: FrontendFlag {}
public struct EnableLlvmVfe: FrontendFlag {}
public struct SilDebugSerialization: FrontendFlag {}
public struct WarnLongFunctionBodies: FrontendFlag {
public let n: Int
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct PrintClangStats: FrontendFlag {}
public struct NoSerializeDebuggingOptions: FrontendFlag {}
public struct DisableSubstSilFunctionTypes: FrontendFlag {}
public struct Verify: FrontendFlag {}
public struct DebugInverseRequirements: FrontendFlag {}
public struct ExperimentalSpiImports: FrontendFlag {}
public struct DisableTypoCorrection: FrontendFlag {}
public struct EnableCrossImportOverlays: FrontendFlag {}
public struct EnableLayoutStringValueWitnesses: FrontendFlag {}
public struct DisableGenericMetadataPrespecialization: FrontendFlag {}
public struct EmitDependenciesPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableObjcAttrRequiresFoundationModule: FrontendFlag {}
public struct EnableExperimentalCxxInterop: FrontendFlag {}
public struct EnableSwift3ObjcInference: FrontendFlag {}
public struct DisableInterfaceLock: FrontendFlag {}
public struct BlocklistFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct PrimaryFile: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct StringLiteralsMustBeAsciiOnly: FrontendFlag {}
public struct TbdInstallName: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableExperimentalEagerClangModuleDiagnostics: FrontendFlag {}
public struct CxxInteropUseOpaquePointerForMoveonly: FrontendFlag {}
public struct CacheReplayPrefixMap: FrontendFlag {
public let prefix: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct CodeCompleteInitsInPostfixExpr: FrontendFlag {}
public struct DisablePreallocatedInstantiationCaches: FrontendFlag {}
public struct EnableExperimentalAsyncDemotion: FrontendFlag {}
public struct EnableAstVerifier: FrontendFlag {}
public struct ClangHeaderExposeModule: FrontendFlag {
public let importedmodulename: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(importedmodulename)"]
}
public init(_ importedmodulename: String) {
self.importedmodulename = importedmodulename
}
}
public struct CheckOnoneCompleteness: FrontendFlag {}
public struct EnableImplicitDynamic: FrontendFlag {}
public struct DebugAssertImmediately: FrontendFlag {}
public struct EnableExperimentalMoveOnly: FrontendFlag {}
public struct EnableExperimentalLifetimeDependenceInference: FrontendFlag {}
public struct DebugConstraintsOnLine: FrontendFlag {
public let line: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(line)"]
}
public init(_ line: String) {
self.line = line
}
}
public struct DisableImplicitBacktracingModuleImport: FrontendFlag {}
public struct TestableImportModule: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableIosInheritanceForPoundIfOsOnVisionos: FrontendFlag {}
public struct DisableImplicitSwiftModules: FrontendFlag {}
public struct ReportErrorsToDebugger: FrontendFlag {}
public struct NoClangModuleBreadcrumbs: FrontendFlag {}
public struct DisableSendingArgsAndResultsWithRegionBasedIsolation: FrontendFlag {}
public struct DisableColocateTypeDescriptors: FrontendFlag {}
public struct DisableInvalidEphemeralnessAsError: FrontendFlag {}
public struct EmitAbiDescriptorPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct CandidateModuleFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableLayoutStringValueWitnesses: FrontendFlag {}
public struct DisableAutolinkFramework: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ConstGatherProtocolsFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct SerializeDependencyScanCache: FrontendFlag {}
public struct DisableImplicitCxxModuleImport: FrontendFlag {}
public struct UseClangFunctionTypes: FrontendFlag {}
public struct PrintStats: FrontendFlag {}
public struct EntryPointFunctionName: FrontendFlag {
public let string: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(string)"]
}
public init(_ string: String) {
self.string = string
}
}
public struct Gsil: FrontendFlag {}
public struct DisableImportPtrauthFieldFunctionPointers: FrontendFlag {}
public struct DisableReflectionMetadata: FrontendFlag {}
public struct SilBasedDebuginfo: FrontendFlag {}
public struct PrintInstCounts: FrontendFlag {}
public struct PrimaryFilelist: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct PlaygroundHighPerformance: FrontendFlag {}
public struct EnableOssaModules: FrontendFlag {}
public struct RequirementMachineMaxSplitConcreteEquivClassAttempts: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableNskeyedarchiverDiagnostics: FrontendFlag {}
public struct EnableAccessControl: FrontendFlag {}
public struct EnableInvalidEphemeralnessAsError: FrontendFlag {}
public struct DebuggerSupport: FrontendFlag {}
public struct TbdCurrentVersion: FrontendFlag {
public let version: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(version)"]
}
public init(_ version: String) {
self.version = version
}
}
public struct DisableRequirementMachineReuse: FrontendFlag {}
public struct ExperimentalLazyTypecheck: FrontendFlag {}
public struct EmitStackPromotionChecks: FrontendFlag {}
public struct EnableDestroyHoisting: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct NoClangIncludeTree: FrontendFlag {}
public struct DisableOssaOpts: FrontendFlag {}
public struct EnableNonfrozenEnumExhaustivityDiagnostics: FrontendFlag {}
public struct DebugConstraintsAttempt: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ExperimentalPlatformCCallingConvention: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ExplicitInterfaceModuleBuild: FrontendFlag {}
public struct DisableAccessControl: FrontendFlag {}
public struct DowngradeTypecheckInterfaceError: FrontendFlag {}
public struct DebuggerTestingTransform: FrontendFlag {}
public struct MergeModules: FrontendFlag {}
public struct BatchScanInputFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct InputFileKey: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitMigratedFilePath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnablePackMetadataStackPromotion: FrontendFlag {}
public struct WarnOnEditorPlaceholder: FrontendFlag {}
public struct DisableLargeLoadableTypesReg2mem: FrontendFlag {}
public struct EnableTypeLayout: FrontendFlag {}
public struct DisableImplicitStringProcessingModuleImport: FrontendFlag {}
public struct EmitSortedSil: FrontendFlag {}
public struct ImportModule: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct BypassResilienceChecks: FrontendFlag {}
public struct DisableEmitGenericClassRoTList: FrontendFlag {}
public struct EnableResilience: FrontendFlag {}
public struct ClangIncludeTreeRoot: FrontendFlag {
public let casid: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(casid)"]
}
public init(_ casid: String) {
self.casid = casid
}
}
public struct EnableOssaCompleteLifetimes: FrontendFlag {}
public struct DisableRequirementMachineConcreteContraction: FrontendFlag {}
public struct VerifyGenericSignatures: FrontendFlag {
public let modulename: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(modulename)"]
}
public init(_ modulename: String) {
self.modulename = modulename
}
}
public struct EnableRoundTripDebugTypes: FrontendFlag {}
public struct EnableExperimentalStaticAssert: FrontendFlag {}
public struct DisablePrintPackageNameForNonPackageInterface: FrontendFlag {}
public struct EmitModuleDoc: FrontendFlag {}
public struct EnableCopyPropagation: FrontendFlag {}
public struct EmitModuleSourceInfo: FrontendFlag {}
public struct CompileModuleFromInterface: FrontendFlag {}
public struct EmitVerboseSil: FrontendFlag {}
public struct EnableAnonymousContextMangledNames: FrontendFlag {}
public struct ExperimentalSpiOnlyImports: FrontendFlag {}
public struct DumpInterfaceHash: FrontendFlag {}
public struct EnableLifetimeDependenceDiagnostics: FrontendFlag {}
public struct TrapFunction: FrontendFlag {
public let name: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(name)"]
}
public init(_ name: String) {
self.name = name
}
}
public struct DumpMacroExpansions: FrontendFlag {}
public struct EmitReferenceDependenciesPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitReferenceDependencies: FrontendFlag {}
public struct EnableImplicitBacktracingModuleImport: FrontendFlag {}
public struct BackupModuleInterfacePath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DebugCrashImmediately: FrontendFlag {}
public struct DumpTypeWitnessSystems: FrontendFlag {}
public struct ExplicitSwiftModuleMapFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableCxxInteropRequirementAtImport: FrontendFlag {}
public struct DebugRequirementMachine: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct RmoduleInterfaceRebuild: FrontendFlag {}
public struct EnableFragileRelativeProtocolTables: FrontendFlag {}
public struct PrespecializeGenericMetadata: FrontendFlag {}
public struct DisableReflectionNames: FrontendFlag {}
public struct TemporaryForceLlvmFullLto: FrontendFlag {}
public struct CxxInteropGettersSettersAsProperties: FrontendFlag {}
public struct ConcurrencyModel: FrontendFlag {}
public struct EnableExperimentalOpenedExistentialTypes: FrontendFlag {}
public struct EnableMoveInoutStackProtector: FrontendFlag {}
public struct RaccessNote: FrontendFlag {}
public struct SilInlineThreshold: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableExperimentalClangImporterDiagnostics: FrontendFlag {}
public struct ThrowsAsTraps: FrontendFlag {}
public struct BridgingHeaderPchKey: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DebugTimeFunctionBodies: FrontendFlag {}
public struct DiagnosticDocumentationPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableDeserializationRecovery: FrontendFlag {}
public struct TypecheckModuleFromInterface: FrontendFlag {}
public struct DisableSilOwnershipVerifier: FrontendFlag {}
public struct GroupInfoPath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SilInlineCallerBenefitReductionFactor: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitFixitsPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableExperimentalStringProcessing: FrontendFlag {}
public struct ForcePublicLinkage: FrontendFlag {}
public struct SwiftAsyncFramePointer: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableExperimentalConcurrency: FrontendFlag {}
public struct TestDependencyScanCacheSerialization: FrontendFlag {}
public struct DisableLegacyTypeInfo: FrontendFlag {}
public struct VerifyTypeLayout: FrontendFlag {
public let type: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(type)"]
}
public init(_ type: String) {
self.type = type
}
}
public struct DisableImplicitConcurrencyModuleImport: FrontendFlag {}
public struct ParallelScan: FrontendFlag {}
public struct PublicAutolinkLibrary: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableTargetOsChecking: FrontendFlag {}
public struct DependencyScanCachePath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct VerifyAllSubstitutionMaps: FrontendFlag {}
public struct TargetSdkName: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableNewLlvmPassManager: FrontendFlag {}
public struct ConditionalRuntimeRecords: FrontendFlag {}
public struct EnableStackProtector: FrontendFlag {}
public struct DisableRelativeProtocolWitnessTables: FrontendFlag {}
public struct TargetSdkVersion: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Repl: FrontendFlag {}
public struct DisableExperimentalParserRoundTrip: FrontendFlag {}
public struct DumpClangDiagnostics: FrontendFlag {}
public struct ForceStructTypeLayouts: FrontendFlag {}
public struct DisableStandardSubstitutionsInReflectionMangling: FrontendFlag {}
public struct Filelist: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitModuleSemanticInfoPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct ReflectionMetadataForDebuggerOnly: FrontendFlag {}
public struct SilUnrollThreshold: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableTestableAttrRequiresTestableModule: FrontendFlag {}
public struct PrintLlvmInlineTree: FrontendFlag {}
public struct DumpJit: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableStackProtector: FrontendFlag {}
public struct DumpRequirementMachine: FrontendFlag {}
public struct CasBackend: FrontendFlag {}
public struct SilStopOptznsBeforeLoweringOwnership: FrontendFlag {}
public struct IrgenAlwaysUseIndirectRelativeReferences: FrontendFlag {}
public struct ClangHeaderExposeDecls: FrontendFlag {
public let hasexposeattr: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(hasexposeattr)"]
}
public init(_ hasexposeattr: String) {
self.hasexposeattr = hasexposeattr
}
}
public struct CrosscheckUnqualifiedLookup: FrontendFlag {}
public struct EnableSilOpaqueValues: FrontendFlag {}
public struct ExperimentalPrintFullConvention: FrontendFlag {}
public struct SwiftModuleCrossImport: FrontendFlag {
public let modulename: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(modulename)"]
}
public init(_ modulename: String) {
self.modulename = modulename
}
}
public struct EnableDynamicReplacementChaining: FrontendFlag {}
public struct DisableTargetOsChecking: FrontendFlag {}
public struct InternalizeAtLink: FrontendFlag {}
public struct VerifyAdditionalFile: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct TbdCompatibilityVersion: FrontendFlag {
public let version: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(version)"]
}
public init(_ version: String) {
self.version = version
}
}
public struct DisableCrossImportOverlaySearch: FrontendFlag {}
public struct VerifyAdditionalPrefix: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DebugGenericSignatures: FrontendFlag {}
public struct ExternalPassPipelineFilename: FrontendFlag {
public let passpipelinefile: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(passpipelinefile)"]
}
public init(_ passpipelinefile: String) {
self.passpipelinefile = passpipelinefile
}
}
public struct DisableSilPerfOptzns: FrontendFlag {}
public struct DisableObjectiveCProtocolSymbolicReferences: FrontendFlag {}
public struct EnableExperimentalDistributed: FrontendFlag {}
public struct EnableCollocateMetadataFunctions: FrontendFlag {}
public struct TbdIsInstallapi: FrontendFlag {}
public struct EnableVolatileModules: FrontendFlag {}
public struct DisableRoundTripDebugTypes: FrontendFlag {}
public struct AliasModuleNamesInModuleInterface: FrontendFlag {}
public struct WeakLinkAtTarget: FrontendFlag {}
public struct IndexSystemModules: FrontendFlag {}
public struct DebugAssertAfterParse: FrontendFlag {}
public struct Playground: FrontendFlag {}
public struct DisableNamedLazyMemberLoading: FrontendFlag {}
public struct EnableSourceImport: FrontendFlag {}
public struct DisableExperimentalOpenedExistentialTypes: FrontendFlag {}
public struct DumpClangLookupTables: FrontendFlag {}
public struct DisableReadonlyStaticObjects: FrontendFlag {}
public struct SupplementaryOutputFileMap: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableCollocateMetadataFunctions: FrontendFlag {}
public struct DisableAllAutolinking: FrontendFlag {}
public struct EnableExperimentalFlowSensitiveConcurrentCaptures: FrontendFlag {}
public struct DebugTimeExpressionTypeChecking: FrontendFlag {}
public struct RequirementMachineMaxConcreteNesting: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct FunctionSections: FrontendFlag {}
public struct DisableAvailabilityChecking: FrontendFlag {}
public struct IndexUnitOutputPathFilelist: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct CasFs: FrontendFlag {
public let casid: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(casid)"]
}
public init(_ casid: String) {
self.casid = casid
}
}
public struct DisableTypeLayout: FrontendFlag {}
public struct EnableLargeLoadableTypesReg2mem: FrontendFlag {}
public struct PlaygroundOption: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct NoScannerModuleValidation: FrontendFlag {}
public struct DisableAutolinkFrameworks: FrontendFlag {}
public struct EnableObjcAttrRequiresFoundationModule: FrontendFlag {}
public struct DisablePrintMissingImportsInModuleInterface: FrontendFlag {}
public struct DisableConstraintSolverPerformanceHacks: FrontendFlag {}
public struct PreviousModuleInstallnameMapFile: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct UseJit: FrontendFlag {}
public struct EnableColocateTypeDescriptors: FrontendFlag {}
public struct RequirementMachineMaxRuleLength: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableExperimentalOpaqueTypeErasure: FrontendFlag {}
public struct DebugCrashAfterParse: FrontendFlag {}
public struct EnableInferPublicSendable: FrontendFlag {}
public struct CheckedAsyncObjcBridging: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableSingleModuleLlvmEmission: FrontendFlag {}
public struct EnableObjcInterop: FrontendFlag {}
public struct EnableNewOperatorLookup: FrontendFlag {}
public struct DisableLlvmValueNames: FrontendFlag {}
public struct DisableBuildingInterface: FrontendFlag {}
public struct EnableExperimentalNamedOpaqueTypes: FrontendFlag {}
public struct DisableModulesValidateSystemHeaders: FrontendFlag {}
public struct NewDriverPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableLexicalLifetimes: FrontendFlag {}
public struct ReadLegacyTypeInfoPath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ExperimentalForceWorkaroundBrokenModules: FrontendFlag {}
public struct ExperimentalAllowModuleWithCompilerErrors: FrontendFlag {}
public struct EnableLlvmWme: FrontendFlag {}
public struct DisableClangimporterSourceImport: FrontendFlag {}
public struct DisableAliasModuleNamesInModuleInterface: FrontendFlag {}
public struct DisableCrossImportOverlays: FrontendFlag {}
public struct DisableClangSpi: FrontendFlag {}
public struct EnableNewLlvmPassManager: FrontendFlag {}
public struct DirectClangCc1ModuleBuild: FrontendFlag {}
public struct DisableDeserializationSafety: FrontendFlag {}
public struct DisableSwift3ObjcInference: FrontendFlag {}
public struct DebugConstraints: FrontendFlag {}
public struct IgnoreAlwaysInline: FrontendFlag {}
public struct ModuleInterfacePreserveTypesAsWritten: FrontendFlag {}
public struct DisableTestableAttrRequiresTestableModule: FrontendFlag {}
public struct EnableLlvmValueNames: FrontendFlag {}
public struct ExperimentalOneWayClosureParams: FrontendFlag {}
public struct DebugForbidTypecheckPrefix: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DisableObjcInterop: FrontendFlag {}
public struct ValidateTbdAgainstIr: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct AutolinkLibrary: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableOperatorDesignatedTypes: FrontendFlag {}
public struct EnableExperimentalStringProcessing: FrontendFlag {}
public struct EnableExplicitExistentialTypes: FrontendFlag {}
public struct ImportPrescan: FrontendFlag {}
public struct ShowDiagnosticsAfterFatal: FrontendFlag {}
public struct CodeCompleteCallPatternHeuristics: FrontendFlag {}
public struct EnableDeserializationSafety: FrontendFlag {}
public struct EnableEmitGenericClassRoTList: FrontendFlag {}
public struct DisableVerifyExclusivity: FrontendFlag {}
public struct EmptyAbiDescriptor: FrontendFlag {}
public struct ScannerModuleValidation: FrontendFlag {}
public struct EmitClangHeaderPath: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SerializeDebuggingOptions: FrontendFlag {}
public struct DisableIncrementalLlvmCodegen: FrontendFlag {}
public struct DisableConcreteTypeMetadataMangledNameAccessors: FrontendFlag {}
public struct SerializeDiagnosticsPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableNonfrozenEnumExhaustivityDiagnostics: FrontendFlag {}
public struct TypeInfoDumpFilter: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct RdependencyScanCache: FrontendFlag {}
public struct ModuleCanImport: FrontendFlag {
public let modulename: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(modulename)"]
}
public init(_ modulename: String) {
self.modulename = modulename
}
}
public struct ExperimentalSkipNonExportableDecls: FrontendFlag {}
public struct DisableDiagnosticPasses: FrontendFlag {}
public struct WarnOnPotentiallyUnavailableEnumCase: FrontendFlag {}
public struct DisableNamedLazyImportAsMemberLoading: FrontendFlag {}
public struct EnableRelativeProtocolWitnessTables: FrontendFlag {}
public struct EmitRemapFilePath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableExperimentalPairwiseBuildBlock: FrontendFlag {}
public struct EmitModuleDocPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct PlatformAvailabilityInheritanceMapPath: FrontendFlag {
public let path: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DiagnosticsEditorMode: FrontendFlag {}
public struct EmitMacroExpansionFiles: FrontendFlag {
public let value: String
public var flagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct WarnConcurrency: UnsafeFlag {}
public struct NoStrictImplicitModuleContext: UnsafeFlag {}
public struct DisableBridgingPch: UnsafeFlag {}
public struct O: UnsafeFlag {
public let file: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(file)"]
}
public init(_ file: String) {
self.file = file
}
}
public struct EmitBc: UnsafeFlag {}
public struct EmitDigesterBaseline: UnsafeFlag {}
public struct Nostdimport: UnsafeFlag {}
public struct AllowableClient: UnsafeFlag {
public let vers: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(vers)"]
}
public init(_ vers: String) {
self.vers = vers
}
}
public struct RmacroLoading: UnsafeFlag {}
public struct PrintExplicitDependencyGraph: UnsafeFlag {}
public struct EmitSymbolGraphDir: UnsafeFlag {
public let dir: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(dir)"]
}
public init(_ dir: String) {
self.dir = dir
}
}
public struct EnableUpcomingFeature: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct FilePrefixMap: UnsafeFlag {
public let prefix: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct IndexIgnoreClangModules: UnsafeFlag {}
public struct ProjectName: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SanitizeAddressUseOdrIndicator: UnsafeFlag {}
public struct WindowsSdkRoot: UnsafeFlag {
public let root: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(root)"]
}
public init(_ root: String) {
self.root = root
}
}
public struct Xcc: UnsafeFlag {
public let arg: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(arg)"]
}
public init(_ arg: String) {
self.arg = arg
}
}
public struct StackCheck: UnsafeFlag {}
public struct EnableAutolinkingRuntimeCompatibilityBytecodeLayouts: UnsafeFlag {}
public struct Locale: UnsafeFlag {
public let localecode: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(localecode)"]
}
public init(_ localecode: String) {
self.localecode = localecode
}
}
public struct EmitApiDescriptor: UnsafeFlag {}
public struct EmitLocalizedStrings: UnsafeFlag {}
public struct PackageDescriptionVersion: UnsafeFlag {
public let vers: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(vers)"]
}
public init(_ vers: String) {
self.vers = vers
}
}
public struct Typecheck: UnsafeFlag {}
public struct DriverUseFrontendPath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct PchOutputDir: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SanitizeRecover: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitPcm: UnsafeFlag {}
public struct ScanDependencies: UnsafeFlag {}
public struct DisableAutolinkingRuntimeCompatibilityDynamicReplacements: UnsafeFlag {}
public struct ModuleLinkName: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct CompareToBaselinePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct MigrateKeepObjcVisibility: UnsafeFlag {}
public struct ApplicationExtension: UnsafeFlag {}
public struct RindexingSystemModule: UnsafeFlag {}
public struct GccToolchain: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DriverMode: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ProfileStatsEntities: UnsafeFlag {}
public struct Sdk: UnsafeFlag {
public let sdk: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(sdk)"]
}
public init(_ sdk: String) {
self.sdk = sdk
}
}
public struct TypoCorrectionLimit: UnsafeFlag {
public let n: Int
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct DriverAlwaysRebuildDependents: UnsafeFlag {}
public struct NoToolchainStdlibRpath: UnsafeFlag {}
public struct DriverBatchSeed: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Framework: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct JitBuild: UnsafeFlag {}
public struct Lto: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct VisualcToolsVersion: UnsafeFlag {
public let version: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(version)"]
}
public init(_ version: String) {
self.version = version
}
}
public struct Help: UnsafeFlag {}
public struct Version: UnsafeFlag {}
public struct FileCompilationDir: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DumpPcm: UnsafeFlag {}
public struct EmitLocalizedStringsPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct J: UnsafeFlag {
public let n: Int
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct SkipProtocolImplementations: UnsafeFlag {}
public struct DisableCmo: UnsafeFlag {}
public struct DriverBatchSizeLimit: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct TargetMinInliningVersion: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ParseAsLibrary: UnsafeFlag {}
public struct ExperimentalHermeticSealAtLink: UnsafeFlag {}
public struct LoadPluginLibrary: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct SwiftVersion: UnsafeFlag {
public let vers: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(vers)"]
}
public init(_ vers: String) {
self.vers = vers
}
}
public struct SwiftIsaPtrauthMode: UnsafeFlag {
public let mode: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(mode)"]
}
public init(_ mode: String) {
self.mode = mode
}
}
public struct ExperimentalCxxStdlib: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct IncludeSpiSymbols: UnsafeFlag {}
public struct DriverFilelistThreshold: UnsafeFlag {
public let n: Int
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct DisableBatchMode: UnsafeFlag {}
public struct RskipExplicitInterfaceBuild: UnsafeFlag {}
public struct ValueRecursionThreshold: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmbedTbdForModule: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct NoWarningsAsErrors: UnsafeFlag {}
public struct UseFrontendParseableOutput: UnsafeFlag {}
public struct ClangBuildSessionFile: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct MinRuntimeVersion: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct VisualcToolsRoot: UnsafeFlag {
public let root: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(root)"]
}
public init(_ root: String) {
self.root = root
}
}
public struct EmitObject: UnsafeFlag {}
public struct AssumeSingleThreaded: UnsafeFlag {}
public struct ExperimentalCForeignReferenceTypes: UnsafeFlag {}
public struct NonlibDependencyScanner: UnsafeFlag {}
public struct DriverShowIncremental: UnsafeFlag {}
public struct StatsOutputDir: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitDigesterBaselinePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct Nostartfiles: UnsafeFlag {}
public struct FixitAll: UnsafeFlag {}
public struct HelpHidden: UnsafeFlag {}
public struct OmitExtensionBlockSymbols: UnsafeFlag {}
public struct LibraryLevel: UnsafeFlag {
public let level: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(level)"]
}
public init(_ level: String) {
self.level = level
}
}
public struct DriverPrintJobs: UnsafeFlag {}
public struct CacheDisableReplay: UnsafeFlag {}
public struct TargetCpu: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct WarningsAsErrors: UnsafeFlag {}
public struct EnableIncrementalImports: UnsafeFlag {}
public struct CoveragePrefixMap: UnsafeFlag {
public let prefix: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct DisableDynamicActorIsolation: UnsafeFlag {}
public struct SaveTemps: UnsafeFlag {}
public struct EnableBuiltinModule: UnsafeFlag {}
public struct EmbedBitcode: UnsafeFlag {}
public struct EmitLoadedModuleTracePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct ParseStdlib: UnsafeFlag {}
public struct ExperimentalSkipNonInlinableFunctionBodies: UnsafeFlag {}
public struct EmitModule: UnsafeFlag {}
public struct GdwarfTypes: UnsafeFlag {}
public struct L: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableDefaultCmo: UnsafeFlag {}
public struct NoStaticStdlib: UnsafeFlag {}
public struct RmoduleSerialization: UnsafeFlag {}
public struct Gnone: UnsafeFlag {}
public struct DisableActorDataRaceChecks: UnsafeFlag {}
public struct EmitModuleSerializeDiagnosticsPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitPrivateModuleInterfacePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitModuleSummaryPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct PrettyPrint: UnsafeFlag {}
public struct EmitModuleInterface: UnsafeFlag {}
public struct EnableExperimentalAdditiveArithmeticDerivation: UnsafeFlag {}
public struct StrictConcurrency: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DumpParse: UnsafeFlag {}
public struct ExportAs: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct CrossModuleOptimization: UnsafeFlag {}
public struct EmitTbd: UnsafeFlag {}
public struct ColorDiagnostics: UnsafeFlag {}
public struct DriverPrintActions: UnsafeFlag {}
public struct ClangTarget: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct IndexUnitOutputPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DriverPrintOutputFileMap: UnsafeFlag {}
public struct Onone: UnsafeFlag {}
public struct EmitExecutable: UnsafeFlag {}
public struct AccessNotesPath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ResolveImports: UnsafeFlag {}
public struct ContinueBuildingAfterErrors: UnsafeFlag {}
public struct ExperimentalClangImporterDirectCc1Scan: UnsafeFlag {}
public struct StaticExecutable: UnsafeFlag {}
public struct IndexIncludeLocals: UnsafeFlag {}
public struct ExperimentalPerformanceAnnotations: UnsafeFlag {}
public struct StaticStdlib: UnsafeFlag {}
public struct NoLinkObjcRuntime: UnsafeFlag {}
public struct DisableOnlyOneDependencyFile: UnsafeFlag {}
public struct ToolchainStdlibRpath: UnsafeFlag {}
public struct SuppressRemarks: UnsafeFlag {}
public struct NumThreads: UnsafeFlag {
public let n: Int
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(n)"]
}
public init(_ n: Int) {
self.n = n
}
}
public struct Libc: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct OutputFileMap: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct NoVerifyEmittedModuleInterface: UnsafeFlag {}
public struct NoStaticExecutable: UnsafeFlag {}
public struct Rpass: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ApiDiffDataFile: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct CacheCompileJob: UnsafeFlag {}
public struct ScannerPrefixMap: UnsafeFlag {
public let prefix: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct ProfileGenerate: UnsafeFlag {}
public struct ExternalPluginPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct TargetFlag: UnsafeFlag {
public let triple: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(triple)"]
}
public init(_ triple: String) {
self.triple = triple
}
}
public struct ModuleCachePath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct ApiDiffDataDir: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct ScannerPrefixMapToolchain: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableOnlyOneDependencyFile: UnsafeFlag {}
public struct SaveOptimizationRecordPasses: UnsafeFlag {
public let regex: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(regex)"]
}
public init(_ regex: String) {
self.regex = regex
}
}
public struct LocalizationPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitApiDescriptorPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableExperimentalFeature: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct PrintEducationalNotes: UnsafeFlag {}
public struct RcrossImport: UnsafeFlag {}
public struct NoColorDiagnostics: UnsafeFlag {}
public struct F: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SymbolGraphMinimumAccessLevel: UnsafeFlag {
public let level: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(level)"]
}
public init(_ level: String) {
self.level = level
}
}
public struct ModuleAlias: UnsafeFlag {
public let aliasname: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(aliasname)"]
}
public init(_ aliasname: String) {
self.aliasname = aliasname
}
}
public struct DebugInfoFormat: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitModulePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct ExplainModuleDependency: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Vfsoverlay: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Osize: UnsafeFlag {}
public struct SkipInheritedDocs: UnsafeFlag {}
public struct VerifyDebugInfo: UnsafeFlag {}
public struct DumpMigrationStatesDir: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitObjcHeaderPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct NoSignClassRo: UnsafeFlag {}
public struct EnableActorDataRaceChecks: UnsafeFlag {}
public struct WarnSwift3ObjcInferenceComplete: UnsafeFlag {}
public struct RequireExplicitAvailabilityTarget: UnsafeFlag {
public let target: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(target)"]
}
public init(_ target: String) {
self.target = target
}
}
public struct EnableBareSlashRegex: UnsafeFlag {}
public struct VerifyEmittedModuleInterface: UnsafeFlag {}
public struct SerializeDiagnostics: UnsafeFlag {}
public struct ScannerPrefixMapSdk: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DebugPrefixMap: UnsafeFlag {
public let prefix: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(prefix)"]
}
public init(_ prefix: String) {
self.prefix = prefix
}
}
public struct ProfileCoverageMapping: UnsafeFlag {}
public struct EmitLoadedModuleTrace: UnsafeFlag {}
public struct PrefixSerializedDebuggingOptions: UnsafeFlag {}
public struct NoAllocations: UnsafeFlag {}
public struct EmitSupportedFeatures: UnsafeFlag {}
public struct UseLd: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableBatchMode: UnsafeFlag {}
public struct ImportObjcHeader: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct PrintTargetInfo: UnsafeFlag {}
public struct ExplicitDependencyGraphFormat: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct MigratorUpdateSwift: UnsafeFlag {}
public struct ExperimentalAllowNonResilientAccess: UnsafeFlag {}
public struct DisableSwiftBridgeAttr: UnsafeFlag {}
public struct AssertConfig: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct WindowsSdkVersion: UnsafeFlag {
public let version: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(version)"]
}
public init(_ version: String) {
self.version = version
}
}
public struct EmbedBitcodeMarker: UnsafeFlag {}
public struct D: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DriverSkipExecution: UnsafeFlag {}
public struct DriverEmitFineGrainedDependencyDotFileAfterEveryImport: UnsafeFlag {}
public struct SanitizeStableAbi: UnsafeFlag {}
public struct ExperimentalPackageCmo: UnsafeFlag {}
public struct EmitConstValuesPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct SerializeBreakingChangesPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct PluginPath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DriverPrintBindings: UnsafeFlag {}
public struct Oplayground: UnsafeFlag {}
public struct EmitIrgen: UnsafeFlag {}
public struct SaveOptimizationRecordPath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct AvoidEmitModuleSourceInfo: UnsafeFlag {}
public struct SuppressWarnings: UnsafeFlag {}
public struct WarnSwift3ObjcInferenceMinimal: UnsafeFlag {}
public struct LinkObjcRuntime: UnsafeFlag {}
public struct RmoduleApiImport: UnsafeFlag {}
public struct EmitTbdPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EnableCmoEverything: UnsafeFlag {}
public struct EmitFineGrainedDependencySourcefileDotFiles: UnsafeFlag {}
public struct MigratorUpdateSdk: UnsafeFlag {}
public struct EmitImportedModules: UnsafeFlag {}
public struct DriverPrintGraphviz: UnsafeFlag {}
public struct DriverVerifyFineGrainedDependencyGraphAfterEveryImport: UnsafeFlag {}
public struct DigesterBreakageAllowlistPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisableMigratorFixits: UnsafeFlag {}
public struct NoStackCheck: UnsafeFlag {}
public struct RmoduleLoading: UnsafeFlag {}
public struct UpdateCode: UnsafeFlag {}
public struct StrictImplicitModuleContext: UnsafeFlag {}
public struct DriverTimeCompilation: UnsafeFlag {}
public struct RequireExplicitSendable: UnsafeFlag {}
public struct EmitDependencies: UnsafeFlag {}
public struct DriverWarnUnusedOptions: UnsafeFlag {}
public struct WholeModuleOptimization: UnsafeFlag {}
public struct EmitPackageModuleInterfacePath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct EmitSibgen: UnsafeFlag {}
public struct EmitSymbolGraph: UnsafeFlag {}
public struct IndexIgnoreSystemModules: UnsafeFlag {}
public struct EnableTesting: UnsafeFlag {}
public struct EmitModuleSourceInfoPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct TraceStatsEvents: UnsafeFlag {}
public struct EmitModuleSeparatelyWmo: UnsafeFlag {}
public struct LoadPluginExecutable: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DebugInfoStoreInvocation: UnsafeFlag {}
public struct ExplicitModuleBuild: UnsafeFlag {}
public struct EnableExperimentalForwardModeDifferentiation: UnsafeFlag {}
public struct TargetVariant: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct DriverForceResponseFiles: UnsafeFlag {}
public struct NoEmitModuleSeparatelyWmo: UnsafeFlag {}
public struct DriverPrintDerivedOutputFileMap: UnsafeFlag {}
public struct NoEmitModuleSeparately: UnsafeFlag {}
public struct Parse: UnsafeFlag {}
public struct DiagnosticStyle: UnsafeFlag {
public let style: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(style)"]
}
public init(_ style: String) {
self.style = style
}
}
public struct UnavailableDeclOptimization: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SolverMemoryThreshold: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct Xfrontend: UnsafeFlag {
public let arg: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(arg)"]
}
public init(_ arg: String) {
self.arg = arg
}
}
public struct ProfileStatsEvents: UnsafeFlag {}
public struct DriverUseFilelists: UnsafeFlag {}
public struct PackageName: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct CheckApiAvailabilityOnly: UnsafeFlag {}
public struct EmitLibrary: UnsafeFlag {}
public struct RequireExplicitAvailability: UnsafeFlag {}
public struct DumpScopeMaps: UnsafeFlag {
public let expandedorlistofline: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(expandedorlistofline)"]
}
public init(_ expandedorlistofline: String) {
self.expandedorlistofline = expandedorlistofline
}
}
public struct E: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct LdPath: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct SanitizeCoverage: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitModuleDependenciesPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DumpAst: UnsafeFlag {}
public struct NoWholeModuleOptimization: UnsafeFlag {}
public struct CasPluginOption: UnsafeFlag {
public let name: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(name)"]
}
public init(_ name: String) {
self.name = name
}
}
public struct ExperimentalEmitModuleSeparately: UnsafeFlag {}
public struct PrintAst: UnsafeFlag {}
public struct WorkingDirectory: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct XclangLinker: UnsafeFlag {
public let arg: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(arg)"]
}
public init(_ arg: String) {
self.arg = arg
}
}
public struct G: UnsafeFlag {}
public struct ExperimentalSkipNonInlinableFunctionBodiesWithoutTypes: UnsafeFlag {}
public struct RpassMissed: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EmitSib: UnsafeFlag {}
public struct AutolinkForceLoad: UnsafeFlag {}
public struct EmitExtensionBlockSymbols: UnsafeFlag {}
public struct ImportCfTypes: UnsafeFlag {}
public struct DebugDiagnosticNames: UnsafeFlag {}
public struct CasPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DumpUsr: UnsafeFlag {}
public struct RemoveRuntimeAsserts: UnsafeFlag {}
public struct ModuleAbiName: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct EnableExperimentalConcisePoundFile: UnsafeFlag {}
public struct DumpTypeInfo: UnsafeFlag {}
public struct VerifyIncrementalDependencies: UnsafeFlag {}
public struct CasPluginPath: UnsafeFlag {
public let path: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(path)"]
}
public init(_ path: String) {
self.path = path
}
}
public struct DisallowUseNewDriver: UnsafeFlag {}
public struct EnablePrivateImports: UnsafeFlag {}
public struct ProfileUse: UnsafeFlag {
public let value: String
public var unsafeFlagArguments: [String] {
["\(name.camelToSnakeCaseFlag())", "\(value)"]
}
public init(_ value: String) {
self.value = value
}
}
public struct AccessLevelOnImport: SwiftSettingFeature {
public var featureState: FeatureState {
.experimental
}
}
public struct NestedProtocols: SwiftSettingFeature {
public var featureState: FeatureState {
.experimental
}
}
public struct VariadicGenerics: SwiftSettingFeature {
public var featureState: FeatureState {
.experimental
}
}
public struct NoncopyableGenerics: SwiftSettingFeature {
public var featureState: FeatureState {
.experimental
}
}
public struct GlobalConcurrency: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct GlobalActorIsolatedTypesUsability: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct NonescapableTypes: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct RegionBasedIsolation: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct InferSendableFromCaptures: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct DeprecateApplicationMain: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct MemberImportVisibility: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct ImportObjcForwardDeclarations: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct DynamicActorIsolation: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct IsolatedDefaultValues: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct InternalImportsByDefault: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
public struct DisableOutwardActorInference: SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
}
extension Array: TestTargets where Element == any TestTarget {
public func appending(_ testTargets: any TestTargets) -> [any TestTarget] {
self + testTargets
}
}
public protocol TestTargets: Sequence where Element == any TestTarget {
init<S>(_ sequence: S) where S.Element == any TestTarget, S: Sequence
func appending(_ testTargets: any TestTargets) -> Self
}
@resultBuilder
public enum GroupBuilder<U> {
public static func buildPartialBlock<T: GroupBuildable>(
accumulated: [U],
next: T
) -> [U]
where T.Output == U {
accumulated + T.output(from: [next])
}
public static func buildPartialBlock<T: GroupBuildable>(
first: T
) -> [U] where T.Output == U {
T.output(from: [first])
}
}
public protocol Dependency {
var targetDependency: _PackageDescription_TargetDependency { get }
}
extension String {
var packageName: String? {
split(separator: "/").last?.split(separator: ".").first.map(String.init)
}
func camelToSnakeCaseFlag(withSeparator separator: String = "-") -> String {
separator
+ enumerated()
.reduce("") {
$0 + ($1.offset > 0 && $1.element.isUppercase ? separator : "")
+ String($1.element).lowercased()
}
}
}
public struct Group<T> {
public let name: String?
internal init(_ name: String? = nil) {
self.name = name
}
public func callAsFunction(@GroupBuilder<T> content: () -> [T]) -> [T] {
content()
}
}
public protocol Product: _Named, GroupBuildable {
var productTargets: [Target] { get }
var productType: ProductType { get }
var libraryType: LibraryType? { get }
}
extension Product {
public var productType: ProductType {
.library
}
public var libraryType: LibraryType? {
nil
}
}
public protocol SwiftSettingsConvertible: GroupBuildable where Output == SwiftSetting {
func swiftSettings() -> [SwiftSetting]
}
extension SwiftSettingsConvertible {
public static func output(from array: [Self]) -> [SwiftSetting] {
array.flatMap {
$0.swiftSettings()
}
}
}
public protocol _Named {
var name: String { get }
}
extension _Named {
public var name: String {
"\(Self.self)"
}
}
protocol TargetDependency: Dependency, _Named {
var productName: String { get }
var package: PackageDependency { get }
var condition: TargetDependencyCondition? { get }
}
extension TargetDependency {
var productName: String {
name
}
var targetDependency: _PackageDescription_TargetDependency {
.product(name: name, package: package.packageName, condition: condition)
}
var condition: TargetDependencyCondition? { nil }
}
public protocol SupportedPlatforms: Sequence where Element == SupportedPlatform {
init<S>(_ sequence: S) where S.Element == SupportedPlatform, S: Sequence
func appending(_ platforms: any SupportedPlatforms) -> Self
}
@resultBuilder
public enum TestTargetBuilder {
public static func buildPartialBlock(first: [any TestTarget]) -> any TestTargets {
first
}
public static func buildPartialBlock(first: any TestTarget) -> any TestTargets {
[first]
}
public static func buildPartialBlock(
accumulated: any TestTargets,
next: any TestTarget
) -> any TestTargets {
accumulated + [next]
}
public static func buildPartialBlock(
accumulated: any TestTargets,
next: any TestTargets
) -> any TestTargets {
accumulated.appending(next)
}
}
public protocol SwiftSettingFeature: _Named, SwiftSettingConvertible {
var featureState: FeatureState { get }
}
extension SwiftSettingFeature {
public var featureState: FeatureState {
.upcoming
}
public var setting: SwiftSetting {
featureState.swiftSetting(name: name)
}
}
extension Array: SupportedPlatforms where Element == SupportedPlatform {
public func appending(_ platforms: any SupportedPlatforms) -> Self {
self + .init(platforms)
}
}
PACKAGEDSL

find Package/Sources -mindepth 2 -type f -name '*.swift' -not -path '*/\.*' -exec cat {} + >> $input_file
cat Package/Sources/*.swift >> $input_file

# Collect unique import statements
imports=$(awk '/^import / {imports[$0]=1} END {for (i in imports) print i}' "$input_file")

if [ "$MINIMIZE" = true ]; then
  # Remove empty lines, lines containing only comments, and import statements
  awk '!/^[[:space:]]*(\/\/.*)?$|^import /' "$input_file" > "$output_file.tmp"
  
  # Remove leading and trailing whitespace from each line
  sed -i '' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' "$output_file.tmp"
  
  # Append collected import statements at the beginning of the file
  echo "// swift-tools-version: $swift_tools_version" > $output_file
  echo "$imports" >> "$output_file"
  cat "$output_file.tmp" >> "$output_file"
  
  # Clean up temporary file
  rm "$output_file.tmp"
else
  # Append collected import statements at the beginning of the file
  echo "// swift-tools-version: $swift_tools_version" > $output_file
  
  # Append collected import statements at the beginning of the file
  echo "$imports" >> "$output_file"
  
  cat "$input_file" >> "$output_file"
fi
