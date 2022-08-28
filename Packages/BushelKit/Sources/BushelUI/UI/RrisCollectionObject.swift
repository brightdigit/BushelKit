//
// RrisCollectionObject.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import BushelMachine
import Combine
import SwiftUI
class RrisCollectionObject: ObservableObject {
  let sources: [Rris] = [
    .apple
  ]
  @Published var selectedSource: String?
  @Published var imageListResult: Result<[RestoreImage], Error>?

  init() {
    $selectedSource.share().print().map { _ in nil }.receive(on: DispatchQueue.main).assign(to: &$imageListResult)

    $imageListResult.combineLatest($selectedSource).compactMap { imageListResult, source in
      imageListResult == nil ? self.sources.first(where: { $0.id == source }) : nil
    }.flatMap { source in
      Future(operation: source.fetch)
    }.map { $0 as Result<[RestoreImage], Error>? }.receive(on: DispatchQueue.main).assign(to: &$imageListResult)
  }
}
