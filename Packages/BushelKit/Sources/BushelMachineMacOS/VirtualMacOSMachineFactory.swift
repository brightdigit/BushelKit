//
// VirtualMacOSMachineFactory.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Virtualization

  class VirtualMacOSMachineFactory: VirtualMachineFactory {
    let machine: Machine
    let restoreImage: VZMacOSRestoreImage
    var installer: VZMacOSInstaller?
    var state: BushelMachine.VirtualMachineBuildingProgress {
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

    func setState(atPhase phase: VirtualMachineBuildingPhase, withPercentCompleted percentCompleted: Double? = nil) {
      let id = machine.id
      DispatchQueue.main.async {
        self.state = .init(id: id, percentCompleted: percentCompleted, phase: phase)
      }
    }

    fileprivate func getMachineConfigurationURL() throws -> URL {
      if let url = try machine.getMachineConfigurationURL() {
        return url
      } else {
        let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: temporaryURL, withIntermediateDirectories: true)
        return temporaryURL
      }
    }

    func beginBuild() {
      let machineConfigurationURL: URL
      let machineConfiguration: VZVirtualMachineConfiguration

      setState(atPhase: .building)
      do {
        machineConfigurationURL = try getMachineConfigurationURL()
        machineConfiguration = try VZVirtualMachineConfiguration(toDirectory: machineConfigurationURL, basedOn: machine, withRestoreImage: restoreImage)
        try machineConfiguration.validate()
      } catch {
        DispatchQueue.main.async {
          self.setState(atPhase: .completed(.failure(error)))
          self.installer = nil
          self.progressObserver = nil
        }
        return
      }

      let virtualMachine = VZVirtualMachine(configuration: machineConfiguration)

      let installer = VZMacOSInstaller(virtualMachine: virtualMachine, restoringFromImageAt: restoreImage.url)
      setState(atPhase: .installing, withPercentCompleted: installer.progress.fractionCompleted)

      self.installer = installer
      installer.install { result in
        self.setState(atPhase: .completed(result.map { machineConfigurationURL }), withPercentCompleted: installer.progress.fractionCompleted)
      }
      progressObserver = installer.progress.observe(\.fractionCompleted,
                                                    options: [.initial, .new]) { progress, _ in
        self.setState(atPhase: .installing, withPercentCompleted: progress.fractionCompleted)
      }
    }
  }
#endif
