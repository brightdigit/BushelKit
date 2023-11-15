//
// LagrangePolynomial.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
public struct LagrangePolynomial: Codable, RawRepresentable {
  public typealias RawValue = String

  public static let `default`: LagrangePolynomial = .init(
    point0: .init(x: 1.0, y: 1.0),
    point1: .init(x: 2.0, y: 5.0),
    point2: .init(x: 20.0, y: 600.0),
    isInverse: true
  )

  private let point0: CGPoint
  private let point1: CGPoint
  private let point2: CGPoint

  private let isInverse: Bool

  private var maxX: Double {
    max(point0.x, point1.x, point2.x)
  }

  public var rawValue: String {
    let encoded = try? JSON.encoder.encode(self)
    let string = encoded.flatMap { String(data: $0, encoding: .utf8) }
    return string ?? "{}"
  }

  internal init(point0: CGPoint, point1: CGPoint, point2: CGPoint, isInverse: Bool) {
    self.point0 = point0
    self.point1 = point1
    self.point2 = point2
    self.isInverse = isInverse
  }

  public init?(rawValue: String) {
    let data = rawValue.data(using: .utf8)
    let decoded = data.flatMap { try? JSON.decoder.decode(Self.self, from: $0) }

    guard let decoded else {
      return nil
    }

    self = decoded
  }

  // swiftlint:disable:next large_tuple
  static func termForValue(_ newValue: Double, points: (CGPoint, CGPoint, CGPoint)) -> Double {
    // swiftlint:disable:next line_length
    points.0.y * ((newValue - points.0.x) * (newValue - points.2.x)) / ((points.0.x - points.1.x) * (points.0.x - points.2.x))
  }

  public func transform(_ value: Double) -> Double {
    let newValue = isInverse ? (maxX - value) : value

    return [
      Self.termForValue(newValue, points: (point0, point1, point2)),
      Self.termForValue(newValue, points: (point1, point2, point0)),
      Self.termForValue(newValue, points: (point2, point0, point1))
    ].reduce(0, +)
  }
}
