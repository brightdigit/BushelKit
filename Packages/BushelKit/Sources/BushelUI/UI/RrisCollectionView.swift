//
// RrisCollectionView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Combine) && canImport(SwiftUI) && canImport(Virtualization)
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
            NavigationLink(tag: source.id, selection: self.$selectedSourceObject.selectedSource) {
              VStack {
                SourceImageCollectionView(source: source).padding()
                Spacer()
              }
            } label: {
              Text(source.title)
            }
          }
        }
      }.onAppear {
        self.selectedSourceObject.selectedSource = self.selectedSourceObject.sources.first?.id
      }
    }
  }

  struct RrisCollectionView_Previews: PreviewProvider {
    static var previews: some View {
      RrisCollectionView()
    }
  }
#endif
