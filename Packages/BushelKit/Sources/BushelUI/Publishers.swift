//
// Publishers.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation
import HarvesterKit

#if canImport(Combine)
  import Combine

  public extension Publishers {
    typealias MapDocumentContext<Upstream: Publisher, OutputType: DocumentContextual> =
      Publishers.CompactMap<FilterMap<Upstream, URL>, OutputType>
  }

#endif
