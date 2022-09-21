//
// PurchaseView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct PurchaseView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @Environment(\.openURL) private var openURL: OpenURLAction

    var body: some View {
      VStack {
        Text(.upgradePurchase)
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
        Text(LocalizedStringID.proFeatures)

        HStack {
          Button(.restorePurchases) {}

          Button(.stayBasic) {
            dismiss()
          }
        }

        HStack {
          Button(.termsOfUse) {
            openURL(Configuration.URLs.termsOfUse)
          }

          Button(.privacyPolicy) {
            openURL(Configuration.URLs.privacyPolicy)
          }
        }
      }.padding()
    }
    // swiftlint:enable closure_body_length
  }

  struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
      PurchaseView()
    }
  }
#endif
