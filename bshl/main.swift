//
//  main.swift
//  bshl
//
//  Created by Leo Dion on 12/17/20.
//

import BushelKit
import CoreFoundation

let loop = CFRunLoopGetCurrent()

let vm = try! Bushel.start()
vm.start { (result) in
  print(result)
  CFRunLoopStop(loop)
}
CFRunLoopRun()

