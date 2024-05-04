//
// SpecificationConfigurationView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelFactory
  import BushelLocalization
  import RadiantKit
  import SwiftUI

  struct SpecificationConfigurationView: View, Sendable {
    @Binding var isNextReady: Bool
    @Binding var configuration: SpecificationConfiguration<LocalizedStringID>

    var body: some View {
      Form {
        LabeledContent("Specifications") {
          HStack {
            ForEach(Specifications.Options.all) { option in
              SpecificationTemplateButton(option: option, template: self.$configuration.template)
            }
            Spacer()
          }.padding(.horizontal).overlay {
            Rectangle()
              .fill(.clear)
              .stroke(.primary.opacity(0.25))
              .shadow(color: .black, radius: 2, x: 1, y: 1)
          }
        }
        SliderStepperView(
          titleID: .machineDialogCpusName,
          value: self.$configuration.cpuCount,
          bounds: self.configuration.configurationRange.cpuCount
        ) { _ in
          TextField(value: self.$configuration.cpuCount, format: .number) {
            Text(.machineDialogCpusName)
          }
        }

        SliderStepperView(
          titleID: .machineDialogMemoryName,
          value: self.$configuration.memoryIndex,
          bounds: self.configuration.memoryIndexRange
        ) { _ in
          Text(
            self.configuration.memory,
            format: .byteCount(style: .memory)
          )
        }
        SliderStepperView(
          titleID: .machineDialogStorageName,
          value: self.$configuration.storageIndex,
          bounds: Specifications.fullStorageBoundsRange
        ) { _ in
          Text(
            self.configuration.storage,
            format: .byteCount(style: .memory)
          )
        }.onChange(of: self.configuration, initial: true) { _, newValue in
          self.isNextReady = newValue.isValid
        }
      }
    }

    internal init(isNextReady: Binding<Bool>, configuration: Binding<SpecificationConfiguration<LocalizedStringID>>) {
      self._isNextReady = isNextReady
      self._configuration = configuration
    }
  }

//    #Preview {
//        PageView(onDismiss: nil) {
//            ContainerView { isNextReady in
//                SpecificationConfigurationView(isNextReady: isNextReady)
//            }
//        }
//    }
#endif
