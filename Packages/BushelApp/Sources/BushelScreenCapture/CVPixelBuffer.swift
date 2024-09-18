//
// CVPixelBuffer.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(CoreVideo) && canImport(Accelerate)
  import Accelerate
  import CoreVideo

  extension CVPixelBuffer {
    private func withPointer(
      _ pointer: UnsafeMutableRawPointer,
      targetWith: Int,
      targetHeight: Int,
      targetImageRowBytes: Int
    ) throws(CVPixelBufferError) -> CVPixelBuffer {
      let pixelBufferType = CVPixelBufferGetPixelFormatType(self)
      let releaseCallBack: CVPixelBufferReleaseBytesCallback = { _, pointer in
        if let pointer {
          free(UnsafeMutableRawPointer(mutating: pointer))
        }
      }

      // swiftlint:disable:next implicitly_unwrapped_optional
      var targetPixelBuffer: CVPixelBuffer!
      let conversionStatus = CVPixelBufferCreateWithBytes(
        nil,
        targetWith,
        targetHeight,
        pixelBufferType,
        pointer,
        targetImageRowBytes,
        releaseCallBack,
        nil,
        nil,
        &targetPixelBuffer
      )

      guard conversionStatus == kCVReturnSuccess else {
        free(pointer)
        throw .conversionFailure(Int(conversionStatus))
      }

      return targetPixelBuffer
    }

    internal func crop(to rect: CGRect) throws(CVPixelBufferError) -> CVPixelBuffer {
      CVPixelBufferLockBaseAddress(self, .readOnly)
      defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }

      guard let baseAddress = CVPixelBufferGetBaseAddress(self) else {
        throw .missingBaseAddress
      }

      let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)

      let imageChannels = 4
      let startPos = Int(rect.origin.y) * inputImageRowBytes + imageChannels * Int(rect.origin.x)
      let outWidth = UInt(rect.width)
      let outHeight = UInt(rect.height)
      let croppedImageRowBytes = Int(outWidth) * imageChannels

      var inBuffer = vImage_Buffer()
      inBuffer.height = outHeight
      inBuffer.width = outWidth
      inBuffer.rowBytes = inputImageRowBytes

      inBuffer.data = baseAddress + UnsafeMutableRawPointer.Stride(startPos)

      guard let croppedImageBytes = malloc(Int(outHeight) * croppedImageRowBytes) else {
        throw .allocationFailure
      }

      var outBuffer = vImage_Buffer(
        data: croppedImageBytes,
        height: outHeight,
        width: outWidth,
        rowBytes: croppedImageRowBytes
      )

      let scaleError = vImageScale_ARGB8888(&inBuffer, &outBuffer, nil, vImage_Flags(0))

      guard scaleError == kvImageNoError else {
        free(croppedImageBytes)

        throw .scalingFailure(scaleError)
      }

      return try self.withPointer(
        croppedImageBytes,
        targetWith: Int(outWidth),
        targetHeight: Int(outHeight),
        targetImageRowBytes: croppedImageRowBytes
      )
    }
  }
#endif
