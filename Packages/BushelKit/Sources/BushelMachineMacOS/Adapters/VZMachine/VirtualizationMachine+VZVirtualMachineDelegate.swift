//
// VirtualizationMachine+VZVirtualMachineDelegate.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import Virtualization

  extension VirtualizationMachine: VZVirtualMachineDelegate {
    func guestDidStop(_: VZVirtualMachine) {
      notifyObservers(.guestDidStop)
    }

    /// Invoked when a virtual machine is stopped due to an error.
    /// - Parameters:
    ///   - virtualMachine The virtual machine invoking the delegate method.
    ///   - error The error
    func virtualMachine(_: VZVirtualMachine, didStopWithError error: Error) {
      notifyObservers(.stopWithError(error))
    }

    /// Invoked when a virtual machine's network attachment has been disconnected.
    ///
    ///  This method is invoked every time that the network interface fails to start,
    ///  resulting in the network attachment being disconnected. This can happen
    ///  in many situations such as initial boot, device reset, reboot, etc.
    ///  Therefore, this method may be invoked several times during a virtual machine's life cycle.
    ///  The VZNetworkDevice.attachment property will be nil after the method is invoked.
    ///
    /// - Parameters:
    ///   - _: The virtual machine invoking the delegate method.
    ///   - _: The virtual machine invoking the delegate method.
    ///   - error: The error.
    func virtualMachine(
      _: VZVirtualMachine,
      networkDevice _: VZNetworkDevice,
      attachmentWasDisconnectedWithError error: Error
    ) {
      notifyObservers(.networkDetatchedWithError(error))
    }
  }
#endif
