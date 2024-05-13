//
// Scene.swift
// Copyright (c) 2024 BrightDigit.
//

////
//// Scene.swift
//// Copyright (c) 2024 BrightDigit.
////
//
// #if canImport(SwiftUI)
//  import BushelCore
//  import FeatherQuill
//  import SwiftUI
//
//  extension Scene {
//    public func audience(with cipher: any UserAudienceCipher) -> some Scene {
//      self.audience(cipher.includes(_:))
//    }
//
//    public func audience(_ callback: @escaping @Sendable (UserAudience) async -> Bool) -> some Scene {
//      Task {
//        await UserEvaluator.evaluate.setup(callback)
//      }
//      return self
//    }
//  }
// #endif
