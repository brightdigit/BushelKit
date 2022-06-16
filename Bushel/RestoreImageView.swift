//
//  LocalImageView.swift
//  Bushel
//
//  Created by Leo Dion on 6/1/22.
//

import SwiftUI

struct RestoreImageView<RestoreImageMetadataType: RestoreImageMetadata>: View {
  @Binding var machineImage : RestoreImage<RestoreImageMetadataType>?
  let image : RestoreImage<RestoreImageMetadataType>
  
    var body: some View {
      HStack{
        ZStack{
          Rectangle().strokeBorder(.secondary).opacity(0.50)
          Rectangle().fill(Color.secondary.opacity(0.25))
            Image(image.imageName ).resizable().aspectRatio(contentMode: .fit).padding(8.0)
        }.aspectRatio(1.0, contentMode: .fit).padding(8.0)
        VStack(alignment: .leading){
          Text(image.name).font(.largeTitle)
          Text(image.operatingSystemVersion.description)
          Text(image.buildVersion)
          //Text(image.localURL.absoluteString)
          
        }
        
          Group {
              if self.image.isDownloaded && self.image.isSupported == true{
                  Button("Create Machine") {
                    self.machineImage = self.image
                  }
              } else if self.image.isSupported == true {
                  Button("Download Image") {
                    self.machineImage = self.image
                  }
              } else {
                  Button("Unsupported Image") {
                    self.machineImage = self.image
                  }
              }
          }
        
        
      }.padding().frame(height: 120.0, alignment: .center)
    }
}

struct LocalImageView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            RestoreImageView<RestoreImageMetadataType>(machineImage: .constant(nil), image: .previewRemoteModel)
        }
    }
}
