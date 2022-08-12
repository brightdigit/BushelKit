//
// SourceImageCollectionView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import SwiftUI

struct SourceImageCollectionView: View {
  internal init(source: Rris) {
    _collectionObject = StateObject(wrappedValue: RrisImageCollectionObject(source: source))
  }

  @StateObject var collectionObject: RrisImageCollectionObject
  var body: some View {
    Group {
      switch self.collectionObject.imageListResult {
      case let .success(images):
        ForEach(images) { image in
          RestoreImageView(image: image)
        }
      case let .failure(error):
        Text(error.localizedDescription)
      case .none:
        ProgressView().padding(20.0)
      }
    }.onAppear {
      self.collectionObject.loadImages()
    }
  }
}

struct SourceImageCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    SourceImageCollectionView(source: .apple)
  }
}
