//
//  InfectionHandler.swift
//  InfectionGraphKit
//
//  Created by Umar Haroon on 3/31/21.
//

import Foundation
public struct InfectionHandler {
    internal init(graph: Graph, iterationsDict: [Int : Graph], vaccinesAdministered: Int, defaultInfectionRate: Double = 0.7, difficulty: Difficulty) {
        self.graph = graph
        self.iterationsDict = iterationsDict
        self.vaccinesAdministered = vaccinesAdministered
        self.defaultInfectionRate = defaultInfectionRate
        self.difficulty = difficulty
    }
    public init(graph: Graph, difficulty: Difficulty) {
        self.graph = graph
        self.iterationsDict = [:]
        self.vaccinesAdministered = 0
        self.defaultInfectionRate = difficulty.infectionRate
        self.difficulty = difficulty
    }
    
    var timeStamp = 0
    public var graph: Graph
    var iterationsDict: [Int: Graph]
    public var vaccinesAdministered: Int
    
    var defaultInfectionRate = 0.7
    var difficulty: Difficulty
    public mutating func startInfection() {
        for _ in 0 ..< difficulty.numberOfStartingInfected {
            let randomIndex = Int.random(in: 0 ..< graph.nodes.count)
            graph.nodes[randomIndex].SIRState = SIRNodeStates.Infected
        }
        iterationsDict[timeStamp] = graph
        timeStamp += 1
    }
    public mutating func addAntiVaxxers() {
        if difficulty.antiVaxxers > 0 {
            let new = graph
            for _ in 0..<difficulty.antiVaxxers {
                guard let n = new.nodes.randomElement(),
                      n.SIRState != .Infected else { return }
                addAntiVaxNode(node: n)
            }
        }
    }
    public mutating func nextStep() {
        let newGraph = infectNodes()
        graph = newGraph
        iterationsDict[timeStamp] = newGraph
        timeStamp += 1
    }
    public func numberOfInfectedNodes() -> Int {
        guard let test = iterationsDict[iterationsDict.count - 1] else { return 0 }
        return test.nodes.filter({$0.SIRState == .Infected}).count
    
    }
    func infectNodes() -> Graph {
        var newGraph = graph
        for node in graph.nodes where node.SIRState == .Infected {
            for edge in node.edges where edge.v.metaData != .quarantined && edge.v.metaData != .vaccinated && edge.isActive {
                if Double.random(in: 0.0 ..< 1) <= difficulty.infectionRate {
                    guard let index = newGraph.nodes.firstIndex(where: { $0.id == edge.v.id }) else {
                        print("INVALID INDEX")
                        return graph
                    }
                    if newGraph.nodes[index].SIRState != .Infected {
                        print("node: \(node.id) infecting \(newGraph.nodes[index].id)")
                        newGraph.nodes[index].SIRState = .Infected
                    }
                }
            }
        }
        return newGraph
    }
    public mutating func vaccinateNode(node: Node) {
        if vaccinesAdministered < self.difficulty.numberOfVaccines {
            var newGraph = graph
            //sets node to vaccinated
            guard let index = newGraph.nodes.firstIndex(where: {$0.id == node.id}) else { return }
            var n2 = newGraph.nodes[index]
            n2.metaData = .vaccinated
            n2.edges = n2.edges.map({ edge in
                var e2 = edge
                e2.isActive = false
                return e2
            })
            newGraph.nodes[index] = node
            graph = newGraph
            vaccinesAdministered += 1
            iterationsDict[timeStamp] = newGraph
        }
    }
    public mutating func quarantineNode(node: Node) {
        var newGraph = graph
        guard let index = newGraph.nodes.firstIndex(where: {$0.id == node.id}) else { return }
        var n2 = newGraph.nodes[index]
        n2.metaData = .quarantined
        n2.edges = n2.edges.map({ edge in
            var e2 = edge
            e2.isActive = false
            return e2
        })
        newGraph.nodes[index] = node
        graph = newGraph
        iterationsDict[timeStamp] = newGraph
    }
    public mutating func addAntiVaxNode(node: Node) {
        var newGraph = graph

        
        guard let index = newGraph.nodes.firstIndex(where: {$0.id == node.id}) else { return }
        var n2 = newGraph.nodes[index]
        n2.metaData = .antiVax
        newGraph.nodes[index] = n2
        graph = newGraph
        iterationsDict[timeStamp] = newGraph
    }

}
