//
// RrisCollectionView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import BushelMachine
import Combine
import SwiftUI
import Virtualization
struct RrisCollectionView: View {
  init() {}

  @StateObject var selectedSourceObject = RrisCollectionObject()
  @State var selectedImage: RestoreImage?
  var body: some View {
    NavigationView {
      List {
        ForEach(self.selectedSourceObject.sources) { source in
          NavigationLink {
            SourceImageCollectionView(source: source)
          } label: {
            Text(source.title)
          }
        }
      }
    }
//            Group{
//                if case let .success(images) = self.selectedSourceObject.imageListResult {
//                    List(selection: self.$selectedImage){
//                        ForEach(images) { image in
//                            Text(image.operatingSystemVersion.description)
//                        }
//                    }
//                } else {
//                    Text("No Source Selected")
//                }
//            }.frame(width: 500)
//        }
  }
}

struct RrisCollectionView_Previews: PreviewProvider {
  static var previews: some View {
    RrisCollectionView()
  }
}
