//
//  SPFirewallDataType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import Foundation

/// A data structure representing Firewall settings.
public struct SPFirewallDataType: Codable, Equatable, Sendable {
  /// The encoding keys for the `SPFirewallDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spfirewallGlobalstate = "spfirewall_globalstate"
    case spfirewallLoggingenabled = "spfirewall_loggingenabled"
    case spfirewallStealthenabled = "spfirewall_stealthenabled"
  }

  /// The name of the firewall settings.
  public let name: String
  /// The global state of the firewall.
  public let spfirewallGlobalstate: String
  /// Whether logging is enabled for the firewall.
  public let spfirewallLoggingenabled: String
  /// Whether stealth mode is enabled for the firewall.
  public let spfirewallStealthenabled: String

  /// Initializes a new `SPFirewallDataType` instance.
  /// - Parameters:
  ///   - name: The name of the firewall settings.
  ///   - spfirewallGlobalstate: The global state of the firewall.
  ///   - spfirewallLoggingenabled: Whether logging is enabled for the firewall.
  ///   - spfirewallStealthenabled: Whether stealth mode is enabled for the firewall.
  public init(
    name: String,
    spfirewallGlobalstate: String,
    spfirewallLoggingenabled: String,
    spfirewallStealthenabled: String
  ) {
    self.name = name
    self.spfirewallGlobalstate = spfirewallGlobalstate
    self.spfirewallLoggingenabled = spfirewallLoggingenabled
    self.spfirewallStealthenabled = spfirewallStealthenabled
  }
}
