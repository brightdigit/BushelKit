//
// KVNSObservation.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(ObjectiveC)
  import Foundation

  internal class KVNSObservation: KVObservation {
    internal init(observed: NSObject, observer: NSObject, keyPaths: [String]) {
      self.observed = observed
      self.observer = observer
      self.keyPaths = keyPaths
    }

    let observed: NSObject
    let observer: NSObject
    let keyPaths: [String]

    deinit {
      for keyPath in keyPaths {
        observed.removeObserver(observer, forKeyPath: keyPath)
      }
    }
  }
#endif
