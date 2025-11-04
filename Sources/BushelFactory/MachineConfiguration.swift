//
//  MachineConfiguration.swift
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

public import BushelMachine
internal import Foundation

extension MachineConfiguration {
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  public init(
    configurable: some MachineConfigurable
  ) async throws {
    guard let machineSystem = await configurable.machineSystem else {
      throw ConfigurationError.missingSystemManager
    }

    guard let image = await configurable.selectedBuildImage.image else {
      throw ConfigurationError.missingRestoreImageID
    }

    guard let specificationConfiguration = await configurable.specificationConfiguration else {
      throw ConfigurationError.missingSpecifications
    }

    self.init(
      restoreImage: image,
      machineSystem: machineSystem,
      specificationConfiguration: specificationConfiguration
    )
  }

  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  public init(
    restoreImage: any InstallerImage,
    machineSystem: any MachineSystem,
    specificationConfiguration: SpecificationConfiguration<some Any>
  ) {
    let storage = MachineStorageSpecification(
      label: machineSystem.defaultStorageLabel,
      size: .init(specificationConfiguration.storage)
    )
    let cpuCount = Int(specificationConfiguration.cpuCount)
    let memory = Int(specificationConfiguration.memory)

    self.init(
      restoreImageFile: restoreImage.identifier,
      vmSystemID: machineSystem.id,
      snapshotSystemID: machineSystem.defaultSnapshotSystem,
      operatingSystemVersion: restoreImage.operatingSystemVersion,
      buildVersion: restoreImage.buildVersion,
      storage: [storage],
      cpuCount: cpuCount,
      memory: memory
    )
  }
}
