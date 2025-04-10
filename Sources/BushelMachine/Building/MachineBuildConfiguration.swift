//
//  MachineBuildConfiguration.swift
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

internal import BushelFoundation
internal import Foundation

///  Used by the `MachineSystem` to build a new virtual machine.

public struct MachineBuildConfiguration<RestoreImageType: Sendable>: Sendable {
  /// Hardware configuration of the machine.
  public let configuration: MachineConfiguration

  /// The install image to use for the vritual machine.
  public let restoreImage: RestoreImageType

  /// Creates a build configuration for a new virtual machine.
  /// - Parameters:
  ///   - configuration: The hardware configuration.
  ///   - restoreImage: The install image.
  public init(configuration: MachineConfiguration, restoreImage: RestoreImageType) {
    self.configuration = configuration
    self.restoreImage = restoreImage
  }
}
