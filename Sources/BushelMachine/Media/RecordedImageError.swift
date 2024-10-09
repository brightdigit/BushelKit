//
//  InfoError.swift
//  BushelKit
//
//  Created by Leo Dion on 10/9/24.
//


public enum RecordedImageError: Error {
  case missingField(RecordedImage.Field)
  case innerError(Error)
}
