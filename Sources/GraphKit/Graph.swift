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
    var description: String { get set }
}

public struct Node: GraphNode {
    public var description: String
    public var id = UUID()
//    public var edges: OrderedSet<Edge>
    init(id: UUID, description: String? = nil) {
        self.id = id
        self.description = description ?? id.uuidString
    }
    public init() {
        self.description = self.id.uuidString
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
        self.nodeDict = Dictionary.init(grouping: nodes, by: \.id)
    }
    
    public private(set) var nodes: [any GraphNode]
    private var nodeDict: [UUID: [any GraphNode]]
    public var edges: OrderedSet<Edge>  = []
//        var e: OrderedSet<Edge> = []
//        nodes.forEach({ node in
//            node.edges.forEach({ edge in
//                e.append(edge)
//            })
//        })
//        return e
//    }
    public init(numberOfNodes: Int) {
        var totalNodes: [Node] = []
        var dict: [Int: Node] = [:]
        for i in 0 ..< numberOfNodes {
            let n = Node(id: UUID())
            totalNodes.append(n)
            dict[i] = n
        }
        self.nodes = totalNodes
        self.nodeDict = Dictionary.init(grouping: nodes, by: \.id)
    }
    mutating public func addDirectedEdge(u: UUID, v: UUID) {
        let edge = Edge(u: u, v: v)
        self.edges.append(edge)
    }
    mutating public func removeDirectedEdge(u: UUID, v: UUID) {
        edges.removeAll(where: {$0.v == v})
    }
    mutating public func removeUndirectedEdge(u: UUID, v: UUID) {
        edges.removeAll(where: {$0.v == v})
        edges.removeAll(where: {$0.v == u})
    }
    mutating public func addUndirectedEdge(u: UUID, v: UUID) {
        let edge = Edge(u: u, v: v)
        edges.append(edge)
        edges.append(edge.reverse())
    }
    
    mutating public func removeUndirectedEdge(u: any GraphNode, v: any GraphNode) {
        let removeEdge = Edge(u: u.id, v: v.id)
        edges.removeAll(where: {$0 == removeEdge})
        edges.removeAll(where: {$0.reverse() == removeEdge.reverse()})
    }
    
    mutating public func addUndirectedEdge(u: any GraphNode, v: any GraphNode) {
        let edge = Edge(u: u.id, v: v.id)
        edges.append(edge)
        edges.append(edge.reverse())
    }
    
    mutating public func addNode(node: any GraphNode = Node()) {
        var mutableNodes = self.nodes
        mutableNodes.append(node)
        self.nodes = mutableNodes
        self.nodeDict[node.id] = [node]
    }
    mutating public func removeNode(id: UUID) {
        var mutableNodes = self.nodes
        mutableNodes.removeAll(where: {$0.id == id})
        self.nodeDict.removeValue(forKey: id)
        self.nodes = mutableNodes
        for edge in edges where edge.u == id || edge.v == id {
            removeUndirectedEdge(u: edge.u, v: edge.v)
            removeUndirectedEdge(u: edge.v, v: edge.u)
            removeDirectedEdge(u: edge.v, v: edge.u)
            removeDirectedEdge(u: edge.u, v: edge.v)
        }
    }
    
    public func degree(node: any GraphNode) -> Int? {
        let edgeSet: Set<Edge> = Set(edges.filter({$0.u == node.id}))
        return edgeSet.count
    }
    
    public subscript(id: UUID) -> (any GraphNode) {
        self.nodeDict[id]!.first!
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
