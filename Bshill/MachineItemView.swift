//
//  MachineItemView.swift
//  Bshill
//
//  Created by Leo Dion on 6/16/22.
//

import SwiftUI

struct MachineItemView: View {
    @State var shouldDisplayIconPicker = false
    @State var machineIcon : ImageItem = .init(name: "085-lisa")
//    var name : String
//    var cpuCount : Int = 1
//    var memorySize : UInt64 = (4 * 1024 * 1024 * 1024)
//    var displays = [MachineDisplay(width: 1920, height: 1080, pixelsPerInch: 76)]
//    var disks = [MachineDisk(size: 64 * 1024 * 1024 * 1024)]
//    var networks = [MachineNetwork(type: .NAT, macAddress: .random)]
//    var shares = [MachineSharedDirectory]()
//    let sourceImage : RestoreImage<RestoreImageMetadataType>
//    let useHostAudio : Bool
    var body: some View {
        Form{
            Section(header: Text("Metadata")) {
                TextField("Name", text: .constant("Hello World")).padding()
                
                LabeledContent {
                    Button {
                        DispatchQueue.main.async {
                            self.shouldDisplayIconPicker = true
                        }
                        
                    } label: {
                        
                        Image(machineIcon.name).resizable().aspectRatio(contentMode: .fit)
                    }.buttonStyle(.plain)

                } label: {
                    Text("Icon")
                }.frame(height: 50)


                
            }
            
            Section(header: Text("Processor")){
                LabeledContent {
                    HStack{
                        TextField("CPUs", text: .constant("2.0")).frame(width: 40.0)
                        Slider(
                            value: .constant(2.0),
                            in: 1...5,
                            step: 1.0
                        ).padding(.horizontal)
                    }.labelsHidden()
                } label: {
                    Text("CPUs")
                }

                
                    LabeledContent {
                        HStack{
                            TextField("CPUs", text: .constant("8 GB")).frame(width: 40.0)
                            Slider(
                                value: .constant(2.0),
                                in: 1...5,
                                step: 1.0
                            ).padding(.horizontal)
                        }.labelsHidden()
                    } label: {
                        Text("Memory")
                    }
            }
            
            
            Section("Storage") {
                
                LabeledContent {
                    VStack(spacing: 0.0){
                        List{
                            
                        }
                        HStack(spacing: 0.0){
                            Button {
                                
                            } label: {
                                Image(systemName: "plus").resizable().aspectRatio(1.0,contentMode: .fit).frame(width: 12.0, height: 12.0).padding(8.0)
                            }.buttonStyle(.borderless)
                            Divider()
                            Button {
                                
                            } label: {
                                Image(systemName: "minus").resizable().aspectRatio(contentMode: .fit).frame(width: 12.0, height: 12.0).padding(8.0)
                            }.buttonStyle(.borderless)
                            Divider()
                            Spacer()
                        }
                    }.border(Color(NSColor.gridColor), width: 1)
                } label : {
                    Text("Disks")
                }
                
                LabeledContent {
                    List{
                        
                    }
                } label : {
                    Text("Shared Locations")
                }
            }
        
        }.padding().popover(isPresented: self.$shouldDisplayIconPicker) {
            MachineImagePickerView(images: images, selectedImage: self.$machineIcon)
        }
    }
}

struct MachineItemView_Previews: PreviewProvider {
    static var previews: some View {
        MachineItemView()
    }
}
