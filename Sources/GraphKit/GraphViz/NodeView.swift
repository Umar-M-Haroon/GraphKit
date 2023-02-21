//
//  File.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation
struct NodeView: View {
    let node: any GraphNode
    let attributes: [Attribute]
    
    func build() -> [String] {
        var output: [String] = []
        output.append("\"\(node.description)\" [\(attributes.map { $0.build() }.joined(separator: ", "))];")
        return output
    }
}
