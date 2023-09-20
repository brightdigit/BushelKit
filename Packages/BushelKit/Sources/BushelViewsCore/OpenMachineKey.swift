//
// OpenMachineKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)

  import BushelCore
  import Foundation
  import SwiftUI

  public typealias OpenMachineAction = OpenWindowWithAction
  private struct OpenMachineKey: EnvironmentKey {
    static let defaultValue: OpenMachineAction = .default
  }

  public extension EnvironmentValues {
    var openMachine: OpenMachineAction {
      get { self[OpenMachineKey.self] }
      set {
        self[OpenMachineKey.self] = newValue
      }
    }
  }

  public extension View {
    func openMachine(
      _ closure: @escaping (OpenWindowAction) -> Void
    ) -> some View {
      environment(\.openMachine, .init(closure: closure))
    }

    func openMachine<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some View {
      openMachine(OpenFilePanel<FileType>().callAsFunction(with:))
    }
  }

  public extension Scene {
    func openMachine(
      _ closure: @escaping (OpenWindowAction) -> Void
    ) -> some Scene {
      environment(\.openMachine, .init(closure: closure))
    }

    func openMachine<FileType: FileTypeSpecification>(
      _: FileType.Type
    ) -> some Scene {
      openMachine(OpenFilePanel<FileType>().callAsFunction(with:))
    }
  }

#endif
