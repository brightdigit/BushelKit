//
// PurchaseView.swift
// Copyright (c) 2022 BrightDigit.
//

import SwiftUI

struct PurchaseView: View {
  @Environment(\.dismiss) private var dismiss: DismissAction
  @Environment(\.openURL) private var openURL: OpenURLAction
  var body: some View {
    VStack {
      Text("Uprade to")
      Text("Bushel Pro")
      HStack {
        Button {} label: {
          VStack {
            HStack {
              Text("$4.99")
              Text("/month")
            }
            Text("per month, billed monthly")
          }
        }.buttonStyle(.link)

        Button {} label: {
          VStack {
            HStack {
              Text("$4.99")
              Text("/month")
            }
            Text("per month, billed monthly")
          }
        }.buttonStyle(.link)
      }

      HStack {
        VStack {
          Image(systemName: "chart.pie")
          Text("Lorem Ipsum")
          Text("Mauris quis vehicula quam, vitae.")
        }
        VStack {
          Image(systemName: "chart.pie")
          Text("Lorem Ipsum")
          Text("Mauris quis vehicula quam, vitae.")
        }
        VStack {
          Image(systemName: "chart.pie")
          Text("Lorem Ipsum")
          Text("Mauris quis vehicula quam, vitae.")
        }
      }
      // swiftlint:disable:next line_length
      Text("And much more: Configure windows visibility, minimized capturing window, access to all privacy actions and directories, custom touches color, custom color for captures, optimise for App Previews, optimise recordings for quality or speed, delete Derived Data globally and per app, clear Xcode Previews cache.")

      HStack {
        Button("Restore Purchases") {}

        Button("Not yet, let's stay with basic") {
          dismiss()
        }
      }

      HStack {
        Button("Terms of Use") {
          openURL(Configuration.URLs.termsOfUse)
        }

        Button("Privacy Policy") {
          openURL(Configuration.URLs.privacyPolicy)
        }
      }
    }.padding()
  }
}

struct PurchaseView_Previews: PreviewProvider {
  static var previews: some View {
    PurchaseView()
  }
}
