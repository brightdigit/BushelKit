//
//  RrisCollectionView.swift
//  BshIll
//
//  Created by Leo Dion on 6/26/22.
//

import SwiftUI
import Virtualization
import Combine
struct RrisCollectionView: View {
    
    init () {
    }
    @StateObject var selectedSourceObject  = RrisCollectionObject()
    @State var selectedImage : RestoreImage? = nil
    var body: some View {
        NavigationView {
            
                List{
                    ForEach(self.selectedSourceObject.sources) { source in
                        NavigationLink {
                            SourceImageCollectionView(source:source)
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
