//
// MachineSpecView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct MachineSpecView: View {
    internal init(systemName: String, fontSize: CGFloat = 14.0, label: @escaping () -> Text, value: @escaping () -> Text) {
      self.systemName = systemName
      valueView = value()
      labelView = label()
      self.fontSize = fontSize
    }

    let systemName: String
    let valueView: Text
    let labelView: Text
    let fontSize: CGFloat
    var body: some View {
      HStack {
        labelView.fontWeight(.bold).fixedSize()
        Image(systemName: systemName).resizable().aspectRatio(contentMode: .fit).fixedSize()
        valueView.fixedSize()
      }.fixedSize().font(.custom("Raleway", size: fontSize)).lineLimit(1)
    }
  }

  struct MachineSpecView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSpecView(systemName: "cpu.fill") {
        Text(.machineDetailsChip)
      } value: {
        Text(
          String(
            format: NSLocalizedString("%d CPUS", bundle: .module, comment: "")))
      }
    }
  }
#endif
