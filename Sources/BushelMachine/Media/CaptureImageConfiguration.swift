//
//  CaptureImageConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//

public struct CaptureImageConfiguration: Sendable, Codable {
  public static let `default` = CaptureImageConfiguration(compression: 0.8, fileType: .jpeg)

  public let compression: Double
  public let fileType: ImageFileType
}
