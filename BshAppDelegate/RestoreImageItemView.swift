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


struct ActionButtonStyle : PrimitiveButtonStyle {
    internal init(type: ActionButtonStyle.ActionType = .plain) {
        self.type = type
    }
    
    let type : ActionType
    enum ActionType {
        case plain
        case warning
        case error
    }
    
    var foregroundColor : Color {
        switch self.type {
        case .warning:
            return .red
        case .plain:
            return .blue
        case .error:
            return .primary
        }
    }
    
    var backgroundColor: Color {
        switch self.type {
        case .warning:
                return .yellow
        case .plain:
            return .primary
        case .error:
            return .red
        }
    }
    func makeBody(configuration: Configuration) -> some View {
        
        VStack(spacing: 4.0){
            configuration.label
        }
        .textCase(Text.Case.uppercase)
        .padding(.vertical, 12.0)
        .frame(maxWidth: .infinity)
        .background(self.backgroundColor)
        .foregroundColor(self.foregroundColor)
        .aspectRatio(1.0, contentMode: .fit)
        .cornerRadius(8.0)
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
        
        ZStack(alignment: .bottom){
            HStack{
                Image(self.image.imageName).resizable().padding().aspectRatio(contentMode: .fit)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(self.image.name).font(.title)
                    HStack(alignment: .firstTextBaseline) {
                        Text(self.image.operatingSystemVersion.description).fontWeight(.light)
                        Text(self.image.buildVersion).font(.caption).fontWeight(.light)
                    }
                    Text(self.image.providedSourceText).font(.caption2)
                    Text(self.image.size).font(.callout).fontWeight(.bold)
                }
                Spacer()
                Group {
                    if !self.image.isSupported {
                        Button {
                            
                        } label: {
                            Image(systemName: "exclamationmark.triangle.fill").resizable().aspectRatio(contentMode: .fit).padding(4.0)
                            Text("Unsupported").font(Font.system(size: 9.0))
                        }.buttonStyle(ActionButtonStyle(type: .warning))
                        
                    } else if self.image.localURL != nil {
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "hammer.fill").resizable().aspectRatio(contentMode: .fit).padding(4.0)
                            Text("Build").fontWeight(.bold)
                        }.buttonStyle(ActionButtonStyle())
                        
                    } else if self.image.remoteURL != nil {
                        
                        Button {
                            
                        } label: {
                                Image(systemName: "arrow.down.to.line").resizable().aspectRatio(contentMode: .fit).padding(4.0)
                                Text("Get").fontWeight(.bold)
                            
                        }.buttonStyle(ActionButtonStyle())
                        
                    } else  {
                        
                        Button {
                            
                        } label: {
                                Image(systemName: "xmark.octagon.fill").resizable().aspectRatio(contentMode: .fit).padding(4.0)
                                Text("Error").fontWeight(.bold)
                            
                        }.buttonStyle(ActionButtonStyle(type: .error))
                        
                    }
                }.padding(20.0).buttonStyle(.plain)
            }.frame(maxWidth: .infinity, maxHeight: 120.0)
            
//            ProgressView.init(value: 0.5) {
//                Text("Downloading...")
//            } currentValueLabel: {
//                Text("50%")
//            }.padding(.horizontal).padding(.bottom)
        }
    }
}

struct RestoreImageItemView_Previews: PreviewProvider {
    fileprivate static let remotePreviewItem : RestoreImage =  .init(name: "Lorem Ipsum", imageName: "059-mountains", remoteURL: .init(string: "https://apple.com")!, localURL: nil, buildVersion: "22A5266r", operatingSystemVersion: .init(majorVersion: 11, minorVersion: 5, patchVersion: 2), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16000000000, lastModified: .now, isSupported: true)
    
    fileprivate static let localPreviewItem : RestoreImage =  .init(name: "Speculid Tester", imageName: "077-cheese", remoteURL: nil, localURL: .init(string: "https://apple.com")!, buildVersion: "22A5266r", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16500000000, lastModified: .now, isSupported: true)
    
    fileprivate static let unsupportedPreviewItem : RestoreImage =  .init(name: "Unsupported Ventura", imageName: "080-kitty", remoteURL: nil, localURL: .init(string: "https://apple.com")!, buildVersion: "22A5266r", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16500000000, lastModified: .now, isSupported: false)
    
    fileprivate static let outlierPreviewItem : RestoreImage =  .init(name: "Strange Ventura", imageName: "054-san-diego", remoteURL: nil, localURL: nil, buildVersion: "22A5266r", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16500000000, lastModified: .now, isSupported: true)
    
    static var previews: some View {
        List{
            RestoreImageItemView(image: Self.remotePreviewItem)
            
            RestoreImageItemView(image: Self.localPreviewItem)
            
            
            RestoreImageItemView(image: Self.unsupportedPreviewItem)
            
            RestoreImageItemView(image: Self.outlierPreviewItem)
        }.previewLayout(.fixed(width: 500, height: 500))
    }
}

