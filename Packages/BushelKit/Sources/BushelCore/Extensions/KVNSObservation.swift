//
// KVNSObservation.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(ObjectiveC)
  import Foundation

  internal class KVNSObservation: KVObservation {
    let observed: NSObject
    let observer: NSObject
    let keyPaths: [String]

    internal init(observed: NSObject, observer: NSObject, keyPaths: [String]) {
      self.observed = observed
      self.observer = observer
      self.keyPaths = keyPaths
    }

    // swiftlint:disable:next line_length
    #warning("logging-note: I wanted to note that I used to log every init while developing, just to make sure I am not leaving any leaks behind me, but not sure if this is useful for the current state of bushel development")
    deinit {
      for keyPath in keyPaths {
        observed.removeObserver(observer, forKeyPath: keyPath)
      }
    }
  }
#endif
