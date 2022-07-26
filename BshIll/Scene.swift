import SwiftUI


extension Scene {
    func windowsHandle(_ handle: BasicWindowOpenHandle) -> some Scene {
        self.handlesExternalEvents(matching: .init([handle.rawValue]))
    }
}
