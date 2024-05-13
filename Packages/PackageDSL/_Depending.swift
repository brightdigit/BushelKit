//
// _Depending.swift
// Copyright (c) 2024 BrightDigit.
// Licensed under MIT License
//

// swift-format-ignore: NoLeadingUnderscores
public protocol _Depending {
    @DependencyBuilder
    var dependencies: any Dependencies { get }
}

public extension _Depending {
    var dependencies: any Dependencies {
        [Dependency]()
    }
}

public extension _Depending {
    func allDependencies() -> [Dependency] {
        dependencies.compactMap {
            $0 as? _Depending
        }
        .flatMap {
            $0.allDependencies()
        }
        .appending(dependencies)
    }
}