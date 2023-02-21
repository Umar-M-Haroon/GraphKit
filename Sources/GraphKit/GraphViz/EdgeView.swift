//
//  File.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation
public struct EdgeView: View {
    let edge: Edge
    let attributes: [Attribute]
    let uDescription: String
    let vDescription: String
    
    public func build() -> [String] {
        var output: [String] = []
        output.append("\"\(uDescription)\" -> \"\(vDescription)\" [\(attributes.map { $0.build() }.joined(separator: ", "))];")
        return output
    }
}
