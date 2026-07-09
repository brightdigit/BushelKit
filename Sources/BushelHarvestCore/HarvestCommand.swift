//
//  HarvestCommand.swift
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

/// Base implementation of a Harvest command
///
/// Represents a concrete command that can be executed as part of the Harvest
/// protocol. This is the standard implementation of `HarvestCommandProtocol`
/// that provides complete command functionality with ID, category, payload, and metadata.
///
/// ## Usage
/// ```swift
/// // Create a system ping command
/// let pingCommand = HarvestCommand.system(.ping)
///
/// // Create an SSH enable command
/// let sshCommand = HarvestCommand.remote(.ssh(.enable))
/// ```
///
/// ## Command Categories
/// Commands are organized into categories that group related functionality:
/// - `.system` - System-level operations (shutdown, status, etc.)
/// - `.file` - File system operations (read, write, copy, etc.)
/// - `.network` - Network operations (connect, transfer, etc.)
/// - `.clipboard` - Clipboard operations (copy, paste, etc.)
/// - `.remote` - Remote debugging and development operations
/// - `.security` - Security operations (authentication, authorization, etc.)
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
  /// Used for organizing commands and implementing
  /// category-specific authorization or routing logic.
  public let category: CommandCategory

  /// Command payload containing the specific command data
  public let payload: CommandPayload

  /// Target machine identifier (optional)
  public let machineID: UInt64?

  /// Timestamp when the command was created
  public let timestamp: Date

  /// Command version for compatibility checking
  public let version: Int

  /// Additional metadata for command processing
  public var metadata: [String: String]?

  /// Human-readable name of the command
  public var name: String {
    switch payload {
    case .system(let systemCmd):
      switch systemCmd {
      case .ping: return "system.ping"
      case .status: return "system.status"
      case .shutdown: return "system.shutdown"
      case .restart: return "system.restart"
      }
    case .remote(let remoteCmd):
      switch remoteCmd {
      case .ssh(let sshCmd):
        switch sshCmd {
        case .enable: return "remote.ssh.enable"
        case .disable: return "remote.ssh.disable"
        case .status: return "remote.ssh.status"
        }
      case .status: return "remote.status"
      }
    case .security(let securityCmd):
      switch securityCmd {
      case .authenticate: return "security.authenticate"
      case .authorize: return "security.authorize"
      case .status: return "security.status"
      }
    case .file: return "file.operation"
    case .network: return "network.operation"
    case .clipboard: return "clipboard.operation"
    }
  }

  /// Creates a new Harvest command
  ///
  /// - Parameters:
  ///   - id: Unique identifier for the command. Defaults to a new UUID.
  ///   - category: The category this command belongs to
  ///   - payload: The command payload data
  ///   - machineID: Optional target machine identifier
  ///   - timestamp: Creation timestamp. Defaults to current time.
  ///   - version: Command version for compatibility checking. Defaults to 1.
  ///   - metadata: Additional metadata for command processing. Defaults to nil.
  public init(
    id: UUID = UUID(),
    category: CommandCategory,
    payload: CommandPayload,
    machineID: UInt64? = nil,
    timestamp: Date = Date(),
    version: Int = 1,
    metadata: [String: String]? = nil
  ) {
    self.id = id
    self.category = category
    self.payload = payload
    self.machineID = machineID
    self.timestamp = timestamp
    self.version = version
    self.metadata = metadata
  }

  // MARK: - Static Factory Methods

  /// Creates a system command
  /// - Parameter command: The system command to create
  /// - Returns: A new HarvestCommand with system category
  public static func system(_ command: SystemCommand) -> HarvestCommand {
    HarvestCommand(
      category: .system,
      payload: .system(command)
    )
  }

  /// Creates a remote access command
  /// - Parameter command: The remote access command to create
  /// - Returns: A new HarvestCommand with remote category
  public static func remote(_ command: RemoteAccessCommand) -> HarvestCommand {
    HarvestCommand(
      category: .remote,
      payload: .remote(command)
    )
  }

  /// Creates a security command
  /// - Parameter command: The security command to create
  /// - Returns: A new HarvestCommand with security category
  public static func security(_ command: SecurityCommand) -> HarvestCommand {
    HarvestCommand(
      category: .security,
      payload: .security(command)
    )
  }

  /// Creates a file operation command
  /// - Parameter operation: The file operation description
  /// - Returns: A new HarvestCommand with file category
  public static func file(_ operation: String) -> HarvestCommand {
    HarvestCommand(
      category: .file,
      payload: .file(operation)
    )
  }

  /// Creates a network operation command
  /// - Parameter operation: The network operation description
  /// - Returns: A new HarvestCommand with network category
  public static func network(_ operation: String) -> HarvestCommand {
    HarvestCommand(
      category: .network,
      payload: .network(operation)
    )
  }

  /// Creates a clipboard operation command
  /// - Parameter operation: The clipboard operation description
  /// - Returns: A new HarvestCommand with clipboard category
  public static func clipboard(_ operation: String) -> HarvestCommand {
    HarvestCommand(
      category: .clipboard,
      payload: .clipboard(operation)
    )
  }
}
