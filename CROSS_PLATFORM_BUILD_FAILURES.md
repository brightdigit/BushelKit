# Cross-Platform Build Failure Analysis - BushelKit

**CI Run:** https://github.com/brightdigit/BushelKit/actions/runs/21293146878  
**Date:** January 23, 2026  
**Affected Platforms:** WASM, Android, Windows

## Executive Summary

BushelKit is experiencing identical build failures on Android and Windows platforms due to missing POSIX APIs and bookmark functionality. WASM builds fail due to RadiantKit's use of unavailable atomic file operations. All three platforms require platform-specific conditional compilation fixes.

## Build Status by Platform

| Platform | Status | Primary Issue |
|----------|--------|---------------|
| **macOS** | ✅ Pass | Native platform, full support |
| **Linux** | ✅ Pass | POSIX compliant |
| **iOS/watchOS/visionOS** | ✅ Pass | Apple platforms supported |
| **WASM** | ❌ Fail | RadiantKit atomic operations |
| **Android** | ❌ Fail | POSIX APIs + bookmark methods |
| **Windows** | ❌ Fail | POSIX APIs + bookmark methods |

## Detailed Error Analysis

### 🔴 WASM Build Errors

**File:** `.build/checkouts/RadiantKit/Sources/RadiantDocs/Primitives/InitializablePackageOptions.swift:84`

```swift
error: 'atomic' is unavailable: atomic writing is unavailable in WASI because temporary files are not supported
84 |     if options.contains(.atomic) { dataOptions.insert(.atomic) }
   |                                                        ^~~~~~~
```

**Root Cause:** WASI doesn't support temporary files, making atomic write operations impossible.

---

### 🔴 Android Build Errors

#### Error 1: Missing POSIX File Permissions
**File:** `Sources/BushelUtilities/Extensions/FileManager.swift`

```swift
Line 47: error: cannot find 'S_IRUSR' in scope
Line 47: error: cannot find 'S_IWUSR' in scope  
Line 49: error: cannot find 'errno' in scope
Line 53: error: cannot find 'ftruncate' in scope
Line 58: error: cannot find 'close' in scope
```

#### Error 2: Bookmark API Differences
**File:** `Sources/BushelUtilities/Extensions/URL.swift`

```swift
Line 60: error: incorrect argument label in call 
         (have 'resolvingBookmarkData:bookmarkDataIsStale:', 
          expected 'resolvingSecurityScopeBookmarkData:bookmarkDataIsStale:')
Line 72: error: value of type 'URL' has no member 'bookmarkData'
```

---

### 🔴 Windows Build Errors

Windows has **identical errors** to Android:

#### Error 1: Missing POSIX APIs
**File:** `Sources/BushelUtilities/Extensions/FileManager.swift`

```swift
Line 47: error: cannot find 'S_IRUSR' in scope
Line 47: error: cannot find 'S_IWUSR' in scope
Line 53: error: cannot find 'ftruncate' in scope
```

#### Error 2: Bookmark API Issues
**File:** `Sources/BushelUtilities/Extensions/URL.swift`

```swift
Line 60: error: incorrect argument label (same as Android)
Line 72: error: value of type 'URL' has no member 'bookmarkData'
```

---

## Root Cause Analysis

### Common Issues (Android & Windows)

1. **POSIX API Availability**
   - Both platforms lack standard POSIX file permission constants (`S_IRUSR`, `S_IWUSR`)
   - Missing standard Unix file operations (`ftruncate`, `close`)
   - Different errno access patterns

2. **Foundation API Differences**
   - Bookmark APIs have different method signatures
   - Some Foundation extensions not available on non-Apple platforms

### WASM-Specific Issues

- RadiantKit dependency not WASI-aware
- Attempts to use filesystem features unavailable in WebAssembly environment

---

## Proposed Solutions

### Solution 1: Fix POSIX Compatibility (FileManager.swift)

```swift
// Sources/BushelUtilities/Extensions/FileManager.swift

#if os(Windows) || os(Android)
  // Define missing POSIX constants
  #if os(Windows)
    import WinSDK
    let S_IRUSR: Int32 = 0x0100  // _S_IREAD
    let S_IWUSR: Int32 = 0x0080  // _S_IWRITE
  #elseif os(Android)
    let S_IRUSR: mode_t = 0o400
    let S_IWUSR: mode_t = 0o200
  #endif
#endif

extension FileManager {
  public func createFile(atPath path: String, withSize size: FileSize) throws {
    _ = self.createFile(atPath: path, contents: nil)
    
    #if os(Windows)
      // Windows-specific implementation using WinSDK
      let handle = CreateFileW(
        path.withCString(encodedAs: UTF16.self) { $0 },
        GENERIC_READ | GENERIC_WRITE,
        0,
        nil,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        nil
      )
      
      guard handle != INVALID_HANDLE_VALUE else {
        throw CreationError(code: Int(GetLastError()), source: .open)
      }
      
      var distanceToMove = LARGE_INTEGER()
      distanceToMove.QuadPart = LONGLONG(size)
      
      guard SetFilePointerEx(handle, distanceToMove, nil, FILE_BEGIN) else {
        CloseHandle(handle)
        throw CreationError(code: Int(GetLastError()), source: .ftruncate)
      }
      
      guard SetEndOfFile(handle) else {
        CloseHandle(handle)
        throw CreationError(code: Int(GetLastError()), source: .ftruncate)
      }
      
      CloseHandle(handle)
      
    #elseif os(Android)
      // Android-specific implementation
      let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
      guard diskFd >= 0 else {
        throw CreationError(code: Int(errno), source: .open)
      }
      defer { close(diskFd) }
      
      guard ftruncate(diskFd, off_t(size)) == 0 else {
        throw CreationError(code: Int(errno), source: .ftruncate)
      }
      
    #else
      // Standard Unix implementation
      let diskFd = open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR)
      guard diskFd > 0 else {
        throw CreationError(code: Int(errno), source: .open)
      }
      
      var result = ftruncate(diskFd, size)
      guard result == 0 else {
        throw CreationError(code: Int(result), source: .ftruncate)
      }
      
      result = close(diskFd)
      guard result == 0 else {
        throw CreationError(code: Int(result), source: .close)
      }
    #endif
  }
}
```

### Solution 2: Fix Bookmark API (URL.swift)

```swift
// Sources/BushelUtilities/Extensions/URL.swift

extension URL {
  public init(resolvingBookmarkDataWithSecurityScope data: Data) throws {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
      var bookmarkDataIsStale = false
      try self.init(
        resolvingBookmarkData: data,
        options: .withSecurityScope,
        bookmarkDataIsStale: &bookmarkDataIsStale
      )
    #else
      // Non-Apple platforms don't support bookmarks
      throw URLError(.unsupportedURL, userInfo: [
        NSLocalizedDescriptionKey: "Bookmark data is not supported on this platform"
      ])
    #endif
  }
  
  public func bookmarkData() throws -> Data {
    #if os(macOS)
      return try bookmarkData(options: .withSecurityScope)
    #elseif os(iOS) || os(watchOS) || os(tvOS)
      return try bookmarkData(options: [])
    #else
      // Non-Apple platforms don't support bookmarks
      throw URLError(.unsupportedURL, userInfo: [
        NSLocalizedDescriptionKey: "Bookmark data is not supported on this platform"
      ])
    #endif
  }
}
```

### Solution 3: Fix WASM/RadiantKit Issue

**Option A: Fork RadiantKit**
Create a fork with WASI conditionals:

```swift
// RadiantKit/Sources/RadiantDocs/Primitives/InitializablePackageOptions.swift
public init(options: InitializablePackageOptions) {
  var dataOptions: Data.WritingOptions = []
  
  #if !arch(wasm32)
    if options.contains(.atomic) { 
      dataOptions.insert(.atomic) 
    }
  #endif
  
  if options.contains(.withoutOverwriting) { 
    dataOptions.insert(.withoutOverwriting) 
  }
  
  if options.contains(.noFileProtection) { 
    dataOptions.insert(.noFileProtection) 
  }
  
  self = dataOptions
}
```

**Option B: Conditional RadiantKit Dependency**
Modify Package.swift to exclude RadiantKit from WASM:

```swift
// Package.swift
dependencies: [
  .product(
    name: "RadiantKit",
    package: "RadiantKit",
    condition: .when(platforms: [.macOS, .iOS, .watchOS, .tvOS, .linux])
  )
]
```

### Solution 4: Fix Android Workflow

Remove invalid parameter from `.github/workflows/BushelKit.yml` line 78:

```diff
strategy:
  fail-fast: false
  matrix:
    api-level: [28, 33, 34]
-   swift-version: [swift-6.2-release]  # DELETE THIS LINE
```

---

## Implementation Plan

### Phase 1: Immediate Fixes (Day 1)
- [ ] Fix Android workflow configuration
- [ ] Add platform conditionals to FileManager.swift
- [ ] Add platform conditionals to URL.swift
- [ ] Test on Linux to ensure no regression

### Phase 2: Dependency Fixes (Day 2-3)
- [ ] Fork RadiantKit and add WASI support
- [ ] Submit PR to upstream RadiantKit
- [ ] Update Package.swift with conditional dependencies

### Phase 3: Testing & Validation (Day 4-5)
- [ ] Test Android builds with multiple API levels
- [ ] Test Windows builds on windows-2022 and windows-2025
- [ ] Test WASM builds with both standard and embedded configurations
- [ ] Update CI to allow experimental platform failures

### Phase 4: Documentation (Day 6)
- [ ] Create platform support matrix in README
- [ ] Document platform-specific limitations
- [ ] Add cross-compilation guide

---

## Testing Commands

```bash
# Test fixes locally
swift build --configuration debug

# Test Android
swift build --destination android-arm64 --configuration debug

# Test WASM
swift build --triple wasm32-unknown-wasi --configuration debug

# Test Windows (on Windows)
swift build --configuration debug

# Run tests with verbose output
swift test --configuration debug --verbose
```

---

## Success Metrics

- [ ] All platforms compile without errors
- [ ] Core functionality works on Linux/macOS
- [ ] Experimental platforms (Android/Windows/WASM) build successfully
- [ ] CI pipeline completes without failures
- [ ] Documentation clearly states platform limitations

---

## Platform Support Matrix (Post-Fix)

| Component | macOS | Linux | iOS | Android | Windows | WASM |
|-----------|-------|-------|-----|---------|---------|------|
| Core Framework | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| File Operations | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| Bookmarks | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| VM Management | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| RadiantKit | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |

Legend: ✅ Full support | ⚠️ Limited support | ❌ Not available