<p align="center">
    <img alt="BushelKit" title="BushelKit" src="Sources/BushelFoundation/BushelFoundation.docc/Resources/Logo.svg" height="200">
</p>
<h1 align="center"> BushelKit </h1>

Open source components of [Bushel](https://getbushel.app) for developers.

[![](https://img.shields.io/badge/docc-read_documentation-blue)](https://swiftpackageindex.com/brightdigit/BushelKit/documentation)
[![SwiftPM](https://img.shields.io/badge/SPM-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-success?logo=swift)](https://swift.org)
[![Twitter](https://img.shields.io/badge/twitter-@brightdigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
![GitHub](https://img.shields.io/github/license/brightdigit/BushelKit)
![GitHub issues](https://img.shields.io/github/issues/brightdigit/BushelKit)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/brightdigit/BushelKit/BushelKit.yml?label=actions&logo=github&?branch=main)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FBushelKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/brightdigit/BushelKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FBushelKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/brightdigit/BushelKit)

[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/BushelKit)](https://codecov.io/gh/brightdigit/BushelKit)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/brightdigit/BushelKit)](https://www.codefactor.io/repository/github/brightdigit/BushelKit)
[![Maintainability](https://api.codeclimate.com/v1/badges/78ed94c9ce81530d23dc/maintainability)](https://codeclimate.com/repos/675322f20ee99b00b9c28232/maintainability)
<!--[![codebeat badge](https://codebeat.co/badges/54695d4b-98c8-4f0f-855e-215500163094)](https://codebeat.co/projects/github-com-brightdigit-BushelKit-main)-->


# Table of Contents

* [Introduction](#introduction)
  * [Requirements](#requirements)
* [Usage](#usage)
* [Roadman](#roadman)
* [Documentation](#documentation)
* [License](#license)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->

# Introduction

This is an open-source component for [Bushel, a macOS virtual machine app](https://getbushel.app) for developers. This will utilitized in the future for build open-source apps such as a command line app and more.

## Requirements 

**Apple Platforms**

- Xcode 16.0 or later
- Swift 6.0 or later
- iOS 17 / watchOS 10.0 / tvOS 17 / macOS 14 or later deployment targets

**Linux**

- Ubuntu 20.04 or later
- Swift 6.0 or later

# Usage

If you'd like to use BushelKit, add [the products](https://docs.getbushel.app/docc) you'd like to use in your app.

```swift
let package = Package(
  ...
  dependencies: [
    .package(url: "https://github.com/brightdigit/BushelKit.git", from: "2.0.0")
  ],
  targets: [
      .target(
          name: "YourApp",
          dependencies: [
            .product(name: "BushelLibrary", package: "BushelKit"),
            .product(name: "BushelMachine", package: "BushelKit"),
            ...
      ]),
  ]
)
```

# Roadman

* [#40 - Finish Documentation for bushel DocC](https://github.com/brightdigit/BushelKit/issues/40)                       
* [#39 - Finish Documentation for BushelVirtualBuddy DocC](https://github.com/brightdigit/BushelKit/issues/39)           
* [#38 - Finish Documentation for BushelUtilities DocC](https://github.com/brightdigit/BushelKit/issues/38)              
* [#37 - Finish Documentation for BushelUT DocC](https://github.com/brightdigit/BushelKit/issues/37)                     
* [#36 - Finish Documentation for BushelTestUtilities DocC](https://github.com/brightdigit/BushelKit/issues/36)          
* [#35 - Finish Documentation for BushelMachineWax DocC](https://github.com/brightdigit/BushelKit/issues/35)             
* [#34 - Finish Documentation for BushelMachine DocC](https://github.com/brightdigit/BushelKit/issues/34)                
* [#33 - Finish Documentation for BushelMacOSCore DocC](https://github.com/brightdigit/BushelKit/issues/33)              
* [#32 - Finish Documentation for BushelLogging DocC](https://github.com/brightdigit/BushelKit/issues/32)                
* [#31 - Finish Documentation for BushelLibraryWax DocC](https://github.com/brightdigit/BushelKit/issues/31)             
* [#30 - Finish Documentation for BushelLibrary DocC](https://github.com/brightdigit/BushelKit/issues/30)                
* [#29 - Finish Documentation for BushelHubMacOS DocC](https://github.com/brightdigit/BushelKit/issues/29)               
* [#28 - Finish Documentation for BushelHubIPSW DocC](https://github.com/brightdigit/BushelKit/issues/28)                
* [#27 - Finish Documentation for BushelHub DocC](https://github.com/brightdigit/BushelKit/issues/27)                    
* [#26 - Finish Documentation for BushelGuestProfile DocC](https://github.com/brightdigit/BushelKit/issues/26)           
* [#25 - Finish Documentation for BushelFoundationWax DocC](https://github.com/brightdigit/BushelKit/issues/25)          
* [#24 - Finish Documentation for BushelFoundation DocC](https://github.com/brightdigit/BushelKit/issues/24)             
* [#23 - Finish Documentation for BushelFactory DocC](https://github.com/brightdigit/BushelKit/issues/23)                
* [#22 - Finish Documentation for BushelDocs DocC](https://github.com/brightdigit/BushelKit/issues/22)                   
* [#21 - Finish Documentation for BushelArgs DocC](https://github.com/brightdigit/BushelKit/issues/21) 
* Add Tutorials for Creating a  Machine
* Finish Documentation for bushel CLI
* bushel CLI v.x                  
* Finish Documentation for Bushel REST API
* Tutorial for creating a machine
* Tutorial for creating a library
* Tutorial for importing/downloading an image into a library
* Tutorial for creating a snapshot
* Tutorial for creating a machine from a snapshot
* Tutorial for booting up machine

# Documentation

To learn more, check out the full [documentation](https://docs.getbushel.app/docc).

# License 

This code is distributed under the MIT license. See the [LICENSE](https://github.com/brightdigit/BushelKit/LICENSE) file for more info.
