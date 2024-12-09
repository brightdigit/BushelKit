// swift-tools-version: 6.0
import Foundation
import PackageDescription
extension _PackageDescription_Product {
static func entry(_ entry: any Product) -> _PackageDescription_Product {
let targets = entry.productTargets.map(\.name)
switch entry.productType {
case .executable:
return Self.executable(name: entry.name, targets: targets)
case .library:
return Self.library(name: entry.name, type:  entry.libraryType, targets: targets)
}
}
}
@resultBuilder
public enum SwiftSettingsBuilder {
public static func buildPartialBlock(first: SwiftSetting) -> [SwiftSetting] {
[first]
}
public static func buildPartialBlock(accumulated: [SwiftSetting], next: SwiftSetting)
-> [SwiftSetting]
{
accumulated + [next]
}
public static func buildPartialBlock(accumulated: [SwiftSetting], next: [SwiftSetting])
-> [SwiftSetting]
{
accumulated + next
}
public static func buildPartialBlock(first: [SwiftSetting]) -> [SwiftSetting] {
first
}
public static func buildPartialBlock(first: any SwiftSettingsConvertible) -> [SwiftSetting] {
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
static func entry(_ entry: Target, swiftSettings: [SwiftSetting] = [])
-> _PackageDescription_Target
{
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
.regular
case .executable:
.executable
}
}
}
extension Package {
convenience init(
name: String? = nil,
@ProductsBuilder entries: @escaping () -> [any Product],
@PackageDependencyBuilder dependencies packageDependencies: @escaping () -> [any PackageDependency] = { [any PackageDependency] () },
@TestTargetBuilder testTargets: @escaping () -> any TestTargets = { [any TestTarget]() },
@SwiftSettingsBuilder swiftSettings: @escaping () -> [SwiftSetting] = { [SwiftSetting]() }
) {
let packageName: String
if let name {
packageName = name
} else {
var pathComponents = #filePath.split(separator: "/")
pathComponents.removeLast()
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
let packageTargetDependencies = dependencies.compactMap { $0 as? TargetDependency }
let allPackageDependencies = packageTargetDependencies.map(\.package) + packageDependencies()
targets += targetDependencies
targets += allTestTargets.map { $0 as Target }
let packgeTargets = Dictionary(
grouping: targets,
by: { $0.name }
)
.values
.compactMap(\.first)
.map { _PackageDescription_Target.entry($0, swiftSettings: swiftSettings()) }
let packageDeps = Dictionary(
grouping: allPackageDependencies,
by: { $0.packageName }
)
.values.compactMap(\.first).map(\.dependency)
self.init(
name: packageName,
products: products,
dependencies: packageDeps,
targets: packgeTargets
)
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
enum PackageDependencyBuilder {
internal static func buildPartialBlock(first: PackageDependency) -> [any PackageDependency] {
[first]
}
internal static func buildPartialBlock(accumulated: [any PackageDependency], next: PackageDependency) -> [any PackageDependency]{
accumulated + [next]
}
}
protocol PackageDependency: _Named {
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
return .product(name: productName, package: packageName, condition: self.condition)
case .fileSystem(let name, let path):
if let packageName = name ?? path.components(separatedBy: "/").last {
return .product(name: productName, package: packageName, condition: self.condition)
} else {
return .byName(name: productName)
}
case .registry:
return .byName(name: productName)
@unknown default:
return .byName(name: productName)
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
@DependencyBuilder
var dependencies: any Dependencies { get }
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
enum DependencyBuilder {
static func buildPartialBlock(first: Dependency) -> any Dependencies {
[first]
}
static func buildPartialBlock(accumulated: any Dependencies, next: Dependency) -> any Dependencies
{
accumulated + [next]
}
}
extension LanguageTag {
nonisolated(unsafe) static let english: LanguageTag = "en"
}
public protocol Target: _Depending, Dependency, _Named {
var targetType: TargetType { get }
@SwiftSettingsBuilder
var swiftSettings: [SwiftSetting] { get }
@ResourcesBuilder
var resources: [Resource] { get }
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
init<S>(_ s: S) where S.Element == Dependency, S: Sequence
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
public static func buildPartialBlock(accumulated: [any Product], next: any Product)
-> [any Product]
{
accumulated + [next]
}
public static func buildPartialBlock(accumulated: [any Product], next: [any Product])
-> [any Product]
{
accumulated + next
}
}
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
extension Array: Dependencies where Element == Dependency {
public func appending(_ dependencies: any Dependencies) -> [Dependency] {
self + dependencies
}
}
@resultBuilder
enum ResourcesBuilder {
static func buildPartialBlock(first: Resource) -> [Resource] {
[first]
}
static func buildPartialBlock(accumulated: [Resource], next: Resource) -> [Resource] {
accumulated + [next]
}
}
public protocol GroupBuildable {
associatedtype Output = Self
static func output(from array: [Self]) -> [Self.Output]
}
extension GroupBuildable where Output == Self {
static func output(from array: [Self]) -> [Self.Output] {
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
case .experimental:
.enableExperimentalFeature(name)
case .upcoming:
.enableUpcomingFeature(name)
}
}
}
protocol PlatformSet {
@SupportedPlatformBuilder
var body: any SupportedPlatforms { get }
}
public typealias _PackageDescription_Product = PackageDescription.Product
public typealias _PackageDescription_Target = PackageDescription.Target
public typealias _PackageDescription_TargetDependency = PackageDescription.Target.Dependency
public typealias _PackageDescription_PackageDependency = PackageDescription.Package.Dependency
public typealias LibraryType = PackageDescription.Product.Library.LibraryType//
public struct GlobalActorIsolatedTypesUsability: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct RegionBasedIsolation: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct TransferringArgsAndResults: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct AccessLevelOnImport: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct NestedProtocols: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct VariadicGenerics: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct BitwiseCopyable: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct NoncopyableGenerics: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct MoveOnlyPartialConsumption: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct IsolatedAny: SwiftSettingFeature {
public var featureState: FeatureState {
return .experimental
}
}
public struct StrictConcurrency: SwiftSettingFeature {
public let featureState: FeatureState
public init (featureState: FeatureState = .experimental) {
self.featureState = featureState
}
}
public struct GlobalConcurrency: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct InferSendableFromCaptures: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct DeprecateApplicationMain: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct FullTypedThrows: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct ImportObjcForwardDeclarations: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct DynamicActorIsolation: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct IsolatedDefaultValues: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct InternalImportsByDefault: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct DisableOutwardActorInference: SwiftSettingFeature {
public var featureState: FeatureState {
return .upcoming
}
}
public struct Ounchecked: UnsafeFlag {}
public struct ParseableOutput: UnsafeFlag {}
public struct EmitObjcHeader: UnsafeFlag {}
public struct EnableLibraryEvolution: UnsafeFlag {}
struct WarnLongExpressionTypeChecking : UnsafeFlag {
internal init(milliseconds: Int) {
self.milliseconds = milliseconds
}
let milliseconds : Int
var unsafeFlagArguments: [String] {
[
"-Xfrontend",
"-warn-long-expression-type-checking=\(milliseconds)"
]
}
}
public struct DisableIncrementalImports: UnsafeFlag {}
public struct WarnImplicitOverrides: UnsafeFlag {}
public struct ParseSil: UnsafeFlag {}
public struct ValidateClangModulesOnce: UnsafeFlag {}
public struct EmitModuleSummary: UnsafeFlag {}
public struct PrintAstDecl: UnsafeFlag {}
public struct TrackSystemDependencies: UnsafeFlag {}
public struct DisableAutolinkingRuntimeCompatibility: UnsafeFlag {}
public struct DumpTypeRefinementContexts: UnsafeFlag {}
public struct GlineTablesOnly: UnsafeFlag {}
public struct EmitSil: UnsafeFlag {}
public struct IndexFile: UnsafeFlag {}
public struct EmitSilgen: UnsafeFlag {}
public struct EmitAssembly: UnsafeFlag {}
public struct DisableClangTarget: UnsafeFlag {}
public struct DisableSandbox: UnsafeFlag {}
public struct ImportUnderlyingModule: UnsafeFlag {}
public struct Static: UnsafeFlag {}
public struct EmitClangHeaderNonmodularIncludes: UnsafeFlag {}
public struct SaveOptimizationRecord: UnsafeFlag {}
public struct RcacheCompileJob: UnsafeFlag {}
struct WarnLongFunctionBodies : UnsafeFlag {
internal init(milliseconds: Int) {
self.milliseconds = milliseconds
}
let milliseconds : Int
var unsafeFlagArguments: [String] {
[
"-Xfrontend",
"-warn-long-function-bodies=\(milliseconds)"
]
}
}
public struct DisableAutolinkingRuntimeCompatibilityConcurrency: UnsafeFlag {}
public struct RmoduleRecovery: UnsafeFlag {}
public struct EmitIr: UnsafeFlag {}
public struct V: UnsafeFlag {}
public struct WarnConcurrency: UnsafeFlag {}
public struct O: UnsafeFlag {}
public struct EmitBc: UnsafeFlag {}
public struct EmitDigesterBaseline: UnsafeFlag {}
public struct Nostdimport: UnsafeFlag {}
public struct RmacroLoading: UnsafeFlag {}
public struct IndexIgnoreClangModules: UnsafeFlag {}
public struct EnableAutolinkingRuntimeCompatibilityBytecodeLayouts: UnsafeFlag {}
public struct Typecheck: UnsafeFlag {}
public struct EmitPcm: UnsafeFlag {}
public struct ScanDependencies: UnsafeFlag {}
public struct DisableAutolinkingRuntimeCompatibilityDynamicReplacements: UnsafeFlag {}
public struct MigrateKeepObjcVisibility: UnsafeFlag {}
public struct ApplicationExtension: UnsafeFlag {}
public struct RindexingSystemModule: UnsafeFlag {}
public struct Help: UnsafeFlag {}
public struct Version: UnsafeFlag {}
public struct DumpPcm: UnsafeFlag {}
public struct ParseAsLibrary: UnsafeFlag {}
public struct RskipExplicitInterfaceBuild: UnsafeFlag {}
public struct NoWarningsAsErrors: UnsafeFlag {}
public struct EmitObject: UnsafeFlag {}
public struct FixitAll: UnsafeFlag {}
public struct CacheDisableReplay: UnsafeFlag {}
public struct WarningsAsErrors: UnsafeFlag {}
public struct EnableIncrementalImports: UnsafeFlag {}
public struct SaveTemps: UnsafeFlag {}
public struct EnableBuiltinModule: UnsafeFlag {}
public struct EmbedBitcode: UnsafeFlag {}
public struct EmitModule: UnsafeFlag {}
public struct GdwarfTypes: UnsafeFlag {}
public struct Gnone: UnsafeFlag {}
public struct DisableActorDataRaceChecks: UnsafeFlag {}
public struct PrettyPrint: UnsafeFlag {}
public struct EmitModuleInterface: UnsafeFlag {}
public struct EnableExperimentalAdditiveArithmeticDerivation: UnsafeFlag {}
public struct DumpParse: UnsafeFlag {}
public struct EmitTbd: UnsafeFlag {}
public struct ColorDiagnostics: UnsafeFlag {}
public struct Onone: UnsafeFlag {}
public struct EmitExecutable: UnsafeFlag {}
public struct ResolveImports: UnsafeFlag {}
public struct ContinueBuildingAfterErrors: UnsafeFlag {}
public struct StaticExecutable: UnsafeFlag {}
public struct IndexIncludeLocals: UnsafeFlag {}
public struct StaticStdlib: UnsafeFlag {}
public struct DisableOnlyOneDependencyFile: UnsafeFlag {}
public struct SuppressRemarks: UnsafeFlag {}
public struct NoVerifyEmittedModuleInterface: UnsafeFlag {}
public struct CacheCompileJob: UnsafeFlag {}
public struct ProfileGenerate: UnsafeFlag {}
public struct EnableOnlyOneDependencyFile: UnsafeFlag {}
public struct PrintEducationalNotes: UnsafeFlag {}
public struct RcrossImport: UnsafeFlag {}
public struct NoColorDiagnostics: UnsafeFlag {}
public struct Osize: UnsafeFlag {}
public struct VerifyDebugInfo: UnsafeFlag {}
public struct EnableActorDataRaceChecks: UnsafeFlag {}
public struct WarnSwift3ObjcInferenceComplete: UnsafeFlag {}
public struct EnableBareSlashRegex: UnsafeFlag {}
public struct VerifyEmittedModuleInterface: UnsafeFlag {}
public struct SerializeDiagnostics: UnsafeFlag {}
public struct ProfileCoverageMapping: UnsafeFlag {}
public struct EmitLoadedModuleTrace: UnsafeFlag {}
public struct PrefixSerializedDebuggingOptions: UnsafeFlag {}
public struct EmitSupportedFeatures: UnsafeFlag {}
public struct PrintTargetInfo: UnsafeFlag {}
public struct MigratorUpdateSwift: UnsafeFlag {}
public struct EmbedBitcodeMarker: UnsafeFlag {}
public struct EmitIrgen: UnsafeFlag {}
public struct AvoidEmitModuleSourceInfo: UnsafeFlag {}
public struct SuppressWarnings: UnsafeFlag {}
public struct WarnSwift3ObjcInferenceMinimal: UnsafeFlag {}
public struct LinkObjcRuntime: UnsafeFlag {}
public struct MigratorUpdateSdk: UnsafeFlag {}
public struct EmitImportedModules: UnsafeFlag {}
public struct DisableMigratorFixits: UnsafeFlag {}
public struct RmoduleLoading: UnsafeFlag {}
public struct DriverTimeCompilation: UnsafeFlag {}
public struct RequireExplicitSendable: UnsafeFlag {}
public struct EmitDependencies: UnsafeFlag {}
public struct WholeModuleOptimization: UnsafeFlag {}
public struct EmitSibgen: UnsafeFlag {}
public struct IndexIgnoreSystemModules: UnsafeFlag {}
public struct DebugInfoStoreInvocation: UnsafeFlag {}
public struct EnableExperimentalForwardModeDifferentiation: UnsafeFlag {}
public struct Parse: UnsafeFlag {}
public struct EmitLibrary: UnsafeFlag {}
public struct RequireExplicitAvailability: UnsafeFlag {}
public struct DumpAst: UnsafeFlag {}
public struct NoWholeModuleOptimization: UnsafeFlag {}
public struct PrintAst: UnsafeFlag {}
public struct G: UnsafeFlag {}
public struct EmitSib: UnsafeFlag {}
public struct DumpUsr: UnsafeFlag {}
public struct RemoveRuntimeAsserts: UnsafeFlag {}
public struct EnableExperimentalConcisePoundFile: UnsafeFlag {}
public struct DumpTypeInfo: UnsafeFlag {}
public struct DisallowUseNewDriver: UnsafeFlag {}
extension Array: TestTargets where Element == any TestTarget {
public func appending(_ testTargets: any TestTargets) -> [any TestTarget] {
self + testTargets
}
}
public protocol TestTargets: Sequence where Element == any TestTarget {
init<S>(_ s: S) where S.Element == any TestTarget, S: Sequence
func appending(_ testTargets: any TestTargets) -> Self
}
@resultBuilder
public enum GroupBuilder<U> {
public static func buildPartialBlock<T: GroupBuildable>(accumulated: [U], next: T) -> [U]
where T.Output == U {
accumulated + T.output(from: [next])
}
public static func buildPartialBlock<T: GroupBuildable>(first: T) -> [U] where T.Output == U {
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
internal init(_ name: String? = nil) {
self.name = name
}
public let name: String?
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
var condition: TargetDependencyCondition? { return nil }
}
public protocol SupportedPlatforms: Sequence where Element == SupportedPlatform {
init<S>(_ s: S) where S.Element == SupportedPlatform, S: Sequence
func appending(_ platforms: any SupportedPlatforms) -> Self
}
@resultBuilder
enum TestTargetBuilder {
static func buildPartialBlock(first: [any TestTarget]) -> any TestTargets {
first
}
static func buildPartialBlock(first: any TestTarget) -> any TestTargets {
[first]
}
static func buildPartialBlock(accumulated: any TestTargets, next: any TestTarget)
-> any TestTargets
{
accumulated + [next]
}
static func buildPartialBlock(accumulated: any TestTargets, next: any TestTargets)
-> any TestTargets
{
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
struct WWDC2023: PlatformSet {
var body: any SupportedPlatforms {
SupportedPlatform.macOS(.v14)
SupportedPlatform.iOS(.v17)
SupportedPlatform.watchOS(.v10)
SupportedPlatform.tvOS(.v17)
SupportedPlatform.visionOS(.v1)
SupportedPlatform.macCatalyst(.v17)
}
}
struct BushelMacOSCore: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
BushelUtilities()
BushelDocs()
RadiantKit()
}
}
struct BushelUtilities: Product, Target {}
struct BushelTestUtilities: Product, Target {}
struct BushelHubIPSW: Product, Target {
var dependencies: any Dependencies {
BushelHub()
IPSWDownloads()
BushelLogging()
BushelMacOSCore()
}
}
struct BushelHubMacOS: Product, Target {
var dependencies: any Dependencies {
BushelHub()
BushelMacOSCore()
}
}
struct BushelFactory: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
BushelMachine()
BushelLibrary()
BushelLogging()
}
}
struct BushelVirtualBuddy: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
BushelMacOSCore()
}
}
struct BushelLogging: Product, Target {
var dependencies: any Dependencies {
FelinePine()
FelinePineSwift()
}
}
struct BushelGuestProfile: Product, Target {
var dependencies: any Dependencies {
BushelLogging()
}
}
struct BushelUT: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
RadiantDocs()
}
}
struct BushelMachine: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
BushelDocs()
BushelLogging()
}
}
struct BushelLibrary: Product, Target {
var dependencies: any Dependencies {
BushelLogging()
BushelFoundation()
BushelMacOSCore()
RadiantKit()
}
}
struct BushelHub: Product, Target {
var dependencies: any Dependencies {
BushelLogging()
BushelFoundation()
}
}
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
struct BushelDocs: Product, Target {
var dependencies: any Dependencies {
RadiantDocs()
BushelFoundation()
}
}
struct BushelFoundationWax: Product, Target {
var dependencies: any Dependencies {
BushelFoundation()
RadiantDocs()
}
}
struct BushelFoundation: Product, Target {
var dependencies: any Dependencies {
BushelUtilities()
OperatingSystemVersion()
RadiantKit()
}
}
struct BushelLibraryWax: Target {
var dependencies: any Dependencies {
BushelLibrary()
BushelMacOSCore()
}
}
struct BushelArgs: Target {
var dependencies: any Dependencies {
ArgumentParser()
BushelFoundation()
}
}
struct BushelMachineWax: Target {
var dependencies: any Dependencies {
BushelFoundationWax()
BushelMachine()
}
}
struct BushelFactoryTests: TestTarget {
var dependencies: any Dependencies {
BushelFactory()
BushelTestUtilities()
BushelFoundationWax()
BushelMachineWax()
}
}
struct BushelLibraryTests: TestTarget {
var dependencies: any Dependencies {
BushelLibrary()
BushelFoundationWax()
BushelLibraryWax()
BushelTestUtilities()
}
}
struct BushelUtlitiesTests: TestTarget {
var dependencies: any Dependencies {
BushelUtilities()
BushelTestUtilities()
}
}
struct BushelFoundationTests: TestTarget {
var dependencies: any Dependencies {
BushelFoundation()
BushelFoundationWax()
BushelTestUtilities()
}
}
struct BushelMachineTests: TestTarget {
var dependencies: any Dependencies {
BushelMachine()
BushelMachineWax()
BushelTestUtilities()
}
}
struct DocC: PackageDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.0")
}
}
struct RadiantPaging: TargetDependency {
var package: PackageDependency {
RadiantKit()
}
}
struct RadiantProgress: TargetDependency {
var package: PackageDependency {
RadiantKit()
}
}
struct RadiantDocs: TargetDependency {
var package: PackageDependency {
RadiantKit()
}
}
struct FelinePine: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/brightdigit/FelinePine.git", from: "1.0.0-beta.2")
}
}
struct OperatingSystemVersion: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/brightdigit/OperatingSystemVersion.git", from: "1.0.0-beta.1")
}
}
struct RadiantKit: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/brightdigit/RadiantKit.git", from: "1.0.0-alpha.4")
}
}
struct IPSWDownloads: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/brightdigit/IPSWDownloads.git", from: "1.0.0-beta.4")
}
}
struct FelinePineSwift: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/brightdigit/FelinePineSwift.git", from: "1.0.0-alpha.1")
}
var condition: TargetDependencyCondition? {
.notApple()
}
}
extension TargetDependencyCondition {
nonisolated static func notApple() -> TargetDependencyCondition? {
.when(platforms: [
.android,
.linux,
.openbsd,
.wasi,
.windows
])
}
}
struct ArgumentParser: PackageDependency, TargetDependency {
var dependency: Package.Dependency {
.package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0")
}
}
let package = Package(
name: "BushelKit",
entries: {
BushelCommand()
BushelFoundation()
BushelDocs()
BushelUtilities()
BushelFoundationWax()
BushelFactory()
BushelGuestProfile()
BushelHub()
BushelHubIPSW()
BushelHubMacOS()
BushelLibrary()
BushelLogging()
BushelMachine()
BushelMacOSCore()
BushelUT()
BushelVirtualBuddy()
BushelTestUtilities()
},
dependencies: {
DocC()
},
testTargets: {
BushelFoundationTests()
BushelLibraryTests()
BushelMachineTests()
BushelFactoryTests()
BushelUtlitiesTests()
},
swiftSettings: {
StrictConcurrency()
Group("Experimental") {
AccessLevelOnImport()
BitwiseCopyable()
GlobalActorIsolatedTypesUsability()
IsolatedAny()
MoveOnlyPartialConsumption()
NestedProtocols()
NoncopyableGenerics()
RegionBasedIsolation()
TransferringArgsAndResults()
VariadicGenerics()
}
Group("Upcoming") {
FullTypedThrows()
InternalImportsByDefault()
}
}
)
.supportedPlatforms {
WWDC2023()
}
.defaultLocalization(.english)
