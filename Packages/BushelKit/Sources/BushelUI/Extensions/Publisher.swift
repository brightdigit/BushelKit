//
// Publisher.swift
// Copyright (c) 2022 BrightDigit.
//

import Combine

extension Publisher {
  func result() -> some Publisher<Result<Output, Failure>, Never> {
    map(Result<Output, Failure>.success).catch { error in
      Just(Result.failure(error))
    }
  }
}
