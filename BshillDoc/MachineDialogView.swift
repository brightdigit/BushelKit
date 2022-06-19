//
//  ContentView.swift
//  BshillDoc
//
//  Created by Leo Dion on 6/18/22.
//

import SwiftUI

struct MachineDialogView: View {
    @Binding var document: BshillDocDocument
    

    var body: some View {
        NavigationSplitView {
            List{
                DisclosureGroup("Disks") {
                    ForEach(document.disks) { disk in
                        Text(disk.name)
                    }
                }
            }
        } detail: {
            
        }

    }
}

struct MachineDialogView_Previews: PreviewProvider {
    static var previews: some View {
        MachineDialogView(document: .constant(BshillDocDocument()))
    }
}
