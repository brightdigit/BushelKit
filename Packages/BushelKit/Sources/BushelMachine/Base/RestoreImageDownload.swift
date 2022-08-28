//
// RestoreImageDownload.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import Foundation

public enum RestoreImageDownload {
  case file(URL)
  case library(URL, UUID)
}
