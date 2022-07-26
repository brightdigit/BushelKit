import Foundation
import SwiftUI

extension Image {
    init(operatingSystemVersion: OperatingSystemVersion) {
        let codeName = OperatingSystemCodeName(operatingSystemVersion: operatingSystemVersion)
        let imageName = codeName?.name
        self.init(imageName ?? "Big Sur")
    }
}


