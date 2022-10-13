//
// Publisher.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation
import HarvesterKit

#if canImport(Combine)
  import Combine

  public extension Publisher {
    func map<OutputType: DocumentContextual>(
      _: OutputType.Type,
      onFailure failure: @escaping (URL, Error) -> Void
    ) -> Publishers.MapDocumentContext<Self, OutputType>
      where Self.Output == DocumentURL {
      filter({ $0.type == OutputType.type }, map: \.url)
        .tryMap(OutputType.fromURL, onFailure: failure)
    }

    func encodeResult<Coder: TopLevelEncoder, ElementType: UserDefaultsCodable>(
      encoder: Coder = Configuration.Defaults.encoder
    ) ->
      // swiftlint:disable line_length
      Publishers.AsResultSet<
        Publishers.Map<Publishers.SharedCompactMapOnlySuccess<Publishers.Encode<Self, Coder>>, UserDefaultData>,
        Publishers.SharedCompactMapOnlyFailure<Publishers.Encode<Self, Coder>>
      >
      // swiftlint:enable line_length
      where Self.Output: Collection, Coder.Output == Data, Self.Output.Element == ElementType {
      encode(encoder: encoder)
        .asResultSet()
        .map(ElementType.key.data(_:))
    }
  }

#endif
