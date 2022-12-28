//
//  Graph.swift
//  Infection
//
//  Created by Umar Haroon on 3/31/21.
//
import Collections
import Foundation
public protocol GraphNode: Equatable, Hashable {
    var id: UUID { get set }
    var edges: OrderedSet<Edge> { get set }
    func degree() -> Int
}
extension GraphNode {
    func degree() -> Int {
        return edges.count
    }
}
public struct Node: GraphNode {
    public var id = UUID()
    public var edges: OrderedSet<Edge>
    init(id: UUID, edges: OrderedSet<Edge>) {
        self.id = id
        self.edges = edges
    }
    public init() {
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
    public var u: UUID
    /// second node id
    public var v: UUID
    
    public init(u: UUID, v: UUID) {
        self.u = u
        self.v = v
    }
    
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
    
    public private(set) var nodes: [any GraphNode]
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
            let n = Node(id: UUID(), edges: [])
            totalNodes.append(n)
            dict[i] = n
        }
        self.nodes = totalNodes
    }
    mutating public func addDirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        let edge = Edge(u: u, v: v)
        mutableNodes[uIndex].edges.append(edge)
        self.nodes = mutableNodes
    }
    mutating public func removeDirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        self.nodes = mutableNodes
    }
    mutating public func removeUndirectedEdge(u: UUID, v: UUID) {
        var mutableNodes = self.nodes
        guard let uIndex = self.nodes.firstIndex(where: {$0.id == u}),
        let vIndex = self.nodes.firstIndex(where: {$0.id == v}) else { return }
        mutableNodes[uIndex].edges.removeAll(where: {$0.v == v})
        mutableNodes[vIndex].edges.removeAll(where: {$0.v == u})
        self.nodes = mutableNodes
    }
    mutating public func addUndirectedEdge(u: UUID, v: UUID) {
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
        mutableNodes.append(node)
        self.nodes = mutableNodes
    }
    mutating public func removeNode(id: UUID) {
        var mutableNodes = self.nodes
        mutableNodes.removeAll(where: {$0.id == id})
        self.nodes = mutableNodes
    }
    /// bfs search
    /// - Returns:
    func bfs(start: UUID) -> OrderedSet<UUID> {
        var arrQueue: [UUID] = []
        var visited: OrderedSet<UUID> = []
        arrQueue.append(start)
        visited.append(start)
        while !arrQueue.isEmpty {
            let y = arrQueue.removeFirst()
            visited.append(y)
            for edge in self.edges where edge.u == y || edge.v == y {
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
