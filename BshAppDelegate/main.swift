//
//  main.swift
//  BshAppDelegate
//
//  Created by Leo Dion on 6/21/22.
//

import AppKit
// 1
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// 2
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
