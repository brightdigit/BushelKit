//
//  ContentView.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import SwiftUI

enum MachinePreparationState : Int, Identifiable {
  var id: RawValue {
    self.rawValue
  }
  
  case building
  case installing
}
