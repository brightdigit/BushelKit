//
//  URL+Tilde.swift
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

#if os(Linux) || os(macOS)
  extension URL {
    /// Abbreviate URL with tilde
    ///
    /// ```
    /// +--------+-----------------------------------+
    /// | Input  | /Users/jiachen/Documents/FD/Inbox |
    /// +--------+-----------------------------------+
    ///     |
    ///    \|/
    ///     `
    /// +--------+-----------------------------------+
    /// | Output |       ~/Documents/FD/Inbox        |
    /// +--------+-----------------------------------+
    /// ```
    /// - Author: Jia Chen
    public var abbreviatingWithTilde: String {
      // For this to work properly, we need more than 3 path components.
      //   - 0 : "/"
      //   - 1 : "Users"
      //   - 2 : "user name"
      //   This is required as this may encounter an index out of range if
      //   the path has less than 3 items and it's generally not nice to see
      //   your file path as just "~"
      //
      // Handling if user uses a directory that is not the home directory, for instance,
      //   Shared directories or external drives. We should only abbreviate the home directory.
      //
      // In a case that any of these issues arise, we directly return the full path
      guard
        pathComponents.count > 3,
        pathComponents[1] == "Users"
      else {
        return path
      }

      // pathComponents[1] is the "Users" and pathComponent[2] is the user name. Thus, both of them are
      //   joined together to form the home directory
      let homeDirectory = "/" + pathComponents[1...2].joined(separator: "/")

      // Remove the home directory from the file path
      var abbreviatedPath = path.suffix(path.count - homeDirectory.count)

      // Add the tilde (~) to the file path
      abbreviatedPath = "~" + abbreviatedPath

      return String(abbreviatedPath)
    }

    /// Expanding tilde in URL
    ///
    /// ```
    /// +--------+-----------------------------------+
    /// | Input  |       ~/Documents/FD/Inbox        |
    /// +--------+-----------------------------------+
    ///     |
    ///    \|/
    ///     `
    /// +--------+-----------------------------------+
    /// | Output | /Users/jiachen/Documents/FD/Inbox |
    /// +--------+-----------------------------------+
    /// ```
    /// - Precondition: The input abbreviated path should be from the home directory of the current user
    /// - Author: Jia Chen
    /// - Parameter abbreviatedPath: a `String` path, abbreviated with ~
    /// - Returns: The `URL` if it is able to expand the ~ into a full URL, or `nil` if it is unable do so
    internal static func expandingTilde(from abbreviatedPath: String) -> URL? {
      guard abbreviatedPath.first == "~" else {
        return nil
      }

      // Grab a file path that will definitely contain the "/Users/username" prefix
      let filePath = FileManager.default.homeDirectoryForCurrentUser

      // pathComponents[1] is the "Users" and pathComponent[2] is the user name. Thus, both of them are
      //   joined together to form the home directory
      let homeDirectory = "/" + filePath.pathComponents[1...2].joined(separator: "/")

      // Create a mutable path to work with
      var path = abbreviatedPath

      // Remove the ~ from the file path
      path.removeFirst()

      // Add the home directory to the path
      path = homeDirectory + path

      return URL(fileURLWithPath: path)
    }
  }
#endif
