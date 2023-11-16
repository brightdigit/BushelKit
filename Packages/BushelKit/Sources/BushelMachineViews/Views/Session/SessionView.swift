//
// SessionView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import AppKit
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import BushelMarketEnvironment
  import BushelViewsCore
  import Combine
  import StoreKit
  import SwiftUI

  struct SessionView: View, LoggerCategorized {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var timer: AnyPublisher<Date, Never>!

    @Binding var request: SessionRequest?
    @State var object = SessionObject()

    @AppStorage(for: AutomaticSnapshots.Enabled.self)
    var automaticSnapshotEnabled: Bool
    @AppStorage(for: AutomaticSnapshots.Value.self)
    var automaticSnapshotValue: Int?
    @AppStorage(for: AutomaticSnapshots.Polynomial.self)
    var polynomial: LagrangePolynomial

    @AppStorage(for: Preference.MachineShutdownAction.self)
    var machineShutdownActionOption: MachineShutdownActionOption?
    @AppStorage(for: Preference.SessionCloseButtonAction.self)
    var sessionCloseButtonActionOption: SessionCloseButtonActionOption?

    @Environment(\.metadataLabelProvider) var labelProvider
    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.snapshotProvider) private var snapshotProvider
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.marketplace) private var marketplace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.purchaseWindow) private var purchaseWindow

    var body: some View {
      ZStack {
        object.view()
      }
      .toolbar(content: {
        ToolbarItemGroup {
          SessionToolbarView(
            screenSettings: self.$object.screenSettings,
            sessionAutomaticSnapshotsEnabled: self.$object.sessionAutomaticSnapshotsEnabled,
            keepWindowOpenOnShutdown: self.$object.keepWindowOpenOnShutdown,
            agent: self.object,
            onGeometryProxy: self.object.toolbarProxy
          )
        }
      })
      .frame(
        minWidth: object.minWidth,
        idealWidth: object.idealWidth,
        minHeight: object.minHeight,
        idealHeight: object.idealHeight
      )
      .nsWindowAdaptor { window in
        self.object.setWindow(window)
      }
      .nsWindowDelegateAdaptor(
        self.$object.windowDelegate,
        SessionWindowDelegate(object: object)
      )
      .confirmationDialog(
        "Shutdown Machine",
        isPresented: self.$object.presentConfirmCloseAlert
      ) {
        SessionClosingActionsView(
          keepWindowOpenOnShutdown: self.$object.keepWindowOpenOnShutdown,
          pressPowerButton: self.object.pressPowerButton,
          stopAndSaveSnapshot: self.object.stop(saveSnapshot:)
        )
      } message: {
        Text(.sessionShutdownAlert)
      }
      .onReceive(self.timer, perform: { _ in
        if self.marketplace.purchased, self.object.sessionAutomaticSnapshotsEnabled {
          if self.object.state == .running {
            self.object.startSnapshot(.init(), options: .discardable)
          }
        }
      })
      .onChange(of: request?.url) { _, newValue in
        if let url = newValue {
          Task {
            await self.object.loadURL(
              url,
              withContext: context,
              restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
              snapshotFactory: self.snapshotProvider,
              using: systemManager,
              labelProvider: self.labelProvider.callAsFunction(_:_:)
            )
          }
        }
      }
      .onAppear {
        if let url = self.request?.url {
          Task {
            await self.object.loadURL(
              url,
              withContext: context,
              restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
              snapshotFactory: self.snapshotProvider,
              using: systemManager,
              labelProvider: self.labelProvider.callAsFunction(_:_:)
            )
          }
        }
      }
      .onChange(of: self.object.canStart) { _, newValue in
        guard newValue, !self.object.hasIntialStarted else {
          return
        }

        self.object.hasIntialStarted = true
        self.object.begin {
          try await $0.start()
        }
      }

      .onChange(of: self.marketplace.purchased) { _, newValue in
        guard newValue, self.sessionCloseButtonActionOption == .saveSnapshotAndForceTurnOff else {
          return
        }
        self.sessionCloseButtonActionOption = nil
      }
      .onChange(of: self.sessionCloseButtonActionOption) { _, newValue in
        self.object.setCloseButtonAction(newValue)
      }

      .onChange(of: self.object.state) { oldValue, newValue in
        self.object.updateWindowSize()
        if
          oldValue != .stopped,
          newValue == .stopped,
          !self.object.keepWindowOpenOnShutdown ||
          self.machineShutdownActionOption == .closeWindow {
          self.object.hasIntialStarted = false
          self.object.startSnapshot(.init(), options: .discardable)
          dismiss()
        }
      }
      .navigationTitle(
        Self.navigationTitle(from: self.object.machineObject, default: "Loading Session...")
      )
    }

    init(request: Binding<SessionRequest?>) {
      self._request = request

      let interval = automaticSnapshotValue
        .map(Double.init)?
        .transform(using: self.polynomial)
        .roundToNearest(value: .Snapshot.intervalIncrements, unlessThan: true) ??
        .Snapshot.defaultInterval
      self.timer = .automaticSnapshotPublisher(
        every: interval,
        isEnabled: true
      )

      self.object.setCloseButtonAction(self.sessionCloseButtonActionOption)
    }

    static func navigationTitle(
      from machineObject: MachineObject?,
      default defaultValue: String
    ) -> String {
      machineObject.map(Self.navigationTitle(from:)) ?? defaultValue
    }

    static func navigationTitle(from machineObject: MachineObject) -> String {
      "\(machineObject.entry.name) (\(machineObject.state))"
    }
  }
#endif
