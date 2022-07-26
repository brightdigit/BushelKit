


struct MockInstaller : ImageInstaller {
  func setupMachine(_ machine: Machine) throws -> MachineConfiguration{
    fatalError()
  }
  
  func beginInstaller(configuration: MachineConfiguration) throws -> VirtualInstaller {
    fatalError()
  }
  
  
}
