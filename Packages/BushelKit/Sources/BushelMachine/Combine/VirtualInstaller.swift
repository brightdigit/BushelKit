//
// VirtualInstaller.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

#if canImport(Combine)
  import Combine
#endif
import Foundation

public protocol VirtualInstaller {
  #if canImport(Combine)
    func completionPublisher() -> AnyPublisher<Error?, Never>
    func progressPublisher<Value>(forKeyPath keyPath: KeyPath<Progress, Value>) -> AnyPublisher<Value, Never>
  #endif
  func begin()
}
