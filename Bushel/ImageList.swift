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
//  fileprivate func imageView(_ image: LocalImage) -> some View {
//    return HStack{
//      ZStack{
//        Rectangle().strokeBorder(.secondary).opacity(0.50)
//        Rectangle().fill(Color.secondary.opacity(0.25))
//        Image(systemName: "applelogo").resizable().aspectRatio(contentMode: .fit).padding(8.0)
//      }.aspectRatio(1.0, contentMode: .fit).padding(8.0)
//      VStack(alignment: .leading){
//        Text(image.name).font(.largeTitle)
//        Text(image.operatingSystemVersion.description)
//        Text(image.buildVersion)
//        Text(image.url.absoluteString)
//
//      }
//
//    }.padding().frame(height: 120.0, alignment: .center)
//  }
  
  var body: some View {

      List(images, selection: self.$imageBinding) { image in
        
        LocalImageView(image: image)

        }
      
    }
}

struct ImageList_Previews: PreviewProvider {
    static var previews: some View {
      ImageList(images: [.previewModel], imageBinding: .constant(nil))
    }
}
