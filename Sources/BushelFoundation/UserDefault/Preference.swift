//
//  Preference.swift
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

public import RadiantKit

public enum Preference {
  /// An enum representing machine shutdown action preferences.
  public enum MachineShutdownAction: AppStored {
    /// The underlying value type for the machine shutdown action preference.
    public typealias Value = MachineShutdownActionOption?
    /// The key type used to store the machine shutdown action preference.
    public static let keyType: KeyType = .reflecting
  }

  /// An enum representing session close button action preferences.
  public enum SessionCloseButtonAction: AppStored {
    /// The underlying value type for the session close button action preference.
    public typealias Value = SessionCloseButtonActionOption?
    /// The key type used to store the session close button action preference.
    public static let keyType: KeyType = .reflecting
  }
}
