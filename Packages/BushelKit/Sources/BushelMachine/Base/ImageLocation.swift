//
// ImageLocation.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import Foundation

public enum ImageLocation {
  case remote(URL)
  case file(FileAccessor)
}
