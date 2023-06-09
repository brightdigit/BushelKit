//
// VirtualMacOSMachineFactory.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelVirtualization
  import Virtualization

  class VirtualMacOSMachineFactory: VirtualMachineFactory {
    let machine: Machine
    let restoreImage: VZMacOSRestoreImage
    var installer: VZMacOSInstaller?
    var state: VirtualMachineBuildingProgress {
      didSet {
        delegate?.factory(self, didChangeState: state)
      }
    }

    weak var delegate: VirtualMachineFactoryDelegate?
    var progressObserver: NSKeyValueObservation?

    init(machine: Machine, restoreImage: VZMacOSRestoreImage) {
      self.machine = machine
      self.restoreImage = restoreImage
      state = .init(id: machine.id, percentCompleted: nil, phase: .notStarted)
    }

    func setState(
      atPhase phase: VirtualMachineBuildingPhase,
      withPercentCompleted percentCompleted: Double? = nil
    ) {
      let id = machine.id
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.state = .init(id: id, percentCompleted: percentCompleted, phase: phase)
      }
    }

    // swiftlint:disable:next function_body_length
    func beginBuild(at url: URL) {
      let machineConfiguration: VZVirtualMachineConfiguration
      setState(atPhase: .building)
      do {
        machineConfiguration = try VZVirtualMachineConfiguration(
          toDirectory: url,
          basedOn: machine.specification,
          withRestoreImage: restoreImage
        )
        try machineConfiguration.validate()
      } catch {
        #warning("Swap for MainActor")
        DispatchQueue.main.async {
          self.setState(atPhase: .savedAt(.failure(error)))
          self.installer = nil
          self.progressObserver = nil
        }
        return
      }

      let virtualMachine = VZVirtualMachine(configuration: machineConfiguration)

      let installer = VZMacOSInstaller(
        virtualMachine: virtualMachine,
        restoringFromImageAt: restoreImage.url
      )
      setState(
        atPhase: .installing,
        withPercentCompleted: installer.progress.fractionCompleted
      )

      self.installer = installer
      installer.install { result in
        self.setState(
          atPhase: .savedAt(result.map { url }),
          withPercentCompleted: installer.progress.fractionCompleted
        )
      }
      progressObserver = installer.progress
        .observe(
          \.fractionCompleted,

          options: [.initial, .new]
        ) { progress, _ in
          self.setState(
            atPhase: .installing,
            withPercentCompleted: progress.fractionCompleted
          )
        }
    }
  }
#endif
