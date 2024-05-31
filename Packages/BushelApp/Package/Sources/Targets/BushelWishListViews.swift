//
// BushelWishListViews.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelWishListViews: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelViewsCore()
    BushelWishListEnvironment()
    BushelMarketEnvironment()
    WishKit()
  }
}
