//
//  ImagesView.swift
//  Bushel
//
//  Created by Leo Dion on 5/31/22.
//

import SwiftUI

struct ImagesView: View {
  @State var error : Error?
  @State var selectedImage : RestoreImage? 
  @EnvironmentObject var object : AppObject
    var body: some View {
      VStack {
//        RemoteImageView(image: object.remoteImage).border(.secondary)
        ImageList(images: object.images, imageBinding: self.$selectedImage)
        
        Button("Import Image") {
          let panel = NSOpenPanel()
          panel.nameFieldLabel = "Load Restore Image:"
          panel.allowedContentTypes = [.init("com.apple.itunes.ipsw")!, .init("com.apple.iphone.ipsw")!]
          panel.isExtensionHidden = true
          panel.begin { response in
            guard let fileURL = panel.url, response == .OK else {
              return
            }
            object.loadImage(from: fileURL) { error in
              self.error = error
            }
            
          }
        }
      }.sheet(item: self.$selectedImage) { image in
        MachineView(from: image) { machine in
          self.selectedImage = nil
        }
      }
    }
}

struct ImagesView_Previews: PreviewProvider {
    static var previews: some View {
      TabView {
        ImagesView().environmentObject(AppObject(remoteImageFetcher: Self.previewImageFetch(_:))).tabItem {
          
          Label("Images", systemImage:  "externaldrive.fill")
        
      }
      }.frame(width: 500.0)
      
    }
}
