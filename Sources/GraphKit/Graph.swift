//
//  Graph.swift
//  Infection
//
//  Created by Umar Haroon on 3/31/21.
//
import Collections
import Foundation
public protocol GraphNode: Equatable, Hashable {
    var id: Int { get set }
    var edges: OrderedSet<Edge> { get set }
    func degree() -> Int
}
extension GraphNode {
    func degree() -> Int {
        return edges.count
    }
}
public struct Node: GraphNode {
    public var id: Int
    public var edges: OrderedSet<Edge>
    init(id: Int, edges: OrderedSet<Edge>) {
        self.id = id
        self.edges = edges
    }
    public init() {
        self.id = -1
        self.edges = []
    }
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
    /// first node id
    public var u: Int
    /// second node id
    public var v: Int
    public func reverse() -> Edge {
        return Edge(u: v, v: u)
    }
}
extension Edge: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "u: \(u) v: \(v)"
    }
}
public struct Graph {
    internal init(nodes: [any GraphNode]) {
        self.nodes = nodes
    }
    
    private(set) var nodes: [any GraphNode]
    public var edges: OrderedSet<Edge> {
        var e: OrderedSet<Edge> = []
        nodes.forEach({ node in
            node.edges.forEach({ edge in
                e.append(edge)
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
    }
    mutating public func addDirectedEdge(u: Int, v: Int) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        let edge = Edge(u: u, v: v)
        mutableNodes[uIndex].edges.append(edge)
        self.nodes = mutableNodes
    }
    mutating public func removeDirectedEdge(u: Int, v: Int) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        self.nodes = mutableNodes
    }
    mutating public func removeUndirectedEdge(u: Int, v: Int) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}),
        let vIndex = self.nodes.firstIndex(where: {$0.id == v}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        mutableNodes[vIndex].edges.removeAll(where: {$0.v == u})
        self.nodes = mutableNodes
    }
    mutating public func addUndirectedEdge(u: Int, v: Int) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}),
              let vIndex = self.nodes.firstIndex(where: {$0.id == v}) else { return }
        let edge = Edge(u: u, v: v)
        mutableNodes[uIndex].edges.append(edge)
        mutableNodes[vIndex].edges.append(edge.reverse())
        self.nodes = mutableNodes
    }
    
    mutating public func addNode(node: any GraphNode = Node()) {
        var mutableNodes = self.nodes
        var node = node
        node.id = mutableNodes.count
        mutableNodes.append(node)
        self.nodes = mutableNodes
    }
    mutating public func removeNode(id: Int) {
        var mutableNodes = self.nodes
        mutableNodes.removeAll(where: {$0.id == id})
        self.nodes = mutableNodes
    }
    /// bfs search
    /// - Returns:
    func bfs(start: Int) -> OrderedSet<Int> {
        var arrQueue: [Int] = []
        var visited: OrderedSet<Int> = []
        arrQueue.append(start)
        visited.append(start)
        while !arrQueue.isEmpty {
            let y = arrQueue.removeFirst()
            let node = nodes[y]
            visited.append(y)
            for edge in node.edges {
                if !visited.contains(edge.v) {
                    arrQueue.insert(edge.v, at: arrQueue.count)
                }
            }
        }
        return visited
    }
    
//    func dfs(start: Int, visited: [Int] = []) -> OrderedSet<Int> {
//        var vis = visited
//        vis.append(start)
//        return self.dfs(start: <#T##Int#>, visited: vis)
//    }
}
