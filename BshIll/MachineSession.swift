//
//  MachineDisplayView.swift
//  BshIll
//
//  Created by Leo Dion on 7/16/22.
//

import SwiftUI
import Virtualization

protocol MachineSession {
  func begin() async throws
}
