import Foundation


struct MachineDisk {
  let id : UUID
  let size: UInt64
  let readOnly : Bool
  init(id: UUID = .init(), size: UInt64, readOnly : Bool = false) {
    self.id = id
    self.size = size
    self.readOnly = readOnly
  }
}
