//
// SpecificationTemplateButton.swift
// Copyright (c) 2024 BrightDigit.
//

//
//  SpecificationTemplateButton.swift
//  PageViewController
//
//  Created by Leo Dion on 3/12/24.
//
#if canImport(SwiftUI)
  import BushelFactory
  import BushelLocalization
  import SwiftUI

  struct SpecificationTemplateButton: View {
    let option: SpecificationTemplate<LocalizedStringID>
    @Binding var template: SpecificationTemplate<LocalizedStringID>?
    var isSelected: Bool {
      option.id == template?.id
    }

    var body: some View {
      Button(action: {
        self.template = option
      }, label: {
        VStack {
          Image(systemName: option.systemImageName)
            .resizable()
            .foregroundStyle(Color.accentColor)
            .aspectRatio(contentMode: .fit)
            .frame(width: 40.0, height: 40.0)
            .padding(12.0)
            .background {
              RoundedRectangle(cornerRadius: 8.0).fill(Color.accentColor).opacity(isSelected ? 0.25 : 0.0)
            }
          Text(option.nameID)
            .padding(4.0)
            .background {
              RoundedRectangle(cornerRadius: 8.0).fill(Color.accentColor).opacity(isSelected ? 1.0 : 0.0)
            }
            .padding(-4.0)
        }.opacity(isSelected ? 1.0 : 0.8).padding()
      }).buttonStyle(.plain)
    }
  }

  #Preview {
    SpecificationTemplateButton(option: .basic, template: .constant(nil))
  }

  #Preview {
    SpecificationTemplateButton(option: .basic, template: .constant(.basic))
  }
#endif
