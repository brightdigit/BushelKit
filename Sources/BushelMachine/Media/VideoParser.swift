//
//  VideoParser.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//
public import Foundation

public protocol VideoParser  {
  func videoInfo(fromVideo video: CaptureVideo, toDirectory directoryURL: URL) async throws (RecordedVideo.InfoError) -> RecordedVideo

}
