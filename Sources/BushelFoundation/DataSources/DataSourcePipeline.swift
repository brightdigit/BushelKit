//
//  DataSourcePipeline.swift
//  BushelCloud
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// Orchestrates fetching data from all sources with deduplication and relationship resolution
public struct DataSourcePipeline: Sendable {
  // MARK: - Configuration

  public struct Options: Sendable {
    public var includeRestoreImages: Bool = true
    public var includeXcodeVersions: Bool = true
    public var includeSwiftVersions: Bool = true
    public var includeBetaReleases: Bool = true
    public var includeAppleDB: Bool = true
    public var includeTheAppleWiki: Bool = true
    public var force: Bool = false
    public var specificSource: String?

    public init(
      includeRestoreImages: Bool = true,
      includeXcodeVersions: Bool = true,
      includeSwiftVersions: Bool = true,
      includeBetaReleases: Bool = true,
      includeAppleDB: Bool = true,
      includeTheAppleWiki: Bool = true,
      force: Bool = false,
      specificSource: String? = nil
    ) {
      self.includeRestoreImages = includeRestoreImages
      self.includeXcodeVersions = includeXcodeVersions
      self.includeSwiftVersions = includeSwiftVersions
      self.includeBetaReleases = includeBetaReleases
      self.includeAppleDB = includeAppleDB
      self.includeTheAppleWiki = includeTheAppleWiki
      self.force = force
      self.specificSource = specificSource
    }
  }

  // MARK: - Dependencies

  let configuration: FetchConfiguration

  // MARK: - Initialization

  public init(
    configuration: FetchConfiguration = FetchConfiguration.loadFromEnvironment()
  ) {
    self.configuration = configuration
  }

  // MARK: - Results

  public struct FetchResult: Sendable {
    public var restoreImages: [RestoreImageRecord]
    public var xcodeVersions: [XcodeVersionRecord]
    public var swiftVersions: [SwiftVersionRecord]

    public init(
      restoreImages: [RestoreImageRecord],
      xcodeVersions: [XcodeVersionRecord],
      swiftVersions: [SwiftVersionRecord]
    ) {
      self.restoreImages = restoreImages
      self.xcodeVersions = xcodeVersions
      self.swiftVersions = swiftVersions
    }
  }

  // MARK: - Public API

  /// Fetch all data from configured sources
  public func fetch(options: Options = Options()) async throws -> FetchResult {
    var restoreImages: [RestoreImageRecord] = []
    var xcodeVersions: [XcodeVersionRecord] = []
    var swiftVersions: [SwiftVersionRecord] = []

    do {
      restoreImages = try await fetchRestoreImages(options: options)
    } catch {
      print("⚠️  Restore images fetch failed: \(error)")
      throw error
    }

    do {
      xcodeVersions = try await fetchXcodeVersions(options: options)
      // Resolve XcodeVersion → RestoreImage references now that we have both datasets
      xcodeVersions = resolveXcodeVersionReferences(xcodeVersions, restoreImages: restoreImages)
    } catch {
      print("⚠️  Xcode versions fetch failed: \(error)")
      throw error
    }

    do {
      swiftVersions = try await fetchSwiftVersions(options: options)
    } catch {
      print("⚠️  Swift versions fetch failed: \(error)")
      throw error
    }

    return FetchResult(
      restoreImages: restoreImages,
      xcodeVersions: xcodeVersions,
      swiftVersions: swiftVersions
    )
  }

  // MARK: - Metadata Tracking

  /// Check if a source should be fetched based on throttling rules
  private func shouldFetch(
    source: String,
    recordType: String,
    force: Bool
  ) async -> (shouldFetch: Bool, metadata: DataSourceMetadata?) {
    // If force flag is set, always fetch
    guard !force else { return (true, nil) }

    // No CloudKit service in BushelCloudData - always fetch
    // CloudKit metadata checking will be re-added in Phase 4
    return (true, nil)
  }

  /// Wrap a fetch operation with metadata tracking
  private func fetchWithMetadata<T>(
    source: String,
    recordType: String,
    options: Options,
    fetcher: () async throws -> [T]
  ) async throws -> [T] {
    // Check if we should skip this source based on --source flag
    if let specificSource = options.specificSource, specificSource != source {
      print("   ⏭️  Skipping \(source) (--source=\(specificSource))")
      return []
    }

    // Check throttling
    let (shouldFetch, existingMetadata) = await shouldFetch(
      source: source,
      recordType: recordType,
      force: options.force
    )

    if !shouldFetch {
      if let metadata = existingMetadata {
        let timeSinceLastFetch = Date().timeIntervalSince(metadata.lastFetchedAt)
        let minInterval = configuration.minimumInterval(for: source) ?? 0
        let timeRemaining = minInterval - timeSinceLastFetch
        print(
          "   ⏰ Skipping \(source) (last fetched \(Int(timeSinceLastFetch / 60))m ago, wait \(Int(timeRemaining / 60))m)"
        )
      }
      return []
    }

    // Perform the fetch with timing
    let startTime = Date()
    var fetchError: Error?
    var recordCount = 0

    do {
      let results = try await fetcher()
      recordCount = results.count

      // Metadata sync disabled in BushelCloudData (no CloudKit dependency)
      // Will be re-enabled in Phase 4 when using BushelKit

      return results
    } catch {
      fetchError = error

      // Metadata sync disabled in BushelCloudData (no CloudKit dependency)
      // Will be re-enabled in Phase 4 when using BushelKit

      throw error
    }
  }

  // MARK: - Private Fetching Methods

  private func fetchRestoreImages(options: Options) async throws -> [RestoreImageRecord] {
    guard options.includeRestoreImages else {
      return []
    }

    var allImages: [RestoreImageRecord] = []

    // Fetch from ipsw.me
    do {
      let ipswImages = try await fetchWithMetadata(
        source: "ipsw.me",
        recordType: "RestoreImage",
        options: options
      ) {
        try await IPSWFetcher().fetch()
      }
      allImages.append(contentsOf: ipswImages)
      if !ipswImages.isEmpty {
        print("   ✓ ipsw.me: \(ipswImages.count) images")
      }
    } catch {
      print("   ⚠️  ipsw.me failed: \(error)")
      throw error
    }

    // Fetch from MESU
    do {
      let mesuImages = try await fetchWithMetadata(
        source: "mesu.apple.com",
        recordType: "RestoreImage",
        options: options
      ) {
        if let image = try await MESUFetcher().fetch() {
          return [image]
        } else {
          return []
        }
      }
      allImages.append(contentsOf: mesuImages)
      if !mesuImages.isEmpty {
        print("   ✓ MESU: \(mesuImages.count) image")
      }
    } catch {
      print("   ⚠️  MESU failed: \(error)")
      throw error
    }

    // Fetch from AppleDB
    if options.includeAppleDB {
      do {
        let appleDBImages = try await fetchWithMetadata(
          source: "appledb.dev",
          recordType: "RestoreImage",
          options: options
        ) {
          try await AppleDBFetcher().fetch()
        }
        allImages.append(contentsOf: appleDBImages)
        if !appleDBImages.isEmpty {
          print("   ✓ AppleDB: \(appleDBImages.count) images")
        }
      } catch {
        print("   ⚠️  AppleDB failed: \(error)")
        // Don't throw - continue with other sources
      }
    }

    // Fetch from Mr. Macintosh (betas)
    if options.includeBetaReleases {
      do {
        let mrMacImages = try await fetchWithMetadata(
          source: "mrmacintosh.com",
          recordType: "RestoreImage",
          options: options
        ) {
          try await MrMacintoshFetcher().fetch()
        }
        allImages.append(contentsOf: mrMacImages)
        if !mrMacImages.isEmpty {
          print("   ✓ Mr. Macintosh: \(mrMacImages.count) images")
        }
      } catch {
        print("   ⚠️  Mr. Macintosh failed: \(error)")
        throw error
      }
    }

    // Fetch from TheAppleWiki
    if options.includeTheAppleWiki {
      do {
        let wikiImages = try await fetchWithMetadata(
          source: "theapplewiki.com",
          recordType: "RestoreImage",
          options: options
        ) {
          try await TheAppleWikiFetcher().fetch()
        }
        allImages.append(contentsOf: wikiImages)
        if !wikiImages.isEmpty {
          print("   ✓ TheAppleWiki: \(wikiImages.count) images")
        }
      } catch {
        print("   ⚠️  TheAppleWiki failed: \(error)")
        throw error
      }
    }

    // Deduplicate by build number (keep first occurrence)
    let preDedupeCount = allImages.count
    let deduped = deduplicateRestoreImages(allImages)
    print("   📦 Deduplicated: \(preDedupeCount) → \(deduped.count) images")
    return deduped
  }

  private func fetchXcodeVersions(options: Options) async throws -> [XcodeVersionRecord] {
    guard options.includeXcodeVersions else {
      return []
    }

    let versions = try await fetchWithMetadata(
      source: "xcodereleases.com",
      recordType: "XcodeVersion",
      options: options
    ) {
      try await XcodeReleasesFetcher().fetch()
    }

    if !versions.isEmpty {
      print("   ✓ xcodereleases.com: \(versions.count) versions")
    }

    return deduplicateXcodeVersions(versions)
  }

  private func fetchSwiftVersions(options: Options) async throws -> [SwiftVersionRecord] {
    guard options.includeSwiftVersions else {
      return []
    }

    let versions = try await fetchWithMetadata(
      source: "swiftversion.net",
      recordType: "SwiftVersion",
      options: options
    ) {
      try await SwiftVersionFetcher().fetch()
    }

    if !versions.isEmpty {
      print("   ✓ swiftversion.net: \(versions.count) versions")
    }

    return deduplicateSwiftVersions(versions)
  }

  // MARK: - Deduplication

  /// Deduplicate restore images by build number, keeping the most complete record
  internal func deduplicateRestoreImages(_ images: [RestoreImageRecord]) -> [RestoreImageRecord] {
    var uniqueImages: [String: RestoreImageRecord] = [:]

    for image in images {
      let key = image.buildNumber

      if let existing = uniqueImages[key] {
        // Keep the record with more complete data
        uniqueImages[key] = mergeRestoreImages(existing, image)
      } else {
        uniqueImages[key] = image
      }
    }

    return Array(uniqueImages.values).sorted { $0.releaseDate > $1.releaseDate }
  }

  /// Merge two restore image records, preferring non-empty values
  ///
  /// This method handles backfilling missing data from different sources:
  /// - SHA-256 hashes from AppleDB fill in empty values from ipsw.me
  /// - File sizes and SHA-1 hashes are similarly backfilled
  /// - Signing status follows MESU authoritative rules
  internal func mergeRestoreImages(
    _ first: RestoreImageRecord,
    _ second: RestoreImageRecord
  ) -> RestoreImageRecord {
    var merged = first

    // Backfill missing hashes and file size from second record
    if !second.sha256Hash.isEmpty && first.sha256Hash.isEmpty {
      merged.sha256Hash = second.sha256Hash
    }
    if !second.sha1Hash.isEmpty && first.sha1Hash.isEmpty {
      merged.sha1Hash = second.sha1Hash
    }
    if second.fileSize > 0 && first.fileSize == 0 {
      merged.fileSize = second.fileSize
    }

    // Merge isSigned with priority rules:
    // 1. MESU is always authoritative (Apple's real-time signing status)
    // 2. For non-MESU sources, prefer the most recently updated
    // 3. If both have same update time (or both nil) and disagree, prefer false

    if first.source == "mesu.apple.com" && first.isSigned != nil {
      merged.isSigned = first.isSigned  // MESU first is authoritative
    } else if second.source == "mesu.apple.com" && second.isSigned != nil {
      merged.isSigned = second.isSigned  // MESU second is authoritative
    } else {
      // Neither is MESU, compare update timestamps
      let firstUpdated = first.sourceUpdatedAt
      let secondUpdated = second.sourceUpdatedAt

      if let firstDate = firstUpdated, let secondDate = secondUpdated {
        // Both have dates - use the more recent one
        if secondDate > firstDate && second.isSigned != nil {
          merged.isSigned = second.isSigned
        } else if firstDate >= secondDate && first.isSigned != nil {
          merged.isSigned = first.isSigned
        } else if first.isSigned != nil {
          merged.isSigned = first.isSigned
        } else {
          merged.isSigned = second.isSigned
        }
      } else if secondUpdated != nil && second.isSigned != nil {
        // Second has date, first doesn't - prefer second
        merged.isSigned = second.isSigned
      } else if firstUpdated != nil && first.isSigned != nil {
        // First has date, second doesn't - prefer first
        merged.isSigned = first.isSigned
      } else if first.isSigned != nil && second.isSigned != nil {
        // Both have values but no dates - prefer false when they disagree
        if first.isSigned == second.isSigned {
          merged.isSigned = first.isSigned
        } else {
          merged.isSigned = false
        }
      } else if second.isSigned != nil {
        merged.isSigned = second.isSigned
      } else if first.isSigned != nil {
        merged.isSigned = first.isSigned
      }
    }

    // Combine notes
    if let secondNotes = second.notes, !secondNotes.isEmpty {
      if let firstNotes = first.notes, !firstNotes.isEmpty {
        merged.notes = "\(firstNotes); \(secondNotes)"
      } else {
        merged.notes = secondNotes
      }
    }

    return merged
  }

  /// Resolve XcodeVersion → RestoreImage references by mapping version strings to record names
  ///
  /// Parses the temporary REQUIRES field in notes and matches it to RestoreImage versions
  internal func resolveXcodeVersionReferences(
    _ versions: [XcodeVersionRecord],
    restoreImages: [RestoreImageRecord]
  ) -> [XcodeVersionRecord] {
    // Build lookup table: version → RestoreImage recordName
    var versionLookup: [String: String] = [:]
    for image in restoreImages {
      // Support multiple version formats: "14.2.1", "14.2", "14"
      let version = image.version
      versionLookup[version] = image.recordName

      // Also add short versions for matching (e.g., "14.2.1" → "14.2")
      let components = version.split(separator: ".")
      if components.count > 1 {
        let shortVersion = components.prefix(2).joined(separator: ".")
        versionLookup[shortVersion] = image.recordName
      }
    }

    return versions.map { version in
      var resolved = version

      // Parse notes field to extract requires string
      guard let notes = version.notes else { return resolved }

      let parts = notes.split(separator: "|")
      var requiresString: String?
      var notesURL: String?

      for part in parts {
        if part.hasPrefix("REQUIRES:") {
          requiresString = String(part.dropFirst("REQUIRES:".count))
        } else if part.hasPrefix("NOTES_URL:") {
          notesURL = String(part.dropFirst("NOTES_URL:".count))
        }
      }

      // Try to extract version number from requires (e.g., "macOS 14.2" → "14.2")
      if let requires = requiresString {
        // Match version patterns like "14.2", "14.2.1", etc.
        let versionPattern = #/(\d+\.\d+(?:\.\d+)?(?:\.\d+)?)/#
        if let match = requires.firstMatch(of: versionPattern) {
          let extractedVersion = String(match.1)
          if let recordName = versionLookup[extractedVersion] {
            resolved.minimumMacOS = recordName
          }
        }
      }

      // Restore clean notes field
      resolved.notes = notesURL

      return resolved
    }
  }

  /// Deduplicate Xcode versions by build number
  internal func deduplicateXcodeVersions(_ versions: [XcodeVersionRecord]) -> [XcodeVersionRecord] {
    var uniqueVersions: [String: XcodeVersionRecord] = [:]

    for version in versions {
      let key = version.buildNumber
      if uniqueVersions[key] == nil {
        uniqueVersions[key] = version
      }
    }

    return Array(uniqueVersions.values).sorted { $0.releaseDate > $1.releaseDate }
  }

  /// Deduplicate Swift versions by version number
  internal func deduplicateSwiftVersions(_ versions: [SwiftVersionRecord]) -> [SwiftVersionRecord] {
    var uniqueVersions: [String: SwiftVersionRecord] = [:]

    for version in versions {
      let key = version.version
      if uniqueVersions[key] == nil {
        uniqueVersions[key] = version
      }
    }

    return Array(uniqueVersions.values).sorted { $0.releaseDate > $1.releaseDate }
  }
}
