//
// CMSampleBuffer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(CoreMedia) && canImport(ScreenCaptureKit)

  import CoreMedia
  import ScreenCaptureKit

  extension CMSampleBuffer {
    struct Metrics {
      let contentScale: CGFloat
    }

    enum AttachmentStatus {
      case active(Metrics)
      case complete
    }

    var attachmentStatus: AttachmentStatus? {
      guard let attachmentsArray = CMSampleBufferGetSampleAttachmentsArray(
        self,
        createIfNecessary: false
      ) as?
        [[SCStreamFrameInfo: Any]],
        let attachments = attachmentsArray.first else {
        return nil
      }
      guard
        let statusRawValue = attachments[SCStreamFrameInfo.status] as? Int,
        let status = SCFrameStatus(rawValue: statusRawValue),
        status == .complete else {
        return .complete
      }

      // Retrieve the content rectangle, scale, and scale factor.
      guard
        let contentScale = attachments[.contentScale] as? CGFloat else {
        return nil
      }

      return .active(.init(contentScale: contentScale))
    }
  }
#endif
