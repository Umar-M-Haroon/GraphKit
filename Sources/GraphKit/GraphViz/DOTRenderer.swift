//
//  DOTRenderer.swift
//  
//
//  Created by Umar Haroon on 2/27/23.
//

import Foundation
import Clibgraphviz
import Combine

public struct DOTRenderer {
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
    
    
    private static let queue = DispatchQueue(label: "com.UmarHaroon.GraphKit.Renderer")
    var layout: DOTLayout
    
    public init(layout: DOTLayout) {
        self.layout = layout
    }
    
    public func render(view: DOTView, format: Format = .pdf, options: DOTRenderer.Options? = nil, queue: DispatchQueue = .main, completion: @escaping((Result<Data, any Error>) -> ())) {
            DOTRenderer.queue.async {
                let result = Result {
                
                let ctx = gvContext()
                defer { gvFreeContext(ctx) }
                
                let dotString  = view.build().joined(separator: "\n")
                let graph = dotString.withCString { cString in
                    agmemread(cString)
                }
                
                //        _ = layout.rawValue.withCString { cString in
                //            gvLayout(ctx, graph, cString)
                //        }
                //
                //        defer { gvFreeLayout(ctx, graph)}
                
                var data: UnsafeMutablePointer<Int8>?
                var length: UInt32 = 0
                _ = format.rawValue.withCString { cString in
                    gvRenderData(ctx, graph, cString, &data, &length)
                }
                defer { gvFreeRenderData(data) }
                guard let bytes = data else { return Data() }
                
                return Data(bytes: UnsafeRawPointer(bytes), count: Int(length))
            }
            completion(result)
        }
    }
}
