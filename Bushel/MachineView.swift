//
//  MachineView.swift
//  Bushel
//
//  Created by Leo Dion on 6/1/22.
//

#if arch(arm64)
import Virtualization
import SwiftUI

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
            let machine : Machine
            do {
            machine = try Machine(builder: self.machineBuilder)
            } catch {
              return
            }
            self.onCompleted(machine)
           
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
#endif
