//
// LocalizedStringID+Assert.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

extension LocalizedStringID {
  #if DEBUG
    struct Assert {
      private static var loadedValues = false

      private static let stringsDictionary = { url in
        // swiftlint:disable:next force_cast force_unwrapping
        NSDictionary(contentsOf: url!) as! [String: String]
      }(Bundle.module.url(forResource: "Localizable", withExtension: "strings"))

      private static let idDictionary = Dictionary(uniqueKeysWithValues:
        LocalizedStringID.allCases.map {
          ($0.keyValue, $0)
        })

      static func begin(_ report: @autoclosure () -> Assert = Assert()) {
        if Self.loadedValues {
          return
        }
        report().assert()
        Self.loadedValues = true
      }

      func assert() {
        if !missingCases.isEmpty {
          print("Missing Cases:")
          for (key, value) in missingCases {
            print("case \(key) // \"\(value)\"")
          }
        }
        if !missingDictionaryValues.isEmpty {
          print("Missing Dictionary Values:")
          for key in missingDictionaryValues {
            print("\"\(key)\" = \"case \(key.camelCased())\";")
          }
        }
        Swift.assert(missingDictionaryValues.isEmpty)
        Swift.assert(missingCases.isEmpty)
        print("Successful Localization")
      }

      internal init(
        stringsDictionary: [String: String] = Self.stringsDictionary,
        idDictionary: [String: LocalizedStringID] = Self.idDictionary
      ) {
        let allKeys = Set(Array(stringsDictionary.keys) + Array(idDictionary.keys))
        var missingCases = [String: String]()
        var missingDictionaryValues = [String]()
        for key in allKeys {
          let dictionaryValue = stringsDictionary[key]
          let caseName = idDictionary[key]

          guard let dictionaryValue else {
            // swiftlint:disable:next force_unwrapping
            missingDictionaryValues.append(caseName!.keyValue)
            continue
          }

          guard caseName != nil || key.contains("%") else {
            missingCases[key.camelCased()] = dictionaryValue
            continue
          }
        }
        self.init(missingDictionaryValues: missingDictionaryValues, missingCases: missingCases)
      }

      internal init(missingDictionaryValues: [String], missingCases: [String: String]) {
        self.missingDictionaryValues = missingDictionaryValues
        self.missingCases = missingCases
      }

      let missingDictionaryValues: [String]
      let missingCases: [String: String]
    }

  #endif

  static func assert() {
    #if DEBUG
      Assert.begin()
    #endif
  }
}
