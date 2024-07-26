//
// HubObject.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))

  public import BushelCore

  public import BushelHub
  import BushelLogging

  public import Foundation

  @MainActor
  @Observable
  internal final class HubObject: Loggable, Sendable {
    internal nonisolated static var loggingCategory: BushelLogging.Category {
      .observation
    }

    internal var hubs: [Hub]

    internal var selectedHub: Hub? {
      didSet {
        self.invalidate()
      }
    }

    internal private(set) var selectedImage: HubImage?

    internal private(set) var hubImages = [Hub.ID: [HubImage]]() {
      didSet {
        invalidate()
      }
    }

    internal private(set) var images: [HubImage]?
    internal private(set) var error: (any Error)?

    internal var selectedHubID: Hub.ID? {
      didSet {
        let hub: Hub? = if let selectedHubID {
          hubs.first(where: {
            $0.id == selectedHubID
          })
        } else {
          nil
        }
        self.selectedImageID = nil
        self.selectedHub = hub
      }
    }

    internal var selectedImageID: HubImage.ID? {
      didSet {
        guard let selectedImageID else {
          return
        }
        guard let images = self.images else {
          let error: HubError = .missingImagesForID(selectedImageID)
          assertionFailure(error: error)
          Self.logger.error("No images to find: \(error)")
          self.error = error
          return
        }
        guard let selectedImage = images.first(where: { $0.id == selectedImageID }) else {
          let error: HubError = .imageNotFoundWithID(selectedImageID)
          assertionFailure(error: error)
          Self.logger.error("image not found: \(error)")
          self.error = error
          return
        }
        self.selectedImage = selectedImage
      }
    }

    internal init(
      hubs: [Hub] = [],
      selectedHub: Hub? = nil,
      selectedImage: HubImage? = nil,
      selectedImageID: HubImage.ID? = nil
    ) {
      self.hubs = hubs
      self.selectedHub = selectedHub
      self.selectedImage = selectedImage
      self.selectedImageID = selectedImageID
    }

    private func invalidate() {
      if let selectedHub {
        if let images = self.hubImages[selectedHub.id] {
          self.images = images
          self.error = nil
        } else {
          self.images = nil
          self.error = nil
          Task {
            let images: [HubImage]
            do {
              images = try await selectedHub.getImages()
            } catch {
              self.error = error
              return
            }
            self.hubImages[selectedHub.id] = images
            self.images = images
            self.error = nil
          }
        }
      } else {
        self.images = nil
        self.error = nil
        self.selectedImageID = nil
      }
    }
  }
#endif
