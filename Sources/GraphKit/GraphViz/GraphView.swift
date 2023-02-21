//
//  File.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation
public struct GraphView: View {
    var subviews: [View]
    
    public init(@GraphVizBuilder builder: () -> [any View]) {
        subviews = builder()
    }
    
    public func build() -> [String] {
        var output: [String] = []
        output.append("digraph {")
        for subview in subviews {
            output.append(contentsOf: subview.build())
        }
        output.append("}")
        return output
    }
}
