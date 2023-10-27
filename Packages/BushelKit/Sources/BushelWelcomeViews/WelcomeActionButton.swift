//
// WelcomeActionButton.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct WelcomeActionButton: View {
    @Environment(\.colorScheme) var colorScheme
    let imageSystemName: String

    let titleID: LocalizedStringID
    let accessibilityIdentifier: String
    let action: () -> Void
    var body: some View {
      Button(
        action: self.action,
        label: self.label
      )
      .buttonStyle(.plain)
      .accessibilityLabel(String(localizedUsingID: self.titleID))
      .accessibilityIdentifier(self.titleID.rawValue)
    }

    init(
      imageSystemName: String,
      titleID: LocalizedStringID,
      accessibilityIdentifier: String? = nil,
      action: @escaping () -> Void
    ) {
      self.imageSystemName = imageSystemName
      self.titleID = titleID
      self.accessibilityIdentifier = accessibilityIdentifier ?? titleID.rawValue
      self.action = action
    }

    func label() -> some View {
      ZStack {
        HStack {
          Image(
            systemName: self.imageSystemName
          ).resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25.0)
          Text(self.titleID)
            .font(.system(size: 13.0))
            .bold()
          Spacer()
        }.padding(8.0)
        RoundedRectangle(cornerRadius: 8.0)
          .background(
            colorScheme == .dark ? Color.white : Color.black
          )
          .opacity(0.025)
      }
    }
  }

  struct WelcomeActionButton_Previews: PreviewProvider {
    static var previews: some View {
      // swiftlint:disable multiline_arguments_brackets
      WelcomeActionButton(
        imageSystemName: "plus.app",
        titleID: .welcomeNewMachineTitle
      ) {}
      // swiftlint:enable multiline_arguments_brackets
    }
  }
#endif
