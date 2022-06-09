


#if arch(arm64)
import Virtualization

struct MachineBuilderRange {
  let cpuCountRange : ClosedRange<Int>
  let memoryRange : ClosedRange<UInt64>
  
  private init () {
    self.memoryRange =
    VZVirtualMachineConfiguration.minimumAllowedMemorySize ... VZVirtualMachineConfiguration.maximumAllowedMemorySize
    
    let totalAvailableCPUs = ProcessInfo.processInfo.processorCount
    let virtualCPUCount = totalAvailableCPUs <= 1 ? 1 : totalAvailableCPUs - 1
    let minCpuCount = max(1, VZVirtualMachineConfiguration.minimumAllowedCPUCount)
    let maxCpuCount = min(virtualCPUCount, VZVirtualMachineConfiguration.maximumAllowedCPUCount)
    self.cpuCountRange = .init(uncheckedBounds: (minCpuCount, maxCpuCount))
  }
  
  static let shared : Self = .init()
}
#endif
