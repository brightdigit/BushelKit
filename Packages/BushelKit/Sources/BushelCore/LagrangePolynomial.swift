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

  public func transform(_ value: Double) -> Double {
    let newValue = isInverse ? (maxX - value) : value

    // swiftlint:disable identifier_name
    let x0 = point0.x, x1 = point1.x, x2 = point2.x
    let y0 = point0.y, y1 = point1.y, y2 = point2.y
    // swiftlint:enable identifier_name

    let term0 = y0 * ((newValue - x1) * (newValue - x2)) / ((x0 - x1) * (x0 - x2))
    let term1 = y1 * ((newValue - x0) * (newValue - x2)) / ((x1 - x0) * (x1 - x2))
    let term2 = y2 * ((newValue - x0) * (newValue - x1)) / ((x2 - x0) * (x2 - x1))

    return term0 + term1 + term2
  }
}
