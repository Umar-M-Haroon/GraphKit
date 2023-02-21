//
//  File 2.swift
//  
//
//  Created by Umar Haroon on 2/19/23.
//

import Foundation
struct Attribute {
    let key: String
    let value: String
    
    func build() -> String {
        "\(key)=\"\(value)\""
    }
}
