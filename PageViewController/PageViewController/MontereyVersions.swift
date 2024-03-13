//
//  MontereyVersions.swift
//  PageViewController
//
//  Created by Leo Dion on 3/5/24.
//

import Foundation

private let versions = """
12.0.1;21A559;October 25, 2021
12.1;21C52;December 13, 2021
12.2;21D49;January 26, 2022
12.2.1;21D62;February 10, 2022
12.3;21E230;March 14, 2022
12.3.1;21E258;March 31, 2022
12.4;21F2092;June 16, 2022
12.5;21G72;July 20, 2022
12.5.1;21G83;August 17, 2022
12.6;21G115;September 12, 2022
12.6.1;21G217;October 24, 2022
12.6.2;21G320;December 13, 2022
12.6.3;21G419;January 23, 2023
12.6.4;21G526;March 27, 2023
12.6.5;21G531;April 10, 2023
12.6.6;21G646;May 18, 2023
12.6.7;21G651;June 21, 2023
12.6.8;21G725;July 24, 2023
12.6.9;21G726;September 11, 2023
12.7;21G816;September 21, 2023
12.7.1;21G920;October 25, 2023
12.7.2;21G1974;December 11, 2023
12.7.3;21H1015;January 22, 2024
"""
  .components(separatedBy: .newlines)
  .map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}
  .filter{!$0.isEmpty}
  .map(BuildVersion.init(line:))


extension OperatingSystemVersion : Hashable, Equatable, CustomStringConvertible {
  public var description: String {
    [majorVersion, minorVersion, patchVersion].map(String.init).joined(separator: ".")
  }
  
  private static func componentsFrom(_ string: String) -> [Int] {
    string.components(separatedBy: ".").compactMap(Int.init)
  }

  public init?(components: [Int])  {
    guard components.count == 2 || components.count == 3 else {
      return nil
    }

    self.init(
      majorVersion: components[0],
      minorVersion: components[1],
      patchVersion: components.count == 3 ? components[2] : 0
    )
  }

  public init?(string: String)  {
    let components = Self.componentsFrom(string)
    self.init(components: components)
  }
  
  public static func < (lhs: OperatingSystemVersion, rhs: OperatingSystemVersion) -> Bool {
    guard lhs.majorVersion == rhs.majorVersion else {
      return lhs.majorVersion < rhs.majorVersion
    }
    guard lhs.minorVersion == rhs.minorVersion else {
      return lhs.minorVersion < rhs.minorVersion
    }
    return lhs.patchVersion < rhs.patchVersion
  }

  static func singleStringDecodingContainer(
    from decoder: any Decoder
  ) -> (any SingleValueDecodingContainer)? {
    try? decoder.singleValueContainer()
  }

  public static func == (
    lhs: OperatingSystemVersion,
    rhs: OperatingSystemVersion
  ) -> Bool {
    lhs.majorVersion == rhs.majorVersion &&
      lhs.minorVersion == rhs.minorVersion &&
      lhs.patchVersion == rhs.patchVersion
  }


  public func hash(into hasher: inout Hasher) {
    majorVersion.hash(into: &hasher)
    minorVersion.hash(into: &hasher)
    patchVersion.hash(into: &hasher)
  }
}
struct BuildVersion : Identifiable, Hashable, Equatable{
  
  internal init(build: String, releaseDate: Date, semver: OperatingSystemVersion) {
    self.build = build
    self.releaseDate = releaseDate
    self.semver = semver
  }
  
  static let dateFormatter = { formatString in
    let formatter = DateFormatter()
    formatter.dateFormat = formatString
    return formatter
  }("MMM d, yyyy")
  
  let build : String
  let releaseDate : Date
  let semver : OperatingSystemVersion
  
  var id : String {
    return build
  }
  
  static let montereyVersions : [BuildVersion] = { versions in
    let montereyVersions = versions.compactMap{$0}
    assert(montereyVersions.count == versions.count)
    return montereyVersions
  }(versions)
}

extension BuildVersion  {
  internal init?(line : String) {
    let components = line.components(separatedBy: CharacterSet(charactersIn: ";"))
    guard components.count == 3 else {
      return nil
    }
    guard let semver = OperatingSystemVersion(string: components[0]) else {
      return nil
    }
    let build = components[1]
    guard let releaseDate = Self.dateFormatter.date(from: components[2]) else {
      return nil
    }
    self.init(build: build, releaseDate: releaseDate, semver: semver)
  }
}
