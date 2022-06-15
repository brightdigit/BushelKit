//
//  LocalImageView.swift
//  Bushel
//
//  Created by Leo Dion on 6/1/22.
//

import SwiftUI

struct LocalImageView: View {
  @Binding var machineImage : RestoreImage?
  let image : RestoreImage
  
    var body: some View {
      HStack{
        ZStack{
          Rectangle().strokeBorder(.secondary).opacity(0.50)
          Rectangle().fill(Color.secondary.opacity(0.25))
          Image(systemName: "applelogo").resizable().aspectRatio(contentMode: .fit).padding(8.0)
        }.aspectRatio(1.0, contentMode: .fit).padding(8.0)
        VStack(alignment: .leading){
          Text(image.name).font(.largeTitle)
          Text(image.operatingSystemVersion.description)
          Text(image.buildVersion)
          //Text(image.localURL.absoluteString)
          
        }
        Button("Create Machine") {
          self.machineImage = self.image
        }.disabled(image.isSupported == false)
        
      }.padding().frame(height: 120.0, alignment: .center)
    }
}

struct LocalImageView_Previews: PreviewProvider {
    static var previews: some View {
      LocalImageView(machineImage: .constant(nil), image: .previewModel)
    }
}
