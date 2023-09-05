//
// HubError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelHub
import Foundation

public enum HubError: LocalizedError {
  case missingImagesForID(HubImage.ID)
  case imageNotFoundWithID(HubImage.ID)
}
