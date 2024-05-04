//
// SpecificationTemplate.swift
// Copyright (c) 2024 BrightDigit.
//

//
//  SpecificationTemplateButton.swift
//  PageViewController
//
//  Created by Leo Dion on 3/12/24.
//
#if canImport(SwiftUI)
  import BushelFactory
  import BushelLocalization
  import SwiftUI

  extension Array where Element == SpecificationTemplate<LocalizedStringID> {
    static var options: Self {
      Specifications.Options.all
    }
  }

  extension SpecificationTemplate where Name == LocalizedStringID {
    static var basic: Self {
      Specifications.Options.basic
    }
  }
#endif
