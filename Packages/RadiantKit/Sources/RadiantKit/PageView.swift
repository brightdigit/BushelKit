//
// PageView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @MainActor
  public struct PageView: View, Sendable {
    @Environment(\.dismiss) var dismiss
    @State private var currentPageID: IdentifiableView.ID?

    private let onDimiss: (@MainActor @Sendable (DismissParameters) -> Void)?
    private let pages: [IdentifiableView]

    public var pageNavigationAvailability: PageNavigationAvailability {
      switch (currentPageID, currentPageID == pages.first?.id, currentPageID == pages.last?.id) {
      case (.none, _, _), (.some, true, true):
        .none

      case (.some, false, false):
        .both

      case (.some, false, true):
        .previous

      case (.some, true, false):
        .next
      }
    }

    public var body: some View {
      ForEach(pages) { page in
        if page.id == currentPageID {
          AnyView(
            page.content
              .environment(\.pageNavigationAvailability, pageNavigationAvailability)
              .environment(\.nextPage, NextPageAction { showNextPage() })
              .environment(\.previousPage, PreviousPageAction { showPreviousPage() })
              .environment(\.cancelPage, CancelPageAction { cancelPage() })
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if currentPageID == nil, !pages.isEmpty {
          Color.clear.onAppear {
            currentPageID = pages.first?.id
          }
        }
      }
    }

    public init(
      onDismiss: (@MainActor @Sendable (DismissParameters) -> Void)? = nil,
      @IdentifiableViewBuilder _ pagesBuilder: () -> [IdentifiableView]
    ) {
      self.init(pages: pagesBuilder(), onDismiss: onDismiss)
    }

    public init(pages: [IdentifiableView], onDismiss: (@Sendable @MainActor (DismissParameters) -> Void)?) {
      self.pages = pages
      onDimiss = onDismiss

      _currentPageID = State(
        initialValue: pages.first?.id
      )
    }

    private func cancelPage() {
      guard
        let currentIndex = pages.firstIndex(where: { $0.id == self.currentPageID })
      else {
        return
      }
      onDimiss?(.init(currentPageIndex: currentIndex, currentPageID: currentPageID, action: .cancel))
    }

    private func showNextPage() {
      guard
        let currentIndex = pages.firstIndex(where: { $0.id == self.currentPageID })
      else {
        return
      }
      let nextIndex = currentIndex + 1
      guard nextIndex < pages.count else {
        assert(pages.count == nextIndex)

        if pages.count != nextIndex {
          // Self.logger.error("Invalid page index \(nextIndex) > \(pages.count)")
        }

        onDimiss?(.init(currentPageIndex: currentIndex, currentPageID: currentPageID, action: .next))
        // dismiss()

        return
      }
      currentPageID = pages[currentIndex + 1].id
    }

    private func showPreviousPage() {
      guard
        let currentIndex = pages.firstIndex(where: { $0.id == self.currentPageID })
      else {
        return
      }
      let previousIndex = currentIndex - 1
      guard previousIndex >= 0 else {
        assert(previousIndex == 0)

        if previousIndex != 0 {
          // Self.logger.error("Invalid page index \(nextIndex) > \(pages.count)")
        }

        onDimiss?(.init(currentPageIndex: currentIndex, currentPageID: currentPageID, action: .previous))
        dismiss()

        return
      }
      currentPageID = pages[currentIndex - 1].id
    }
  }
#endif
