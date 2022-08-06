//
// WelcomeActionButton.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import SwiftUI

struct WelcomeActionButton: View {
  let imageSystemName: String
  let title: String
  let description: String
  let action: () -> Void
  var body: some View {
    Button(action: self.action, label: self.label).buttonStyle(.plain).fixedSize()
  }

  func label() -> some View {
    HStack {
      Image(systemName: self.imageSystemName).resizable().aspectRatio(contentMode: .fit).foregroundColor(.accentColor)
      VStack(alignment: .leading) {
        Text(self.title).font(.custom("Raleway", size: 14.0)).bold()
        Text(self.description).font(.custom("Raleway", size: 14.0)).fontWeight(.light)
      }
    }
  }
}

struct WelcomeActionButton_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeActionButton(imageSystemName: "plus.app", title: "Create a new Machine", description: "Create a new Virtual Machine for Testing Your App") {}
  }
}
