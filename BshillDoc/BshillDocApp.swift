//
//  BshillDocApp.swift
//  BshillDoc
//
//  Created by Leo Dion on 6/18/22.
//

import SwiftUI

@main
struct BshillDocApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: BshillDocDocument()) { file in
            MachineDialogView(document: file.$document)
        }
    }
}
