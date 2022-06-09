


struct MachineNetwork {
  enum InterfaceType {
    case bridgeHostInterfaceWithID(String)
    case NAT
  }
  
  enum MacAddress {
    case string(String)
    case random
  }
  let type : InterfaceType
  let macAddress : MacAddress
  
}
