//
// Icons.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum Icons {
  public enum Machine: String, Icon {
    public static let namespace: String = "Icons/Machines"
    case desktop01 = "001-desktop"
    case computer = "002-computer"
    case desktopComputer = "003-desktop-computer"
    case computer01 = "004-computer-1"
    case desktop02 = "005-desktop-1"
    case settings = "006-settings"
    case computer02 = "007-computer-2"
    // swiftlint:disable:next identifier_name
    case pc = "008-pc"
    case imac = "009-imac"
    case oldComputer = "010-old-computer"
    case laptop = "011-laptop"
    case mac = "012-mac"
    case desktop03 = "013-desktop-2"
    case macbook = "014-macbook"
    case macMini = "015-mac-mini"
    case macMini01 = "016-mac-mini-1"
    case mac01 = "017-mac-1"
    case imac01 = "018-imac-1"
    case macPro = "019-mac-pro"
    case computer03 = "020-computer-3"
    case monitor = "021-monitor"
    case command = "022-command"
    case dataServer = "042-data-server"
    case server = "043-server"
    case server01 = "044-server-1"
    case dataStorage = "045-data-storage"
    case server03 = "047-server-3"
    case dataCenter = "048-data-center"
    case server04 = "049-server-4"
    case macPro01 = "050-mac-pro-1"
    case macPro02 = "051-mac-pro-2"
    case imac02 = "052-imac-2"
    case computer04 = "053-computer-4"
    case macintosh = "082-macintosh"
    case macintosh01 = "083-macintosh-1"
    case macintosh02 = "084-macintosh-2"
    case lisa = "085-lisa"
    case macintosh03 = "086-macintosh-3"
    case ipod = "087-ipod"
    case ipodShuffle = "088-ipod-shuffle"
    case ipodNano = "089-ipod-nano"
    case ipodShuffle01 = "090-ipod-shuffle-1"
    case ipod01 = "091-ipod-1"
    case mp3 = "092-mp3"
  }

  enum California: String, Icon, CaseIterable {
    static let namespace: String = "Icons/California"

    case sanDiego = "054-san-diego"
    case california = "055-california"
    case castle = "056-castle"
    case park = "057-park"
    case climb = "058-climb"
    case mountains = "059-mountains"
    case beach00 = "060-beach"
    case beach01 = "061-beach-1"
    case cheese00 = "077-cheese"
    case cheese01 = "078-cheese-1"
    case dog = "079-dog"
    case kitty = "080-kitty"
  }

  enum Fruit: String, Icon {
    static let namespace: String = "Icons/Fruit"
    case apple = "023-apple"
    case apple001 = "024-apple-1"
    case apple002 = "025-apple-2"
    case apple003 = "026-apple-3"
    case apple004 = "027-apple-4"
    case apple005 = "028-apple-5"
    case appleTree00 = "029-apple-tree"
    case apple006 = "030-apple-6"
    case appleTree01 = "031-apple-tree-1"
    case apple007 = "032-apple-7"
    case apple008 = "033-apple-8"
    case apple009 = "034-apple-9"
    case apple010 = "035-apple-10"
    case caramelizedApple = "036-caramelized-apple"
    case apple011 = "037-apple-11"
    case banana00 = "038-banana"
    case banana01 = "039-banana-1"
    case banana02 = "040-banana-2"
    case banana03 = "041-banana-3"
  }

  public enum Feature: String, Icon {
    public static let namespace: String = "Icons/Features"
    case localizationAndAccessibility = "LocalizationAndAccessibility"
    case snapshots = "Snapshots"
    case script = "Script"
    case customMachine = "CustomMachine"
    case restoreImageManagement = "RestoreImageManagement"
    case versions = "Versions"
    case library = "Library"
  }
}
