//
//  DOTRenderer.swift
//  
//
//  Created by Umar Haroon on 2/27/23.
//

import Foundation
import Clibgraphviz
import Combine

public actor DOTRenderer {
    public struct Options: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /**
         tred  computes  the  transitive reduction of directed graphs, and
         prints the resulting graphs to  standard  output.   This  removes
         edges  implied by transitivity.  Nodes and subgraphs are not oth-
         erwise affected.  The ``meaning'' and  validity  of  the  reduced
         graphs  is application dependent.  tred is particularly useful as
         a preprocessor to dot to reduce clutter in dense layouts.
         Undirected graphs are silently ignored.
         */
        static let removeEdgesImpliedByTransitivity = Options(rawValue: 1 << 0)
    }
    
    
    let layout: DOTLayout
    
    public init(layout: DOTLayout) {
        self.layout = layout
    }
    
    public func render(view: DOTView, format: Format = .pdf, options: DOTRenderer.Options? = nil) async throws -> Data {
        let ctx = gvContext()
        defer { gvFreeContext(ctx) }
        
        let dotString  = view.build().joined(separator: "\n")
        let graph = try dotString.withCString { cString in
            try attempt { agmemread(cString) }
        }
        
        try layout.rawValue.withCString { cString in
            try attempt { gvLayout(ctx, graph, cString) }
        }
        
        defer { gvFreeLayout(ctx, graph)}
        
        var data: UnsafeMutablePointer<Int8>?
        var length: UInt32 = 0
        try format.rawValue.withCString { cString in
            try attempt { gvRenderData(ctx, graph, cString, &data, &length) }
        }
        defer { gvFreeRenderData(data) }
        guard let bytes = data else { return Data() }
        
        return Data(bytes: UnsafeRawPointer(bytes), count: Int(length))
    }
    
//    public func render(dotString: String, format: Format = .pdf, options: DOTRenderer.Options? = nil, queue: DispatchQueue = .main, completion: @escaping((Result<Data, Swift.Error>) -> ())) {
//            let result = Result { () throws -> Data in
//
//                let ctx = gvContext()
//                defer { gvFreeContext(ctx) }
//
//                let graph = try dotString.withCString { cString in
//                    try attempt { agmemread(cString) }
//                }
//
//                try self.layout.rawValue.withCString { cString in
//                    try attempt { gvLayout(ctx, graph, cString) }
//                }
//
//                defer { gvFreeLayout(ctx, graph)}
//
//                var data: UnsafeMutablePointer<Int8>?
//                var length: UInt32 = 0
//                try format.rawValue.withCString { cString in
//                    try attempt { gvRenderData(ctx, graph, cString, &data, &length) }
//                }
//                defer { gvFreeRenderData(data) }
//                guard let bytes = data else { return Data() }
//
//                return Data(bytes: UnsafeRawPointer(bytes), count: Int(length))
//            }
//            completion(result)
//
//    }
}
