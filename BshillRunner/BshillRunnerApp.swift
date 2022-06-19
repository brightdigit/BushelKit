//
//  BshillRunnerApp.swift
//  BshillRunner
//
//  Created by Leo Dion on 6/19/22.
//

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

@main
struct BshillRunnerApp: App {
    @State var startingMachine : VZVirtualMachine?
    var body: some Scene {
        
        WindowGroup {
            ContentView(startedMachine: self.$startingMachine)
        }
        WindowGroup{
            Group{
                if let activeMachine = startingMachine {
                    VirtualMachineView(virtualMachine: activeMachine)
                }
            }
        }
    }
}
