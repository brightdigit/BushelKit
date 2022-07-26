//
//  MachineView.swift
//  BshIll
//
//  Created by Leo Dion on 7/18/22.
//

import SwiftUI

struct MachineView: View {
  @Binding var document: MachineDocument
  var url : URL?
  let restoreImageChoices : [MachineRestoreImage]
    var body: some View {
      Group{
        if !document.machine.isBuilt || document.machine.operatingSystem == nil {
          MachineSetupView(document: self.$document, url: self.url, restoreImageChoices: restoreImageChoices, onCompleted: nil)
        } else if let url = self.url {
          MachineSessionView(document: self.$document, url: url)
        }
      }.onAppear {
        self.document.sourceURL = url
      }
    }
}

//struct MachineView_Previews: PreviewProvider {
//    static var previews: some View {
//        MachineView()
//    }
//}
