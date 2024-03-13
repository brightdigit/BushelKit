//
//  SpecificationConfigurationView.swift
//  PageViewController
//
//  Created by Leo Dion on 3/5/24.
//

import SwiftUI

let defaultMarkdown = """
Praeter urbe adspexit si clavam lumina Enipeus passurae diris de legit velocior.
Ortus alis torvae iniuria: caelaverat est.

- Cetera non tepidum
- Quam iactavit cum cutem sequentia euntem
- Pleno penetravit supplex appellant submersum raptis cuius
- Inque gratia ire desint inquit arquato pacem
- Sanguine fer laudatve
"""

struct SpecificationTemplate : Identifiable, Equatable {
  internal init(name: String, systemImageName: String, descriptionMarkdown: String = defaultMarkdown, memoryWithin: @escaping (Float, Float) -> Float, cpuWithin: @escaping (Float, Float) -> Float) {
    self.name = name
    self.systemImageName = systemImageName
    self.descriptionMarkdown = descriptionMarkdown
    self.memoryWithin = memoryWithin
    self.cpuWithin = cpuWithin
  }
  
//  internal init(name: String, systemImageName: String, descriptionMarkdown: String = defaultMarkdown) {
//    self.name = name
//    self.systemImageName = systemImageName
//    self.descriptionMarkdown = descriptionMarkdown
//  }
  
  let name : String
  let systemImageName : String
  let descriptionMarkdown : String
  
  let memoryWithin : (Float, Float) -> Float
  let cpuWithin : (Float, Float) -> Float
  
  var id : String {
    return name
  }
  
  
  
  static let options : [SpecificationTemplate] = [
    .init(
      name: "basic",
      systemImageName: "apple.terminal",
      memoryWithin: min,
      cpuWithin: min
    ),
    .init(
      name: "developer",
      systemImageName: "hammer.fill",
      memoryWithin: { a, b in
        return (a + b) / 2
      },
      cpuWithin: { a, b in
        return (a + b) / 2
      }
    ),
    .init(
      name: "maximum",
      systemImageName: "bolt.fill",
      memoryWithin: max,
      cpuWithin: max
    )
  ]
}


struct SpecificationConfigurationView: View {
  @State var name : String = "new-machine"
  @State var template: SpecificationTemplate?
  @State var cpuCount : Float = 1
  @State var memory : Int64 = Self.memoryValue(forIndex: 1)
  @State var memoryIndex : Float = 1
  
  @State var storage : Int64 = Self.storageValue(forIndex: 1)
  @State var storageIndex : Float = 1
  
  
  static func storageValue(forIndex index: Float) -> Int64 {
    Int64(1 << Int(index))
  }
  
  static func memoryValue(forIndex index: Float) -> Int64 {
    Int64(Self.memoryValue(forIndex: Int(index)))
  }
  
  static func memoryValue(forIndex index: Int) -> Int {
    guard index > 0 else {
      return 0
    }
    
    let factor = ((index - 1) / 4)
    let increment = (1 << factor) * 8 * 1073741824
    return memoryValue(forIndex: index - 1) + increment
  }

  
  static let  minimumMemory : Float = (8 * 1024 * 1024 * 1024)
  static let  maximumMemory : Float = (192 * 1024 * 1024 * 1024)
    var body: some View {
      Form {
          LabeledContent("Specifications") {
            HStack{
              ForEach(SpecificationTemplate.options) { option in
                Button(action: {
                  self.template = option
                }, label: {
                  
                  VStack{
                    Image(systemName: option.systemImageName).resizable().aspectRatio(contentMode: .fit).frame(width: 40.0, height: 40.0)
                    Text(option.name.localizedCapitalized)
                  }.opacity(self.template == option ? 1.0 : 0.8).padding()
                }).buttonStyle(.plain)
              }
            }
          }
          LabeledContent("CPUs") {
            Slider(value: self.$cpuCount, in: 1...5, step: 1.0)
            TextField("CPUs", value: self.$cpuCount, format: .number).labelsHidden()
            Stepper("CPUs", value: self.$cpuCount, in: 1...5, step: 1.0).labelsHidden()
          }
        
        LabeledContent("Memory") {
          Slider(value: self.$memoryIndex, in: 1...11, step: 1.0)
          Text( self.memory, format: .byteCount(style: .memory)).labelsHidden()
          Stepper("Memory", value: self.$memoryIndex, in: 1...11, step: 1.0).labelsHidden()
        }
        
      
      LabeledContent("Storage") {
        Slider(value: self.$storageIndex, in: 36...42, step: 1.0)
        Text( self.storage, format: .byteCount(style: .memory)).labelsHidden()
        Stepper("Memory", value: self.$storageIndex, in: 36...42, step: 1.0).labelsHidden()
      }
      }.onChange(of: self.memoryIndex) { oldValue, newValue in
        self.memory = Self.memoryValue(forIndex: memoryIndex)
      }.onChange(of: self.storageIndex) { oldValue, newValue in
        self.storage = Self.storageValue(forIndex: newValue)
      }
    }
}

#Preview {
  PageView(onDismiss: nil) {
    ContainerView{
      SpecificationConfigurationView()
    }
  }
   
}
