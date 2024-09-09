//
// SessionObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMarket
  import BushelScreenCore
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  @MainActor
  @Observable
  internal final class SessionObject: Loggable, MachineObjectParent, SessionFramable, Sendable {
    var url: URL?
    var alertIsPresented = false
    var presentConfirmCloseAlert = false
    var toolbarHeight: CGFloat = 24.0 + 28.0
    var screenSettings = ScreenSettings()
    var purchasePrompt = false
    var hasIntialStarted = false
    var keepWindowOpenOnShutdown = false
    var shouldDisplaySubscriptionStoreView = false
    var isForceRestartRequested = false
    var sessionAutomaticSnapshotsEnabled = true
    var isRestarting = false
    var sessionCloseButtonActionOption: SessionCloseButtonActionOption?

    var waitingForShutdown = false

    var machineObject: MachineObject? {
      didSet {
        Task {
          await self.machineObject?.refreshSnapshots()
        }
      }
    }

    var error: MachineError? {
      didSet {
        alertIsPresented = (error != nil) || alertIsPresented
      }
    }

    var initializedWindowSize = false

    // swiftlint:disable:next discouraged_optional_boolean
    var purchased: Bool?

    var allowedSaveSnapshot: Bool {
      assert(purchased != nil)
      if purchased == true {
        return true
      }

      guard let machineObject else {
        return false
      }

      return machineObject.snapshotIDs.count < PaywallConfiguration.shared.maximumNumberOfFreeSnapshots
    }

    @ObservationIgnored
    weak var windowDelegate: (any NSWindowDelegate)?

    @ObservationIgnored
    weak var window: NSWindow?
  }
#endif
