//
// MachineInstallationObject.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import Foundation

  class MachineInstallationObject: ObservableObject, VirtualMachineFactoryDelegate {
    @Published var factory: VirtualMachineFactory? {
      didSet {
        DispatchQueue.main.async {
          self.factory?.delegate = self
          self.phaseProgress = self.factory?.state
        }
      }
    }

    @Published var phaseProgress: VirtualMachineBuildingProgress?

    init() {}

    func factory(_: VirtualMachineFactory, didChangeState state: VirtualMachineBuildingProgress) {
      DispatchQueue.main.async {
        self.phaseProgress = state
      }
    }

    func setupInstaller(_ factory: VirtualMachineFactory) {
      Task {
        await MainActor.run {
          self.factory = factory
        }
      }
    }

    func cancel() {
      DispatchQueue.main.async {
        self.factory = nil
      }
    }
  }
#endif
