


protocol ImageInstaller {
  func beginInstaller(configuration: MachineConfiguration) throws  -> VirtualInstaller 
  func setupMachine(_ machine: Machine) throws -> MachineConfiguration
}
