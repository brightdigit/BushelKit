//
//  HarvestAuthToken.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

/// Authentication token for Harvest connections
///
/// Represents a time-limited authentication token used to secure
/// communication between the Bushel host and guest VM via the Harvest protocol.
/// Tokens have an expiration date for security purposes.
///
/// ## Usage
/// ```swift
/// let token = HarvestAuthToken(
///   token: "jwt.eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
///   expiresAt: Date().addingTimeInterval(3600) // Expires in 1 hour
/// )
/// ```
///
/// ## Security Considerations
/// - Tokens should be transmitted over secure channels only
/// - Expired tokens should be rejected by the authentication system
/// - Consider implementing token refresh mechanisms for long-running connections
public struct HarvestAuthToken: Codable, Sendable {
  /// The authentication token value
  ///
  /// This is typically a JWT token or similar secure token format.
  /// The token should be treated as opaque by the client and passed
  /// directly to authentication endpoints.
  public let token: String

  /// Token expiration date
  ///
  /// After this date, the token should be considered invalid and
  /// authentication requests using this token should be rejected.
  public let expiresAt: Date

  /// Creates a new authentication token
  ///
  /// - Parameters:
  ///   - token: The token value (typically a JWT or similar secure token)
  ///   - expiresAt: The date when this token expires
  public init(token: String, expiresAt: Date) {
    self.token = token
    self.expiresAt = expiresAt
  }
}
