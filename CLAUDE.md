# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BushelKit** is an open-source Swift framework that provides the core components for Bushel, a macOS virtual machine application for developers. It's designed to be modular and reusable, allowing developers to build macOS virtual machine applications and command-line tools.

**Tech Stack:**
- Swift 6.0+ (with Swift Package Manager)
- Supports: macOS, iOS, watchOS, tvOS, and Linux
- Uses async/await for concurrency
- Sendable-conforming types for thread safety
- Modern Swift features: noncopyable generics, variadic generics

**Requirements:**
- **macOS:** Xcode 16.0+, Swift 6.0+, macOS 14+ deployment target
- **Linux:** Ubuntu 20.04+, Swift 6.0+

## Common Development Commands

### Building and Testing

```bash
# Build the package
swift build

# Run all tests
swift test

# Run tests with code coverage
swift test --enable-code-coverage

# Build documentation
swift package generate-documentation --platform "name=macos,version=15.1" --transform-for-static-hosting --hosting-base-path "swift-docc" --disable-indexing --enable-experimental-combined-documentation
```

### Linting and Formatting

The project uses Mint to manage linting tools (SwiftLint, swift-format, StringsLint). Linting configuration is in `.swiftlint.yml`, `.swift-format`, and `.stringslint.yml`.

```bash
# Run all linters and formatters
./Scripts/lint.sh

# Lint in strict mode (used in CI)
LINT_MODE=STRICT ./Scripts/lint.sh

# Format only (skip lint checks)
FORMAT_ONLY=1 ./Scripts/lint.sh
```

**Mint tools used:**
- `swiftlang/swift-format@602.0.0` - Code formatting
- `realm/SwiftLint@0.61.0` - Swift linting
- `dral3x/StringsLint@0.1.9` - String linting
- `peripheryapp/periphery@3.2.0` - Unused code detection

### Package Structure Generation

**IMPORTANT:** The `Package.swift` file is **generated** from source files in the `Package/` directory. Do not edit `Package.swift` directly.

```bash
# Regenerate Package.swift from Package/ source files
./Scripts/package.sh .

# Regenerate with specific Swift tools version
./Scripts/package.sh --version 6.0 .

# Regenerate with minimized output
./Scripts/package.sh --minimize .
```

The package definition uses a custom result builder DSL defined in `Package/Sources/` that allows for declarative product and target definitions. After modifying files in `Package/Sources/`, always regenerate `Package.swift`.

## High-Level Architecture

The BushelKit framework follows a layered, modular architecture organized around domain concerns. The design emphasizes:

1. **Separation of Concerns** - Each module has a specific responsibility
2. **Protocol-Based Design** - Heavy use of protocols for abstraction and extensibility
3. **Async-First** - Comprehensive async/await throughout the codebase
4. **Type Safety** - Strong typing with enums, structs, and generics
5. **Cross-Platform Support** - Abstraction layers to support multiple platforms

## Core Modules Overview

### Foundation Layer

**BushelFoundation** (Core abstractions)
- Location: `/Sources/BushelFoundation/`
- Purpose: Provides fundamental types and abstractions for virtual machine management
- Key Types:
  - `VirtualizationData` - Represents essential VM data (machine identifier, hardware model)
  - `MachineIdentifier` - Unique 64-bit identifier for virtual machines
  - `HardwareModel` - Hardware configuration descriptor
  - `Version` - Version management and comparison
  - `VMSystemError` - Virtual machine system error types
  - `ImageMetadata` - Metadata about OS images
  - `BookmarkError` - File system bookmark errors
  
**BushelUtilities** (Helper utilities)
- Location: `/Sources/BushelUtilities/`
- Purpose: Common utilities used across the framework
- Key Features:
  - `ByteCountFormatter` - Human-readable file size formatting
  - `DirectoryExists` - File system utilities
  - `EnvironmentProperty` - Environment variable access
  - `IPv6Address` - Network address handling
  - `Task` extensions - Async task utilities
  - Extensions for standard types (Array, URL, String, etc.)

**BushelLogging** (Logging abstraction)
- Location: `/Sources/BushelLogging/`
- Purpose: Unified logging interface
- Key Types:
  - `Loggable` protocol - Types that support logging
  - Structured logging capabilities

### Domain-Specific Modules

**BushelMachine** (Virtual machine management)
- Location: `/Sources/BushelMachine/`
- Purpose: Core VM lifecycle and state management
- Key Types:
  - `Machine` protocol - Defines VM behavior (start, stop, pause, resume, snapshot, etc.)
  - `MachineState` enum - VM state machine (stopped, running, paused, error, starting, pausing, resuming, stopping, saving, restoring)
  - `MachineConfiguration` - VM configuration specification
  - `MachineSystem` protocol - Platform-specific VM management (e.g., macOS Virtualization)
  - `MachineBuilder` - Builder pattern for VM creation
  - `MachineRegistration` - VM registry entry
  - `MachineChange` - State change notifications
  - Subdirectories:
    - `Building/` - Machine creation and builder logic
    - `Configuration/` - Configuration management
    - `Media/` - Video/image capture handling
    - `Snapshots/` - Snapshot management
    - `FileVersionSnapshotter/` - File versioning system

**BushelLibrary** (Image library management)
- Location: `/Sources/BushelLibrary/`
- Purpose: Management of OS installation images and libraries
- Key Types:
  - `Library` - Collection of `LibraryImageFile` items
  - `LibrarySystem` protocol - Platform-specific image library operations
  - `LibraryImageFile` - Represents a stored OS image
  - `LibraryError` - Library-specific errors
  - `LibraryFile` - File wrapper for library items

**BushelFactory** (VM creation factory)
- Location: `/Sources/BushelFactory/`
- Purpose: High-level factory for creating and configuring VMs
- Key Types:
  - `MachineConfiguration` - Configuration builder (integrates with BushelMachine)
  - `SpecificationConfiguration` - Template-based configuration
  - `InstallerImage` - OS installer image reference
  - `ReleaseCollection` - Collection of available OS releases
  - `CalculationParameters` - Compute specifications (CPU, memory, storage)

**BushelMacOSCore** (macOS-specific implementation)
- Location: `/Sources/BushelMacOSCore/`
- Purpose: macOS Virtualization framework integration
- Key Types:
  - `MacOSVirtualization` - macOS-specific implementation of `MachineSystem`
  - `MacOSRelease` - macOS release information
  - `VZMacOSRestoreImage` - Virtualization framework restore image wrapper
  - `VMSystemID` - System identifier for macOS machines

### Platform-Specific & Hub Modules

**BushelHub** (Hub/aggregation services)
- Location: `/Sources/BushelHub/`
- Purpose: Central management and aggregation of library and machine resources

**BushelHubIPSW** (IPSW image management)
- Location: `/Sources/BushelHubIPSW/`
- Purpose: Integration with IPSW (Apple's signed OS image format)

**BushelHubMacOS** (macOS-specific hub services)
- Location: `/Sources/BushelHubMacOS/`
- Purpose: macOS-specific hub implementations

**BushelGuestProfile** (Guest VM configuration)
- Location: `/Sources/BushelGuestProfile/`
- Purpose: Guest OS configuration and profile management

**BushelVirtualBuddy** (Companion/helper services)
- Location: `/Sources/BushelVirtualBuddy/`
- Purpose: Supporting services for VM management

### Wax Layers (Platform Bridges)

Wax modules provide platform-specific wrappers and extensions for core modules:

- **BushelFoundationWax** - macOS/platform-specific extensions to BushelFoundation
- **BushelLibraryWax** - macOS/platform-specific library operations
- **BushelMachineWax** - macOS/platform-specific machine operations

**Purpose of Wax Pattern:** Isolates platform-specific code from core logic, allowing the same interfaces to work across platforms with different implementations.

### Utility & Support Modules

**BushelDocs** (Documentation)
- Location: `/Sources/BushelDocs/`
- Purpose: DocC documentation bundle

**BushelUT** (Unit Testing)
- Location: `/Sources/BushelUT/`
- Purpose: Testing utilities and test helpers

**BushelTestUtilities** (Test Support)
- Location: `/Sources/BushelTestUtilities/`
- Purpose: Mock objects and test doubles for testing

**BushelArgs** (CLI Arguments)
- Location: `/Sources/BushelArgs/`
- Purpose: Command-line argument parsing and handling

**bushel** (Executable)
- Location: Package entry in `/Package/Sources/Products/BushelCommand.swift`
- Purpose: Command-line tool executable using BushelArgs

## Code Organization

### Directory Structure

```
BushelKit/
├── Sources/                          # Main source code
│   ├── BushelFoundation/            # Core VM abstractions
│   │   ├── Configuration/           # Config file paths and managers
│   │   ├── MachineBuilding/         # Build request types
│   │   └── SigVerification/         # Image signature verification
│   ├── BushelMachine/               # VM lifecycle management
│   │   ├── Building/                # Machine builder implementations
│   │   ├── Configuration/           # Setup configuration
│   │   ├── Media/                   # Screen recording/capture
│   │   └── Snapshots/               # VM state snapshots
│   ├── BushelLibrary/               # Image library management
│   ├── BushelFactory/               # VM factory & specifications
│   ├── BushelMacOSCore/             # macOS Virtualization integration
│   ├── BushelUtilities/             # Shared utilities
│   │   ├── Extensions/              # Standard type extensions
│   │   └── FileManager/             # File system utilities
│   ├── BushelLogging/               # Logging abstractions
│   ├── *Wax/                        # Platform-specific layers
│   └── [Other domain modules...]
├── Tests/                           # Integration tests
│   ├── BushelFoundationTests/
│   ├── BushelMachineTests/
│   ├── BushelLibraryTests/
│   ├── BushelFactoryTests/
│   └── [Other test suites...]
├── Package/                         # Swift Package definition
│   └── Sources/
│       ├── Products/                # Product definitions
│       ├── Dependencies/            # Package dependencies
│       ├── Targets/                 # Target definitions
│       └── Platforms/               # Platform specifications
└── Package.swift                    # Main package manifest
```

### Package Definition Pattern

**CRITICAL:** BushelKit uses a **generated** `Package.swift` file. The source files are in `Package/Sources/` and the generation is done via `./Scripts/package.sh`.

The package uses a custom Swift Package builder pattern with result builders:

```swift
// Example product definition in Package/Sources/Products/
struct BushelMachine: Product, Target {
  var dependencies: any Dependencies {
    BushelFoundation()
    BushelDocs()
    BushelLogging()
  }
}

// Products are collected in Package/Sources/Index.swift
let package = Package(
  name: "BushelKit",
  entries: {
    BushelCommand()      // Executable
    BushelFoundation()   // Libraries
    BushelMachine()
    // ... other products
  },
  testTargets: {
    BushelFoundationTests()
    BushelMachineTests()
    // ... other tests
  }
)
```

**Key Pattern Features:**
- Uses result builders (@ProductsBuilder, @DependencyBuilder) for declarative syntax
- Custom Protocol hierarchy: `Product`, `Target`, `Dependencies`
- Automatic dependency resolution and transitive dependency management
- Swift Settings applied globally (async, generics features, etc.)
- **Always regenerate `Package.swift` after editing files in `Package/Sources/`**

## Architectural Patterns

### 1. Protocol-Based Design

The framework heavily uses protocols for abstraction:

```swift
public protocol Machine: Loggable, Sendable {
  var machineIdentifer: UInt64? { get }
  var initialConfiguration: MachineConfiguration { get }
  func start() async throws
  func stop() async throws
  // ... more methods
}

public protocol MachineSystem: Sendable {
  associatedtype RestoreImageType: Sendable
  func createBuilder(...) async throws -> any MachineBuilder
  func machine(at url: URL, ...) async throws -> MachineRegistration
}

public protocol LibrarySystem: Sendable {
  var id: VMSystemID { get }
  func metadata(fromURL url: URL, verifier: any SigVerifier) async throws -> ImageMetadata
}
```

**Benefits:**
- Multiple implementations per protocol (e.g., macOS, Linux, testable mocks)
- Loose coupling between modules
- Easy testing via mock implementations

### 2. Builder Pattern

Used extensively for complex object creation:

```swift
// MachineBuilder protocol defines the construction process
public protocol MachineBuilder: Sendable {
  // Build machine step-by-step
}

// MachineSystem creates builders for specific platforms
let builder = try await macOSSystem.createBuilder(for: configuration, at: url)
```

### 3. State Machine Pattern

`MachineState` enum implements state management:

```swift
public enum MachineState: Int, Sendable {
  case stopped = 0
  case running = 1
  case paused = 2
  case starting = 4
  case pausing = 5
  case resuming = 6
  case stopping = 7
  // ... transitions defined by Machine protocol methods
}
```

### 4. Async-First Design

All I/O operations are async:

```swift
// VM operations
func start() async throws
func pause() async throws
func stop() async throws
func beginSnapshot() throws -> SnapshotPaths
func finishedWithSnapshot(_ snapshot: Snapshot, by difference: SnapshotDifference) async

// Configuration retrieval
var updatedConfiguration: MachineConfiguration { get async }
```

### 5. Sendable Types

Types are designed to be thread-safe:

```swift
public struct VirtualizationData: Sendable { ... }
public protocol Machine: Sendable { ... }
public enum MachineState: Sendable { ... }
```

### 6. Generic Programming with Associated Types

Flexible implementations via associated types:

```swift
public protocol MachineSystem: Sendable {
  associatedtype RestoreImageType: Sendable
  func restoreImage(from: any InstallerImage) async throws -> RestoreImageType
}
```

### 7. Data/Set Abstraction Pattern

Abstracts different data sources:

```swift
package protocol VirtualizationDataSet {
  func data(from name: KeyPath<any VirtualizationData.Paths, String>) throws -> Data
}

// Can be implemented by:
// - Filesystem directories
// - Network sources
// - In-memory data
// - Test fixtures
```

### 8. Extensions for Features

Core types extended with features (following Swift conventions):

```swift
extension Machine {
  func saveCaptureVideo(with closure: ...) async rethrows -> RecordedVideo
  func deleteCapturedVideoWithID(_ id: UUID) async throws
}

extension MachineSystem {
  func createBuilder(for configuration: MachineSetupConfiguration, ...) async throws -> any MachineBuilder
}
```

## Dependency Flow

The module dependency graph (top to bottom):

```
bushel (executable)
  └── BushelArgs
        └── [depends on various modules]

BushelCommand (executable)
  └── BushelArgs

BushelFactory
  ├── BushelFoundation
  ├── BushelMachine
  ├── BushelLibrary
  └── BushelLogging

BushelMachine
  ├── BushelFoundation
  ├── BushelDocs
  └── BushelLogging

BushelLibrary
  ├── BushelLogging
  ├── BushelFoundation
  ├── BushelMacOSCore
  └── RadiantKit (external)

BushelFoundation
  ├── BushelUtilities
  ├── OSVer (external)
  └── RadiantKit (external)

BushelUtilities
  └── OSVer (external)

BushelMacOSCore
  └── [Foundation, macOS-specific]
```

## Key Data Structures

### VirtualizationData
Encapsulates core VM data that must persist:
```swift
public struct VirtualizationData: Sendable {
  public let machineIdentifier: MachineIdentifier
  public let hardwareModel: HardwareModel
}
```

### MachineConfiguration
Complete VM specification:
```swift
struct MachineConfiguration {
  let restoreImageFile: any InstallerImage identifier
  let vmSystemID: VMSystemID
  let snapshotSystemID: SnapshotterID
  let operatingSystemVersion: OSVer
  let buildVersion: String
  let storage: [MachineStorageSpecification]
  let cpuCount: Int
  let memory: Int
}
```

### Library
Manages collections of VM images:
```swift
public struct Library: Codable, Equatable, Sendable {
  public var items: [LibraryImageFile]
}
```

## Testing Architecture

BushelKit has comprehensive test coverage organized by module:

- **BushelFoundationTests** - Core abstractions testing
- **BushelMachineTests** - VM state and lifecycle testing
- **BushelLibraryTests** - Library operations testing
- **BushelFactoryTests** - Factory and configuration testing
- **BushelUtlitiesTests** - Utility function testing

Tests use:
- Mock objects from BushelTestUtilities
- Protocol conformances for testing
- Async test support

## Error Handling

The framework uses typed errors following Swift conventions:

- `VMSystemError` - Virtual machine system errors
- `MachineError` - Machine-specific errors with detailed context
- `LibraryError` - Library operation errors
- `BuilderError` - Machine building process errors
- `BookmarkError` - File system bookmark errors

Errors include detailed context and recovery suggestions.

## Platform Support

The framework abstracts platform differences:

1. **macOS** - Primary target with full virtualization support
2. **iOS/watchOS/tvOS** - Limited support (library operations only)
3. **Linux** - Community support for core modules

Platform abstraction achieved through:
- Wax layers for platform-specific code
- Protocol-based platform implementations
- Conditional compilation where needed

## Performance Considerations

1. **Async/Await Throughout** - Non-blocking operations for long-running tasks (VM operations, image loading)
2. **Lazy Loading** - Configuration and metadata loaded on-demand
3. **Snapshots** - Efficient VM state snapshots for quick restore
4. **Sendable Types** - Safe concurrent access without locks

## Documentation

- **DocC Bundles** - Each major module has associated DocC documentation
- **Inline Documentation** - Comprehensive doc comments on public APIs
- **Tutorials** - Planned tutorials for common workflows (roadmap shows v2.x releases will add these)

## Development Practices

- **Swift 6.0+** - Latest Swift features with strict concurrency checking
- **Strict Compiler Flags** - Various safety flags enabled in Package.swift
- **Code Formatting** - .swiftformat and .swiftlint configuration
- **CI/CD** - GitHub Actions workflows

### CI/CD Pipeline

The project uses GitHub Actions with multiple workflows:

1. **BushelKit.yml** - Main CI workflow
   - Builds on Ubuntu (Swift 6.0, 6.1, 6.2, nightly builds)
   - Builds on macOS (multiple Xcode versions, iOS, watchOS, visionOS simulators)
   - Runs linting (calls `./Scripts/lint.sh`)
   - Generates and uploads DocC documentation
   - Uploads code coverage to Codecov

2. **claude.yml** - Claude Code integration workflow
   - Triggers on issue comments, PR comments containing `@claude`
   - Requires `CLAUDE_CODE_OAUTH_TOKEN` secret
   - Allows the `claude` bot to trigger workflows

3. **claude-code-review.yml** - Automated code review
4. **codeql.yml** - CodeQL security scanning

**Important Notes:**
- Commit messages containing `[skip ci]` or `ci skip` will skip CI runs
- Coverage is tracked per platform/Swift version with flags
- The main branch triggers documentation deployment to BushelDocs repository

## Summary

BushelKit is a well-architected, modular framework following Swift best practices:

1. **Modular Design** - Clear separation of concerns with independent, composable modules
2. **Protocol-Driven** - Extensive use of protocols for flexibility and testability
3. **Async-First** - Modern concurrent programming with async/await
4. **Type-Safe** - Strong typing with enums, structs, and generics
5. **Platform-Aware** - Abstractions for cross-platform support while enabling platform-specific optimizations
6. **Test-Focused** - Comprehensive test coverage and mock infrastructure
7. **Well-Documented** - DocC bundles and inline documentation

The framework is designed to be both a complete solution for Bushel's needs and a reusable library for developers building macOS VM applications.
