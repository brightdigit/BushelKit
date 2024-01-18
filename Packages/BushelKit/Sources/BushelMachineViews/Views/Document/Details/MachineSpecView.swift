//
// MachineSpecView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct MachineSpecView: View {
    let systemName: String
    let valueView: Text
    let labelView: Text
    let fontSize: CGFloat
    var body: some View {
      HStack {
        Image(systemName: systemName).resizable().aspectRatio(contentMode: .fit).fixedSize()
        labelView.fontWeight(.bold).fixedSize()
        valueView.fixedSize()
      }.fixedSize().font(.system(size: fontSize)).lineLimit(1)
    }

    internal init(
      systemName: String,
      fontSize: CGFloat = 18.0,
      label: @escaping () -> Text,
      value: @escaping () -> Text
    ) {
      self.systemName = systemName
      valueView = value()
      labelView = label()
      self.fontSize = fontSize
    }
  }

  struct MachineSpecView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSpecView(
        systemName: "cpu.fill"
      ) {
        Text(LocalizedStringID.machineDetailsChip)
      } value: {
        Text(localizedUsingID: LocalizedDictionaryID.cpuCount, arguments: 4)
      }
    }
  }
#endif
