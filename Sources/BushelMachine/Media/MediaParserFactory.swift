//
//  MediaParserFactory.swift
//  BushelKit
//
//  Created by Leo Dion on 10/9/24.
//

public import Foundation


public struct MediaParserFactory : Sendable {
  
  public let getImageParser : @Sendable () -> any RecordedImageParser
  public let getVideoParser : @Sendable () -> any RecordedVideoParser
  
  
  public init(
    imageParser: @escaping @Sendable () -> any RecordedImageParser,
    videoParser: @escaping @Sendable () -> any RecordedVideoParser
  ) {
    self.getImageParser = imageParser
    self.getVideoParser = videoParser
  }
}

private struct DefaultVideoParser : RecordedVideoParser {
  func videoInfo(fromVideo video: CaptureVideo, toDirectory directoryURL: URL) async throws(RecordedVideoError) -> RecordedVideo {
    assertionFailure("Not Implemented.")
    throw .notImplmented
  }
  static let `default` : DefaultVideoParser = .init()
}

extension MediaParserFactory {
  
  public init (
    fileManager: @Sendable @escaping () -> FileManager = {.default},
    cgSizeFromURL: @Sendable @escaping (URL) -> CGSize?,
    videoParser:  @escaping @Sendable () -> any RecordedVideoParser
  ) {
    self.init(imageParser: {
      ImageFileParser(fileManager: fileManager(), cgSizeFromURL: cgSizeFromURL)
    }, videoParser: videoParser)

  }
  
  private static func defaultCGSizeFromURL (_ url: URL) -> CGSize? {
    assertionFailure("Not Implemented.")
    return nil
  }
 public static let `default` : MediaParserFactory = .init {
    ImageFileParser(
      fileManager: .default,
      cgSizeFromURL: defaultCGSizeFromURL(_:)
    )
  } videoParser: {
    DefaultVideoParser.default
      
  }

}
