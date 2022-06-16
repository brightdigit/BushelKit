//
//  ImageList.swift
//  Bushel
//
//  Created by Leo Dion on 5/29/22.
//

import SwiftUI

struct ImageList<RestoreImageMetadataType: RestoreImageMetadata>: View {
    let images : [RestoreImage<RestoreImageMetadataType>]
  @Binding var imageBinding : RestoreImage<RestoreImageMetadataType>?
  
  var body: some View {

      List(images, selection: self.$imageBinding) { image in
        
        RestoreImageView(machineImage: _imageBinding, image: image)

        }
      
    }
}

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
      ImageList<PreviewRestoreImageMetadata>(images: [PreviewModel.previewRemoteModel], imageBinding: .constant(nil))
    }
}
