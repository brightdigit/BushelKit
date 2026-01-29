//
//  HarvestCommand.swift
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

/// Base implementation of a Harvest command
///
/// Represents a concrete command that can be executed as part of the Harvest
/// protocol. This is the standard implementation of `HarvestCommandProtocol`
/// that provides basic command functionality with an ID and category.
///
/// ## Usage
/// ```swift
/// // Create a system command
/// let systemCommand = HarvestCommand(category: .system)
///
/// // Create a file command with custom ID
/// let fileCommand = HarvestCommand(
///   id: UUID(),
///   category: .file
/// )
/// ```
///
/// ## Command Categories
/// Commands are organized into categories that group related functionality:
/// - `.system` - System-level operations (shutdown, status, etc.)
/// - `.file` - File system operations (read, write, copy, etc.)
/// - `.network` - Network operations (connect, transfer, etc.)
/// - `.clipboard` - Clipboard operations (copy, paste, etc.)
/// - `.remote` - Remote debugging and development operations
///
/// For custom command implementations, consider extending `HarvestCommandProtocol`
/// directly rather than subclassing this struct.
public struct HarvestCommand: HarvestCommandProtocol {
  /// Unique identifier for this command
  ///
  /// Each command instance gets a unique ID for tracking and correlation.
  /// Automatically generated if not provided.
  public let id: UUID
  
  /// Category that this command belongs to
  ///
  /// Used for organizing commands and potentially implementing
  /// category-specific authorization or routing logic.
  public let category: CommandCategory

  /// Creates a new Harvest command
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the command. Defaults to a new UUID.
  ///   - category: The category this command belongs to
  public init(id: UUID = UUID(), category: CommandCategory) {
    self.id = id
    self.category = category
  }
}
