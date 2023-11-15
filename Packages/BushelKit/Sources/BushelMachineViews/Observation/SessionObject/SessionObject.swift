//
// SessionObject.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS) && canImport(SwiftUI) && canImport(SwiftData)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelSessionUI
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  @Observable
  class SessionObject: LoggerCategorized, MachineObjectParent, SessionFramable {
    var url: URL?
    var presentConfirmCloseAlert: Bool = false
    var toolbarHeight: CGFloat = 24.0 + 28.0
    var screenSettings = ScreenSettings()

    var hasIntialStarted = false
    var keepWindowOpenOnShutdown = false
    var shouldDisplaySubscriptionStoreView = false
    var sessionCloseButtonActionOption: SessionCloseButtonActionOption?

    var waitingForShutdown: Bool = false

    var machineObject: MachineObject?
    var error: MachineError?
    var initializedWindowSize: Bool = false

    @ObservationIgnored
    weak var windowDelegate: NSWindowDelegate?

    @ObservationIgnored
    weak var window: NSWindow?
  }
#endif
