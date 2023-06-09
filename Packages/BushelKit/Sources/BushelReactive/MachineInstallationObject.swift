//
// MachineInstallationObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelVirtualization
  import Foundation

  public class MachineInstallationObject: ObservableObject, VirtualMachineFactoryDelegate {
    @Published var factory: VirtualMachineFactory? {
      didSet {
        #warning("Swap for MainActor")
        DispatchQueue.main.async {
          self.factory?.delegate = self
          self.phaseProgress = self.factory?.state
        }
      }
    }

    @Published public var phaseProgress: VirtualMachineBuildingProgress?

    public init() {}

    public func factory(_: VirtualMachineFactory, didChangeState state: VirtualMachineBuildingProgress) {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.phaseProgress = state
      }
    }

    public func setupInstaller(_ factory: VirtualMachineFactory) {
      Task {
        await MainActor.run {
          self.factory = factory
        }
      }
    }

    public func cancel() {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.factory = nil
      }
    }
  }
#endif
