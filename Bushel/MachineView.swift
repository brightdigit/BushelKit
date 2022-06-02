//
//  MachineView.swift
//  Bushel
//
//  Created by Leo Dion on 6/1/22.
//

import SwiftUI
import Virtualization

struct MachineNetwork {
  enum InterfaceType {
    case bridge
    case NAT
  }
  
  enum MacAddress {
    case string(String)
    case random
  }
  let type : InterfaceType
  let macAddress : MacAddress
}

struct MachineSharedDirectories {
  let url : URL
  let tag : String
}
struct Machine {
  let cpuCount : Int
  let memorySize : UInt64
  let displays : [MachineDisplay]
  let disks : [MachineDisk]
  let networks : [MachineNetwork]
  let sourceImage : LocalImage
  
}
struct MachineDisplay {
  let width : Int
  let height: Int
  let pixelsPerInch : Int
}

struct MachineDisk {
  let url : URL
  let readOnly : Bool
}

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

struct MachineBuilder {
  internal init(name: String? = nil, cpuCount: Int = 1, memorySize: UInt64 = (4 * 1024 * 1024 * 1024), displays: [MachineDisplay] = [MachineDisplay](), disks: [MachineDisk] = [MachineDisk](), sourceImage: LocalImage) {
    
    self.cpuCount = cpuCount
    self.memorySize = memorySize
    self.displays = displays
    self.disks = disks
    self.sourceImage = sourceImage
    self.name = name ?? sourceImage.name
  }
  
  var name : String
  var cpuCount : Int = 1
  var memorySize : UInt64 = (4 * 1024 * 1024 * 1024)
  var displays = [MachineDisplay]()
  var disks = [MachineDisk]()
  var networks = [MachineNetwork]()
  let sourceImage : LocalImage
  
}
extension ClosedRange {
    init<Other: Comparable>(_ other: ClosedRange<Other>, _ transform: (Other) -> Bound) {
        self = transform(other.lowerBound)...transform(other.upperBound)
    }
}
struct MachineView: View {
  @State var machineBuilder : MachineBuilder
  let ranges = MachineBuilderRange.shared
  let onCompleted : (Machine?) -> Void
  init (from image: LocalImage, _ completed: @escaping (Machine?) -> Void) {
    self._machineBuilder = .init(initialValue: .init(sourceImage: image))
    self.onCompleted = completed
  }
  
  var memoryFloat: Binding<Double>{
          Binding<Double>(get: {
              //returns the score as a Double
            return Double(self.machineBuilder.memorySize)
          }, set: {
              //rounds the double to an Int
              
            self.machineBuilder.memorySize = UInt64($0)
          })
      }
  
  var memoryRange : ClosedRange<Double> {
    .init(self.ranges.memoryRange) { value in
      let doubleValue = Double(value)
      print(doubleValue)
      return doubleValue
    }
  }
  var cpuCountFloat: Binding<Double>{
          Binding<Double>(get: {
              //returns the score as a Double
            return Double(self.machineBuilder.cpuCount)
          }, set: {
              //rounds the double to an Int
              
            self.machineBuilder.cpuCount = Int($0)
          })
      }
  
  var cpuCountRange : ClosedRange<Double> {
    .init(self.ranges.cpuCountRange, Double.init)
  }
  
  
  
    var body: some View {
      Form{
        Section{
        TextField("Name", text: self.$machineBuilder.name)
        }
        
          Section{
            Slider(value: self.cpuCountFloat, in: self.cpuCountRange, step: 1.0) {
              Text("CPU Count")
            }
          }
        Section{
        Slider(value: self.memoryFloat, in: self.memoryRange, step: 1.0) {
          Text("Memory")
        }
        }
        
        Section(header: Text("Disks"), content: {
          List{
            Text("Disk")
          }
        })
        
        
        Section(header: Text("Network Adapters"), content: {
          List{
            Text("Disk")
          }
        })
        
        
        Section{
        HStack{
          Button("Build") {
            self.onCompleted(nil)
           
          }
          Button("Cancel") {
            self.onCompleted(nil)
          }
        }
        }
      }.padding()
    }
}

struct MachineView_Previews: PreviewProvider {
    static var previews: some View {
      MachineView(from: .previewModel) { _ in
      }
    }
}
