import XCTest
@testable import InfectionGraphKit

final class InfectionGraphKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var infect = InfectionHandler(graph: Graph.init(numberOfNodes: 30), difficulty: Difficulty(difficultyLevel: .easy))
        while infect.vaccinesAdministered < infect.difficulty.numberOfVaccines {
            if let node = infect.graph.nodes.randomElement() {
                infect.vaccinateNode(node: node)
            }
        }
        XCTAssert(infect.vaccinesAdministered == infect.difficulty.numberOfVaccines)
        infect.startInfection()
        XCTAssert(infect.numberOfInfectedNodes() == 1)
        for node in infect.graph.nodes where node.SIRState == .Infected{
            print(node.degree())
            print(node.id)
            for edge in node.edges {
                print("\(edge.u.id) -> \(edge.v.id)")
                let firstNode = infect.graph.nodes.first(where: {$0.id == edge.v.id})
                let wrappedFirstNode = try XCTUnwrap(firstNode)
                XCTAssert(wrappedFirstNode
                            .edges.contains(where: {$0 == edge.reverse()}))
            }
        }
    }
    func testInfectOnlyActive() throws {
        //tests
        var infect = InfectionHandler(graph: Graph.init(numberOfNodes: 4), difficulty: Difficulty(difficultyLevel: .custom(1, 0.7, 3, 0)))
        print(infect.graph.activeEdges.count)
        var vaccineNodes = infect.graph.nodes
        while infect.vaccinesAdministered < infect.difficulty.numberOfVaccines {
            if let node = vaccineNodes.randomElement() {
                infect.vaccinateNode(node: node)
                vaccineNodes.removeAll(where: {$0.id == node.id})
            }
        }
        infect.startInfection()
        XCTAssert(infect.graph.nodes.filter({$0.SIRState == .Infected}).count == 1)
//        print(infect.graph.nodes.filter({$0.SIRState == .Infected}))
        let infectedNodes = infect.graph.nodes.filter({$0.SIRState == .Infected})
        for n in infectedNodes {
            print("infected node \(n.id)")
            for edge in n.edges {
                print("id: \(edge.v.id) metadata: \(edge.v.metaData)")
            }
        }
        print(infect.graph.nodes.filter({$0.metaData == .vaccinated}).forEach({print("Vaccinated ID: \($0.id)")}))
        print(infect.graph.activeEdges.count)
//        XCTAssert(infect.infectableEdges() == 0)
//        for edge in infectedEdges {
//            print(edge.toRKFormat())
//        }
        infect.graph.nodes.filter({$0.metaData == .vaccinated}).forEach({print("Vaccinated node: \($0.id)")})
//        XCTAssert(edgesLeft > 0)
        infect.startInfection()
        for node in infect.graph.nodes where node.SIRState == .Infected{
            for edge in node.edges where edge.isActive && edge.v.metaData == .none {
                print("\(edge.u.id) -> \(edge.v.id)")
            }
        }
        infect.nextStep()
    }
    func testVaccinations() {
        var infect = InfectionHandler(graph: Graph.init(numberOfNodes: 4), difficulty: Difficulty(difficultyLevel: .custom(1, 0.7, 3, 0)))
        var vaccineNodes = infect.graph.nodes
        while infect.vaccinesAdministered < infect.difficulty.numberOfVaccines {
            if let node = vaccineNodes.randomElement() {
                infect.vaccinateNode(node: node)
                vaccineNodes.removeAll(where: {$0.id == node.id})
            }
        }
        XCTAssert(infect.vaccinesAdministered == infect.difficulty.numberOfVaccines)
    }
}
