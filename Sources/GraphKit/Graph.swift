//
//  Graph.swift
//  Infection
//
//  Created by Umar Haroon on 3/31/21.
//

import Foundation
public struct Node: Equatable, Hashable {
    public var id: Int
    public var edges: Set<Edge>
    public func degree() -> Int {
        return edges.count
    }
}
extension Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Node: \(id), edges: \(edges.forEach({ print($0.debugDescription) }))"
    }
}
public struct Edge: Equatable, Hashable {
    public var u: Node
    public var v: Node
    public func reverse() -> Edge {
        return Edge(u: v, v: u)
    }
}
extension Edge: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "u: \(u.id) v: \(v.id)"
    }
}
public struct Graph {
    internal init(nodes: [Node]) {
        self.nodes = nodes
    }
    
    public var nodes: [Node]
    public var edges: Set<Edge> {
        var e: Set<Edge> = []
        nodes.forEach({
            $0.edges.forEach({ edge in
                e.insert(edge)
            })
        })
        return e
    }
    public init(numberOfNodes: Int) {
        var totalNodes: [Node] = []
        var dict: [Int: Node] = [:]
        for i in 0 ..< numberOfNodes {
            let n = Node(id: i, edges: [])
            totalNodes.append(n)
            dict[i] = n
        }
        self.nodes = totalNodes
        for node in totalNodes {
            createEdge(numberOfNodes: numberOfNodes, node: node)
            if Double.random(in: 0..<1) > 0.2{
                createEdge(numberOfNodes: numberOfNodes, node: node)
            }
        }
    }
    private mutating func createEdge(numberOfNodes: Int, node: Node) {
        var randomNumber = Int.random(in: 0 ..< numberOfNodes)
        while randomNumber == node.id {
            randomNumber = Int.random(in: 0 ..< numberOfNodes)
        }
        guard let v = self.nodes.first(where: { $0.id == randomNumber }) else {
            fatalError("invalid v")
        }
        let edge = Edge(u: node, v: v)
        addUndirectedEdge(edge: edge, node: node)
        
    }
    mutating func addUndirectedEdge(edge: Edge, node: Node) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == node.id}),
              let vIndex = self.nodes.firstIndex(where: {$0.id == edge.v.id}) else { return }
        mutableNodes[uIndex].edges.insert(edge)
        mutableNodes[vIndex].edges.insert(edge.reverse())
        self.nodes = mutableNodes
    }
    public func getIndex(node: Node) -> Int {
        return nodes.firstIndex(where: {$0.id == node.id})!
    }
}
