//
//  ImageList.swift
//  Bushel
//
//  Created by Leo Dion on 5/29/22.
//

import SwiftUI

struct ImageList: View {
  let images : [LocalImage]
  @Binding var imageBinding : LocalImage?
  
  var body: some View {

      List(images, selection: self.$imageBinding) { image in
        
        LocalImageView(machineImage: _imageBinding, image: image)

        }
      
    }
}

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
      ImageList(images: [.previewModel], imageBinding: .constant(nil))
    }
}
