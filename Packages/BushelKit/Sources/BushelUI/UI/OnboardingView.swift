//
// OnboardingView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import SwiftUI

  struct PageView: NSViewControllerRepresentable {
    let data = ["green", "blue", "red"]
    class Controller: NSPageController, NSPageControllerDelegate {
      func pageController(_: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        (object as? String) ?? "green"
      }

      func pageController(_: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        let rootView: Color
        switch identifier {
        case "green":
          rootView = .green
        case "red":
          rootView = .red

        default:
          rootView = .blue
        }
        return NSHostingController(rootView: rootView)
      }

      override func loadView() {
        view = NSView()
      }
    }

    func makeNSViewController(context _: Context) -> Controller {
      let pageController = Controller()
      pageController.arrangedObjects = data
      pageController.delegate = pageController
      return pageController
    }

    func updateNSViewController(_: Controller, context _: Context) {}

    typealias NSViewControllerType = Controller
  }

  struct OnboardingView: View {
    var body: some View {
      PageView()
    }
  }

  struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
      OnboardingView()
    }
  }
#endif
