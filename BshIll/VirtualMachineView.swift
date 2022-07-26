//
//  VirtualMachineView.swift
//  BshIll
//
//  Created by Leo Dion on 7/25/22.
//

import Foundation
import SwiftUI
import Virtualization

struct VirtualMachineView : NSViewRepresentable {
    let virtualMachine : VZVirtualMachine
    func makeNSView(context: Context) -> VZVirtualMachineView {
        let view = VZVirtualMachineView(frame: .init(origin: .zero, size: .init(width: 1920, height: 1080)))
        view.virtualMachine = virtualMachine
        
        return view
    }
    
    func updateNSView(_ nsView: VZVirtualMachineView, context: Context) {
        
    }
    
    typealias NSViewType = VZVirtualMachineView
    
    
}
