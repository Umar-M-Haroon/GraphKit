//
//  File.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation

@resultBuilder
public struct GraphVizBuilder {
    static func buildBlock(_ components: View...) -> [any View] {
        components
    }
    static func buildBlock(_ components: [View]) -> [any View] {
        components
    }
    static func buildArray(_ components: [[View]]) -> [any View] {
        components.flatMap({$0})
    }
}
