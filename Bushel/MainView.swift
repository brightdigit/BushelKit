//
//  MainView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI
import Virtualization
import Combine
import CommonCrypto

struct MainView<RestoreImageMetadataType : RestoreImageMetadata>: View {
  
    @EnvironmentObject var object : AppObject<RestoreImageMetadataType>
  var body: some View {
      TabView {
        ImagesView<RestoreImageMetadataType>().tabItem {
          
          Label("Images", systemImage:  "externaldrive.fill")
        
      }.onAppear(perform: object.initialize)
      }.frame(width: 500.0)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView().environmentObject(AppObject(remoteImageFetcher: Self.previewImageFetch(_:)))
    }
}
