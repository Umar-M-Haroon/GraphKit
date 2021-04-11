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
    }
