//
// AutoSnapshotIntervalSettingView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import SwiftUI

  struct AutoSnapshotIntervalSettingView: View {
    @AppStorage(for: AutomaticSnapshots.Enabled.self)
    var automaticSnapshotEnabled: Bool
    @AppStorage(for: AutomaticSnapshots.Value.self)
    var automaticSnapshotValue: Int?
    @AppStorage(for: AutomaticSnapshots.Polynomial.self)
    var polynomial: LagrangePolynomial

    @Environment(\.marketplace) var marketplace
    @Environment(\.openWindow) var openWindow
    @Environment(\.purchaseWindow) var purchaseWindow

    var object = AutoSnapshotIntervalObject()
    var body: some View {
      ZStack {
        if !marketplace.purchased {
          HStack {
            Text(.upgradeTo)
            Button(.upgradePurchase) {
              self.openWindow(value: purchaseWindow)
            }.bold().buttonStyle(.borderedProminent)
          }
          .padding(20.0)
          .padding(.horizontal, 40.0)
          .background(.bar, in: RoundedRectangle(cornerRadius: 4.0))
        }
        VStack(alignment: .trailing, spacing: 8.0) {
          Toggle(LocalizedStringID.enabled.key, isOn: $automaticSnapshotEnabled)
            .opacity(marketplace.purchased ? 1.0 : 0.5)
            .disabled(!marketplace.purchased)
          Group {
            @Bindable var objectBinding = object
            Slider(
              value: $objectBinding.inputValue,
              in: 1 ... 20,
              step: 2.0,
              label: {
                Text(.settingsAutomaticSnapshotsLabel)
              },
              minimumValueLabel: {
                Text(.settingsAutomaticSnapshotsMin)
              },
              maximumValueLabel: {
                Text(.settingsAutomaticSnapshotsMax)
              }
            ).labelsHidden()
            VStack(alignment: .trailing) {
              Text(.settingsAutomaticSnapshotsPrefix).font(.caption)
              Text(self.object.formattedValue, formatter: Formatters.seconds).bold()
            }.foregroundStyle(Color.primary)
          }.opacity((marketplace.purchased && self.automaticSnapshotEnabled) ? 1.0 : 0.5)
            .disabled(!(marketplace.purchased && self.automaticSnapshotEnabled))
        }
      }
    }

    init() {
      self.object.bindTo(self.$automaticSnapshotValue, using: self.polynomial)
    }
  }

  #Preview {
    AutoSnapshotIntervalSettingView()
  }
#endif
