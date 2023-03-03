//
//  File.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation

@resultBuilder
public struct GraphVizBuilder {
    public static func buildBlock(_ components: DOTView...) -> [any DOTView] {
        components
    }
    public static func buildBlock(_ components: [DOTView]) -> [any DOTView] {
        components
    }
    public static func buildArray(_ components: [[DOTView]]) -> [any DOTView] {
        components.flatMap({$0})
    }
}
