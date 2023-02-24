//
//  File 2.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation
public struct Attribute {
    let key: any Attributable
    let value: String
    
    func build() -> String {
        "\(key)=\"\(value)\""
    }
}
