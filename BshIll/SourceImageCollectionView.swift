//
//  SourceImageCollectionView.swift
//  BshIll
//
//  Created by Leo Dion on 6/27/22.
//

import SwiftUI

struct SourceImageCollectionView: View {
    internal init(source: Rris) {
        self._collectionObject = StateObject(wrappedValue: RrisImageCollectionObject(source: source))
    }
  
    @StateObject var collectionObject : RrisImageCollectionObject
//    let source : Rris
//    @State var imageListResult : Result<[RestoreImage], Error>?
    var body: some View {
        Group {
            switch self.collectionObject.imageListResult {
            case .success(let images):
                ForEach(images) { image in
                  RestoreImageView(image: image)
                }
            case .failure(let error):
                Text(error.localizedDescription)
            case .none:
                ProgressView()
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
