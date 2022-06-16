//
//  RestoreImageItemView.swift
//  Bshill
//
//  Created by Leo Dion on 6/16/22.
//

import SwiftUI

extension OperatingSystemVersion : CustomStringConvertible {
    public var description: String {
        String([self.majorVersion, self.minorVersion, self.patchVersion].map(String.init).joined(separator: "."))
    }
}


struct RestoreImage {
    let name : String
    let imageName : String
    let remoteURL : URL?
    let localURL : URL?
    let buildVersion : String
    let operatingSystemVersion : OperatingSystemVersion
    let sha256 : SHA256
    //let restoreImage: RestoreImageMetadataType
    let contentLength : Int
    let lastModified: Date
    let isSupported : Bool
}

extension RestoreImage {
    var providedSourceText : String {
        if remoteURL != nil {
            return "Provided By Apple"
        } else {
            return "Imported Image"
        }
    }
    
    
      var size : String {
        let formatter = ByteCountFormatter()
        return formatter.string(from: .init(value: .init(self.contentLength), unit: .bytes))
    
      }
}

struct RestoreImageItemView: View {
    let image : RestoreImage
    var body: some View {
        
        VStack{
            HStack{
                Image(self.image.imageName).resizable().padding().aspectRatio(contentMode: .fit)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(self.image.name).font(.title)
                    HStack(alignment: .firstTextBaseline) {
                        Text(self.image.operatingSystemVersion.description)
                        Text(self.image.buildVersion).font(.caption)
                    }.fontWeight(.light)
                    Text(self.image.providedSourceText).font(.caption2)
                    Text(self.image.size).font(.callout).fontWeight(.bold)
                }
                Spacer()
                Group {
                    if !self.image.isSupported {
                        Button {
                            
                        } label: {
                            Image(systemName: "exclamationmark.triangle.fill")
                        }
                        
                    } else if self.image.localURL != nil {
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "hammer.fill")
                        }
                        
                    } else if self.image.remoteURL != nil {
                        
                        Button {
                            
                        } label: {
                            VStack(spacing: 4.0){
                                Image(systemName: "arrow.down.to.line").resizable().aspectRatio(contentMode: .fit).padding(4.0)
                                Text("Get").fontWeight(.bold)
                            }.textCase(Text.Case.uppercase).padding(12.0).background(Color.white).foregroundColor(.blue).cornerRadius(8.0)
                        }
                        
                    }
                }.padding(12.0).buttonStyle(.plain)
            }.frame(maxWidth: .infinity, maxHeight: 120.0)
            ProgressView(value: 0.5).padding(.horizontal)
        }
    }
}

struct RestoreImageItemView_Previews: PreviewProvider {
    static var previews: some View {
        RestoreImageItemView(image: .init(name: "Lorem Ipsum", imageName: "059-mountains", remoteURL: .init(string: "https://apple.com")!, localURL: nil, buildVersion: "22A5266r", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16000000000, lastModified: .now, isSupported: true))
    }
}

