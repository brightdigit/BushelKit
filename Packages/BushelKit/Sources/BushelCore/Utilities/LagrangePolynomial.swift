//
//  LagrangePolynomial.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation

public struct LagrangePolynomial: Codable, RawRepresentable, Sendable {
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
