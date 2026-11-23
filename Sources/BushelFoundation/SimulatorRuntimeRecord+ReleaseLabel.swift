//
//  SimulatorRuntimeRecord+ReleaseLabel.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

@available(*, deprecated, message: "Moved to SwoopKit.")
extension SimulatorRuntimeRecord {
  /// A runtime's release stage, with its number for betas and release candidates.
  ///
  /// Labels order Beta 1 < … < Beta N < RC 1 < … < RC N < final. Only compare labels of
  /// the same platform and version.
  ///
  /// Encoded as its ``description``: "Beta 4", "RC 1" or "Final".
  public enum ReleaseLabel: Sendable, Hashable, Comparable, CustomStringConvertible {
    /// Beta N (N ≥ 1).
    case beta(Int)
    /// Release candidate N (N ≥ 1).
    case releaseCandidate(Int)
    /// The final release.
    case final

    private static let finalText = "Final"
    private static let betaText = "Beta"
    private static let releaseCandidateText = "RC"

    /// Whether this is a beta or release candidate.
    public var isPrerelease: Bool {
      self != .final
    }

    /// "Beta 4", "RC 1" or "Final".
    public var description: String {
      switch self {
      case .beta(let number):
        "\(Self.betaText) \(number)"
      case .releaseCandidate(let number):
        "\(Self.releaseCandidateText) \(number)"
      case .final:
        Self.finalText
      }
    }

    /// Where the label sorts: stage first, then its number.
    private var sortKey: (stage: Int, number: Int) {
      switch self {
      case .beta(let number):
        (0, number)
      case .releaseCandidate(let number):
        (1, number)
      case .final:
        (2, 0)
      }
    }

    /// Parses a ``description`` ("Beta 4", "RC 1" or "Final").
    ///
    /// - Parameter description: The label's text.
    /// - Returns: `nil` for any other text, including a number below 1.
    public init?(_ description: String) {
      if description == Self.finalText {
        self = .final
        return
      }
      let parts = description.split(separator: " ", omittingEmptySubsequences: false)
      guard parts.count == 2, let number = Int(parts[1]), number >= 1 else {
        return nil
      }
      switch parts[0] {
      case Self.betaText:
        self = .beta(number)
      case Self.releaseCandidateText:
        self = .releaseCandidate(number)
      default:
        return nil
      }
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.sortKey < rhs.sortKey
    }
  }
}

@available(*, deprecated, message: "Moved to SwoopKit.")
extension SimulatorRuntimeRecord.ReleaseLabel: Codable {
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    let text = try container.decode(String.self)
    guard let label = Self(text) else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Not a release label: \(text)"
      )
    }
    self = label
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(description)
  }
}
