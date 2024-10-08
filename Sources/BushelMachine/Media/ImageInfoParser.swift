//
//  ImageInfoParser.swift
//  Bushel
//
//  Created by Leo Dion on 10/8/24.
//
public import Foundation

public protocol ImageInfoParser {
  func imageInfo(fromImage image: CaptureImage, toDirectory directoryURL: URL) async throws(RecordedImage.InfoError) -> RecordedImage
}
