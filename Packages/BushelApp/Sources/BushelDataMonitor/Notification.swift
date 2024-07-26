//
// Notification.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(CoreData)
  public import CoreData

  public import Foundation

  extension Notification {
    func managedObjects(key: String) -> Set<ManagedObjectMetadata>? {
      guard let objects = self.userInfo?[key] as? Set<NSManagedObject> else {
        return nil
      }

      return Set(objects.compactMap(ManagedObjectMetadata.init(managedObject:)))
    }
  }
#endif
