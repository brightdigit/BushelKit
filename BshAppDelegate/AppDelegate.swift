//
//  AppDelegate.swift
//  BshAppDelegate
//
//  Created by Leo Dion on 6/20/22.
//

import Cocoa
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
class AppDelegate: NSObject, NSApplicationDelegate, VZVirtualMachineDelegate {
  private var installationObserver: NSKeyValueObservation?
  var window: NSWindow!
  var machineViewWindows = [NSWindow]()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
      let view = ContentView(installWith: self.beingInstall, startMachine: self.startMachine(_:))
    let hostingController = NSHostingController(rootView: view)
    let window = NSWindow(contentViewController: hostingController)
    window.makeKeyAndOrderFront(self)
    self.window = window
  }
  
    fileprivate func startMachine(_ machine: VZVirtualMachine) {
        let view = VirtualMachineView(virtualMachine: machine)
        machine.delegate = self
        let hostingController = NSHostingController(rootView: view)
        let window = NSWindow(contentViewController: hostingController)
        window.setFrame(.init(x: 0, y: 0, width: 1920, height: 1080), display: true)
        window.center()
        window.makeKeyAndOrderFront(self)
        machineViewWindows.append(window)
        machine.start { result in
            let error: Error?
            do {
                try result.get()
                error = nil
            } catch let caughtError {
                error = caughtError
            }
            dump(error)
        }
    }
  fileprivate func installer(_ installer: VZMacOSInstaller) {
    
    NSLog("Starting installation.")
    installer.install(completionHandler: { (result: Result<Void, Error>) in
      if case let .failure(error) = result {
        fatalError(error.localizedDescription)
      } else {
        NSLog("Installation succeeded.")
      }
    })
    
    
    // Observe installation progress
    installationObserver = installer.progress.observe(\.fractionCompleted, options: [.initial, .new]) { (progress, change) in
      NSLog("Installation progress: \(change.newValue! * 100).")
    }
  }
  
  func beingInstall(withImage restoreImage: VZMacOSRestoreImage, toMachine machine: VZVirtualMachine) {

      let view = VirtualMachineView(virtualMachine: machine)
      machine.delegate = self
      
    
    DispatchQueue.main.async {
      let installer = VZMacOSInstaller(virtualMachine: machine, restoringFromImageAt:restoreImage.url)
      self.installer(installer)
    }
    
  }
  
  func virtualMachine(_ virtualMachine: VZVirtualMachine, didStopWithError error: Error) {
    print(error)
  }
  
  func virtualMachine(_ virtualMachine: VZVirtualMachine, networkDevice: VZNetworkDevice, attachmentWasDisconnectedWithError error: Error) {
    print(error)
  }
  
  

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }


}

