//
// PageView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import SwiftUI

  public struct PageView: View, LoggerCategorized {
    @Environment(\.dismiss) var dismiss
    @State private var currentPageID: IdentifiableView.ID?

    private let onDimiss: (() -> Void)?
    private let pages: [IdentifiableView]

    public var body: some View {
      ForEach(pages) { page in
        if page.id == currentPageID {
          AnyView(
            page.content
              .environment(\.nextPage, NextPageAction(self.showNextPage))
          )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if currentPageID == nil, !pages.isEmpty {
          Color.clear.onAppear {
            self.currentPageID = pages.first?.id
          }
        }
      }.transition(
        AnyTransition.asymmetric(
          insertion: .move(edge: .trailing),
          removal: .move(edge: .leading)
        )
      )
      .animation(.linear, value: UUID())
    }

    public init(
      onDismiss: (() -> Void)? = nil,
      @IdentifiableViewBuilder _ pagesBuilder: () -> [IdentifiableView]
    ) {
      self.init(pages: pagesBuilder(), onDismiss: onDismiss)
    }

    init(pages: [IdentifiableView], onDismiss: (() -> Void)?) {
      self.pages = pages
      self.onDimiss = onDismiss

      self._currentPageID = State(
        initialValue: pages.first?.id
      )
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
          Self.logger.error("Invalid page index \(nextIndex) > \(pages.count)")
        }

        self.onDimiss?()
        dismiss()

        return
      }
      currentPageID = pages[currentIndex + 1].id
    }
  }
#endif
