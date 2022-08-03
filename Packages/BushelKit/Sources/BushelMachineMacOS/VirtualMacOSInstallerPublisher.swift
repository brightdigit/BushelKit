//
// VirtualMacOSInstallerPublisher.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import Combine
import Virtualization

class VirtualMacOSInstallerPublisher: VirtualInstaller {
  internal init(vzInstaller: VZMacOSInstaller) {
    self.vzInstaller = vzInstaller
    beginTrigger = PassthroughSubject()
    installationResultSubject = PassthroughSubject()
    cancellable = beginTrigger.flatMap {
      Future { completed in
        self.vzInstaller.install { result in
          completed(.success(result))
        }
      }
    }.subscribe(installationResultSubject)
  }

  let vzInstaller: VZMacOSInstaller
  let beginTrigger: PassthroughSubject<Void, Never>
  let installationResultSubject: PassthroughSubject<Result<Void, Error>, Never>
  var cancellable: AnyCancellable!

  func progressPublisher<Value>(forKeyPath keyPath: KeyPath<Progress, Value>) -> AnyPublisher<Value, Never> {
    vzInstaller.progress.publisher(for: keyPath, options: [.new, .initial]).eraseToAnyPublisher()
  }

  func completionPublisher() -> AnyPublisher<Error?, Never> {
    installationResultSubject.map { result in
      guard case let .failure(error) = result else {
        return nil
      }
      return error
    }.eraseToAnyPublisher()
  }

  func begin() {
    beginTrigger.send()
  }
}
