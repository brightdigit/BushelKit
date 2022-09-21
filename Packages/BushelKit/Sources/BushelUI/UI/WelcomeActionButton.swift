//
// WelcomeActionButton.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct WelcomeActionButton: View {
    let imageSystemName: String

    let titleID: LocalizedStringID
    let descriptionID: LocalizedStringID
    let action: () -> Void
    var body: some View {
      Button(action: self.action, label: self.label).buttonStyle(.plain).fixedSize()
    }

    func label() -> some View {
      HStack {
        Image(
          systemName: self.imageSystemName
        ).resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.accentColor)
          .frame(width: 25.0)
        VStack(alignment: .leading) {
          Text(self.titleID).font(.custom("Raleway", size: 14.0)).bold()
          Text(self.descriptionID).font(.custom("Raleway", size: 14.0)).fontWeight(.light)
        }
      }
    }
  }

  struct WelcomeActionButton_Previews: PreviewProvider {
    static var previews: some View {
      // swiftlint:disable multiline_arguments_brackets
      WelcomeActionButton(
        imageSystemName: "plus.app",
        titleID: .welcomeNewMachineTitle,
        descriptionID: .welcomeNewMachineDescription
      ) {}
      // swiftlint:enable multiline_arguments_brackets
    }
  }
#endif
