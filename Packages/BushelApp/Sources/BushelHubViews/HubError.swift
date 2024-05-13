//
// HubError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import Foundation

public enum HubError: LocalizedError {
  case missingImagesForID(HubImage.ID)
  case imageNotFoundWithID(HubImage.ID)
}
