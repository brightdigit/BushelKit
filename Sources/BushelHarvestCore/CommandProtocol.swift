//
//  CommandProtocol.swift
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

/// Protocol for Harvest commands
///
/// Defines the interface that all Harvest commands must implement.
/// Commands are executable units of work that can be sent between
/// the Bushel host and guest VM via the Harvest protocol.
///
/// ## Implementation Requirements
/// All conforming types must:
/// - Be `Codable` for JSON serialization over the network
/// - Be `Sendable` for safe concurrent access across actor boundaries
/// - Provide a unique `id` for tracking and correlation
/// - Specify a `category` for organization and routing
///
/// ## Usage
/// ```swift
/// struct CustomCommand: HarvestCommandProtocol {
///   let id: UUID
///   let category: CommandCategory
///   let customData: String
///
///   init(customData: String) {
///     self.id = UUID()
///     self.category = .system
///     self.customData = customData
///   }
/// }
/// ```
///
/// For most use cases, the concrete `HarvestCommand` struct provides
/// sufficient functionality without needing custom implementations.
public protocol HarvestCommandProtocol: Codable, Sendable {
  /// Unique identifier for this command
  ///
  /// Used for tracking command execution, logging, and correlation
  /// with responses or events. Should be unique across all commands
  /// in a given communication session.
  var id: UUID { get }

  /// Category that classifies this command
  ///
  /// Used for organizing commands, implementing category-specific
  /// authorization, and routing commands to appropriate handlers.
  var category: CommandCategory { get }
}

/// Command categories for organizing Harvest operations
///
/// Commands are grouped into categories to enable:
/// - Organized routing to specialized command handlers
/// - Category-based authorization and security policies
/// - Logical grouping of related functionality
/// - Easier debugging and monitoring
///
/// ## Categories
/// - `.system` - System-level operations like shutdown, status checks, and configuration
/// - `.file` - File system operations like reading, writing, copying, and directory traversal
/// - `.network` - Network operations like connection management and data transfer
/// - `.clipboard` - Clipboard operations for copy/paste functionality between host and guest
/// - `.remote` - Remote debugging and development tools operations
/// - `.security` - Security operations like authentication, authorization, and access control
public enum CommandCategory: String, Codable, Sendable {
  /// System-level operations (shutdown, status, configuration, etc.)
  case system

  /// File system operations (read, write, copy, directory operations, etc.)
  case file

  /// Network operations (connection management, data transfer, etc.)
  case network

  /// Clipboard operations (copy, paste, clipboard sharing, etc.)
  case clipboard

  /// Remote debugging and development operations (SSH, debugging tools, etc.)
  case remote

  /// Security operations (authentication, authorization, access control, etc.)
  case security
}
