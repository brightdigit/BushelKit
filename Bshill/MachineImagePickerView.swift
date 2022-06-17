//
//  MachineImagePickerView.swift
//  Bshill
//
//  Created by Leo Dion on 6/16/22.
//

import SwiftUI


struct ImageItem : Identifiable, Hashable {
    let name : String
    
    var id: String {
        return name
    }
}
let images = [
    "001-desktop",
    "002-computer",
    "003-desktop-computer",
    "004-computer-1",
    "005-desktop-1",
    "006-settings",
    "007-computer-2",
    "008-pc",
    "009-imac",
    "010-old-computer",
    "011-laptop",
    "012-mac",
    "013-desktop-2",
    "014-macbook",
    "015-mac-mini",
    "016-mac-mini-1",
    "017-mac-1",
    "018-imac-1",
    "019-mac-pro",
    "020-computer-3",
    "021-monitor",
    "022-command",
    "042-data-server",
    "043-server",
    "044-server-1",
    "045-data-storage",
    "047-server-3",
    "048-data-center",
    "049-server-4",
    "050-mac-pro-1",
    "051-mac-pro-2",
    "052-imac-2",
    "053-computer-4",
    "084-macintosh-2",
    "091-ipod-1",
    "092-mp3",
    "082-macintosh",
    "083-macintosh-1",
    "085-lisa",
    "086-macintosh-3",
    "087-ipod",
    "088-ipod-shuffle",
    "089-ipod-nano",
    "090-ipod-shuffle-1",
    "newton"
].map(ImageItem.init)

struct MachineImagePickerView: View {
    internal init(images: [ImageItem], selectedImage: Binding<ImageItem>) {
        self.images = images
        self.originalImage = selectedImage.wrappedValue
        self._selectedImage = selectedImage
    }
    
    let images : [ImageItem]
    let originalImage : ImageItem
    @Binding var selectedImage : ImageItem
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(60.0)), GridItem(.fixed(60.0)), GridItem(.fixed(60.0)), GridItem(.fixed(60.0)),GridItem(.fixed(60.0))]) {
            ForEach(images) { image in
                Button {
                    self.selectedImage = self.selectedImage == image ? self.originalImage : image
                } label: {
                    ZStack(alignment: .topTrailing){
                        RoundedRectangle(cornerRadius: 4.0).opacity(self.selectedImage == image ? 1.0 : 0.0)
                        Image(image.name).resizable().aspectRatio(contentMode: .fit).padding(8.0)
                        Toggle(isOn: .init(get: {
                            self.selectedImage.id == image.id
                        }, set: { isSelected in
                            self.selectedImage = isSelected ? image : self.originalImage
                        })) {
                            EmptyView()
                        }.tint(Color.blue).toggleStyle(CheckboxToggleStyle()).labelsHidden().padding(4.0)
                    }
                }.buttonStyle(.borderless)

                
            }
        }
    }
}

struct MachineImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        MachineImagePickerView(images: images, selectedImage: .constant(.init(name: "085-lisa")))
    }
}
