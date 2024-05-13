//
// OpenMachineKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  import BushelCore
  import Foundation
  import SwiftUI

  public typealias OpenMachineAction = OpenWindowWithAction
  private struct OpenMachineKey: EnvironmentKey {
    static let defaultValue: OpenMachineAction = .default
  }

  extension EnvironmentValues {
    public var openMachine: OpenMachineAction {
      get { self[OpenMachineKey.self] }
      set {
        self[OpenMachineKey.self] = newValue
      }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    public func openMachine(
      _ closure: @escaping @MainActor @Sendable (OpenWindowAction) -> Void
    ) -> some View {
      environment(\.openMachine, .init(closure: closure))
    }

    public func openMachine<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some View {
      openMachine {
        OpenFilePanel<FileType>()(with: $0)
      }
    }
  }

  extension Scene {
    public func openMachine(
      _ closure: @escaping @MainActor @Sendable (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.openMachine, .init(closure: closure))
    }

    public func openMachine<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      openMachine(OpenFilePanel<FileType>().callAsFunction(with:))
    }
  }

#endif