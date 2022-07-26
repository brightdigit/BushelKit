
import Virtualization
import Combine



struct VirtualMachineConfiguration : MachineConfiguration {
  let vzMachineConfiguration : VZVirtualMachineConfiguration
  let currentURL : URL
}
