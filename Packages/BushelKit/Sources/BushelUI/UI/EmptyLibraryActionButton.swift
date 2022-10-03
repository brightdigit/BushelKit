//
// EmptyLibraryActionButton.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct EmptyLibraryActionButton: View {
    let imageSystemName: String
    let titleID: LocalizedStringID
    let action: () -> Void
    var body: some View {
      Button(action: self.action, label: self.label)
    }

    func label() -> some View {
      HStack {
        Image(systemName: imageSystemName)
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .foregroundColor(.accentColor)
          .frame(height: 24.0)
        Spacer().frame(width: 12.0)
        Text(titleID).font(.custom("Raleway", size: 24.0))
      }
    }
  }

  struct EmptyLibraryActionButton_Previews: PreviewProvider {
    static var previews: some View {
      EmptyLibraryActionButton(imageSystemName: "plus", titleID: .importRestoreImage) {}
    }
  }
#endif
