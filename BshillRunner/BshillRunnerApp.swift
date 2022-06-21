//
//  BshillRunnerApp.swift
//  BshillRunner
//
//  Created by Leo Dion on 6/19/22.
//

import SwiftUI
import Virtualization
extension View {
  private func newWindowInternal(title: String, geometry: NSRect, style: NSWindow.StyleMask, delegate: NSWindowDelegate?) -> NSWindow {
    let window = NSWindow(
      contentRect: geometry,
      styleMask: style,
      backing: .buffered,
      defer: false)
    window.center()
    window.isReleasedWhenClosed = false
    window.title = title
    window.makeKeyAndOrderFront(nil)
    window.delegate = delegate
    return window
  }
   
  func openNewWindow(title: String, delegate: NSWindowDelegate?, geometry: NSRect = NSRect(x: 20, y: 20, width: 640, height: 480), style:NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]) -> Self {
    self.newWindowInternal(title: title, geometry: geometry, style: style, delegate: delegate).contentView = NSHostingView(rootView: self)
      return self
  }
}
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

struct VirtualMachineViewWindow : View {
    let virtualMachine : VZVirtualMachine
    var body: some View {
        VirtualMachineView(virtualMachine: virtualMachine)
    }
}

@main
struct BshillRunnerApp: App {
    @State var startingMachine : VZVirtualMachine?
    var body: some Scene {
        
        WindowGroup {
            ContentView(startedMachine: self.$startingMachine)
        }
        WindowGroup("Hello"){
                if let activeMachine = startingMachine {
                    Text("\(activeMachine.debugDescription)").openNewWindow(title: "test", delegate: nil)
                }

        }
    }
}
