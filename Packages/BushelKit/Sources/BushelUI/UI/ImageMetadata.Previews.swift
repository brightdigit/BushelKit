//
// ImageMetadata.Previews.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

//
//  File.swift
//
//
//  Created by Leo Dion on 7/31/22.
//
import BushelMachine
import BushelMachineMacOS
import Foundation
import SwiftUI

public extension ImageMetadata {
  enum Previews {
    public static let previewModel: ImageMetadata = .init(isImageSupported: true, buildVersion: "12312SA", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 0, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16_000_000_000, lastModified: .init(), url: URL(string: "https://updates.cdn-apple.com/2022SummerSeed/fullrestores/012-30346/9DD787A7-044B-4650-86D4-84E80B6B9C36/UniversalMac_13.0_22A5286j_Restore.ipsw")!, vmSystem: .macOS)

    public static let venturaBeta3 = ImageMetadata(isImageSupported: true, buildVersion: "22A5295h", operatingSystemVersion: OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0), sha256: SHA256(base64Encoded: "LbNHYPVKVKpwXUmqZInQ1Nr9gaYni4IKjelvzpl72LI=")!, contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679_094_144.0), url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!, vmSystem: .macOS)

    public static let monterey = ImageMetadata(isImageSupported: true, buildVersion: "21F79", operatingSystemVersion: OperatingSystemVersion(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: SHA256(base64Encoded: "H56SH3e7y1z3gCY4nW9zMc3WdbwIH/rHf8AEBafoIrM=")!, contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679_276_356.959953), url: URL(string: "file:///var/folders/_z/7dqmnmzj0k1_57ctrgqrdq840000gn/T/com.brightdigit.BshIll/D0FB9B1B-0ED1-4721-AD0D-8A81C08A5ED2.ipsw")!, vmSystem: .macOS)
  }
}

struct RestoreImageLibraryDocumentView_Previews: PreviewProvider {
  static let data: [RestoreImageLibraryItemFile] = [
    .init(name: "Ventura Beta 3", metadata: .Previews.venturaBeta3),
    .init(name: "Montery 12.4", metadata: .Previews.monterey)
  ]
  static var previews: some View {
    RestoreImageLibraryDocumentView(document: .constant(RestoreImageLibraryDocument(library: .init(items: Self.data))), selected: .init(name: "Ventura Beta 3", metadata: .Previews.venturaBeta3))
  }
}
