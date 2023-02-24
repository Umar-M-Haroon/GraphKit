//
//  AttributeKey.swift
//  
//
//  Created by Umar Haroon on 2/20/23.
//

import Foundation

protocol Attributable {}
enum EdgeAttributeKey: String, Attributable {
    case color
    case style
    case dir
    case arrowhead
    case arrowtail
    case tailclip
    case headclip
    case taillabel
    case headlabel
    case label
    case fontname
    case fontsize
    case fontcolor
    case comment
    
    var key: String {
        return rawValue
    }
}
