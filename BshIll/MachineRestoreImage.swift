import Foundation

struct MachineRestoreImage : Hashable, Identifiable {
  internal init (file: RestoreImageLibraryItemFile) {
    self.id = file.id
    self.name = file.name
    self.image = RestoreImage(imageContainer: file)
  }
  internal init(name: String, id: String, image: RestoreImage? = nil) {
    self.name = name
    self.id =  id.data(using: .utf8)!
    self.image = image
  }
  
    let name : String
    let id : Data
  
  let image : RestoreImage?
}
