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

  struct SessionView: View, Loggable {
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
            isForceRestartRequested: self.$object.isForceRestartRequested,

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
        Text(.sessionForceRestartTitle),
        isPresented: self.$object.isForceRestartRequested
      ) {
        Button(role: .destructive, .sessionForceRestartButton) {
          self.object.begin { machine in
            self.object.isRestarting = true
            try await machine.stop()
            try await machine.start()
            self.object.isRestarting = false
          }
        }
      } message: {
        Text(.sessionForceRestartMessage)
      }
      .confirmationDialog(
        Text(.sessionShutdownTitle),
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
      .onChange(of: request?.url, self.beginLoading(_: newURL:))
      .onAppear(perform: self.beginLoadingURL)
      .onChange(of: self.object.canStart, self.object.onCanStartChange)
      .onChange(of: self.marketplace.purchased) { _, newValue in
        guard newValue, self.sessionCloseButtonActionOption == .saveSnapshotAndForceTurnOff else {
          return
        }
        self.sessionCloseButtonActionOption = nil
      }
      .onChange(of: self.sessionCloseButtonActionOption) { _, newValue in
        self.object.setCloseButtonAction(newValue)
      }

      .onChange(of: self.object.state) {
        self.object.onStateChanged(
          from: $0,
          to: $1,
          shutdownOption: self.machineShutdownActionOption,
          dismiss: self.dismiss.callAsFunction
        )
      }
      .navigationTitle(
        Self.navigationTitle(from: self.object.machineObject, default: "Loading Session...")
      )
      .alert(
        isPresented: self.$object.alertIsPresented,
        error: self.object.error
      ) { error in
        if error.isCritical {
          Button(.ok) {
            Task { @MainActor in
              self.dismiss()
            }
          }
        }
      } message: { _ in
      }
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

    func beginLoadingURL() {
      self.beginLoadingURL(self.request?.url)
    }

    func beginLoading(_: URL?, newURL: URL?) {
      self.beginLoadingURL(newURL)
    }

    func beginLoadingURL(_ url: URL?) {
      if let url {
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
  }
#endif
