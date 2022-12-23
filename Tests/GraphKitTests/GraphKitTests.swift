import XCTest
@testable import GraphKit

final class GraphKitTests: XCTestCase {
    private var graph: Graph!
    override func setUp() {
        let graph = Graph(numberOfNodes: 4)
        self.graph = graph
    }
    override func tearDown() {
        self.graph = nil
    }
    func testEdgelessGraph() throws {
        XCTAssertTrue(graph.nodes.count == 4)
        XCTAssertTrue(graph.edges.isEmpty)
    }
    func testAddingDirectedEdges() {
        addSampleDirectedEdges()
        XCTAssertTrue(graph.edges.count == 3)
        XCTAssertTrue(graph.nodes[0].edges.count == 3)
        XCTAssertTrue(graph.nodes[1].edges.count == 0)
        XCTAssertTrue(graph.nodes[2].edges.count == 0)
        XCTAssertTrue(graph.nodes[3].edges.count == 0)
    }
    func testRemovingDirectedEdges() {
        addSampleDirectedEdges()
        XCTAssertTrue(graph.edges.count == 3)
        
        graph.removeDirectedEdge(u: 0, v: 1)
        graph.removeDirectedEdge(u: 0, v: 2)
        graph.removeDirectedEdge(u: 0, v: 3)
        
        XCTAssertTrue(graph.edges.count == 0)
        XCTAssertTrue(graph.nodes[0].edges.count == 0)
        XCTAssertTrue(graph.nodes[1].edges.count == 0)
        XCTAssertTrue(graph.nodes[2].edges.count == 0)
        XCTAssertTrue(graph.nodes[3].edges.count == 0)
    }
    func addSampleDirectedEdges() {
        graph.addDirectedEdge(u: 0, v: 1)
        graph.addDirectedEdge(u: 0, v: 2)
        graph.addDirectedEdge(u: 0, v: 3)
    }
    func testAddingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertTrue(graph.edges.count == 6)
        XCTAssertTrue(graph.nodes[0].edges.count == 3)
        XCTAssertTrue(graph.nodes[1].edges.count == 1)
        XCTAssertTrue(graph.nodes[2].edges.count == 1)
        XCTAssertTrue(graph.nodes[3].edges.count == 1)
    }
    func testRemovingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertTrue(graph.edges.count == 6)
        
        graph.removeUndirectedEdge(u: 0, v: 1)
        graph.removeUndirectedEdge(u: 0, v: 2)
        graph.removeUndirectedEdge(u: 0, v: 3)
        
        XCTAssertTrue(graph.edges.count == 0)
        XCTAssertTrue(graph.nodes[0].edges.count == 0)
        XCTAssertTrue(graph.nodes[1].edges.count == 0)
        XCTAssertTrue(graph.nodes[2].edges.count == 0)
        XCTAssertTrue(graph.nodes[3].edges.count == 0)
    }
    func addSampleUndirectedEdges() {
        graph.addUndirectedEdge(u: 0, v: 1)
        graph.addUndirectedEdge(u: 0, v: 2)
        graph.addUndirectedEdge(u: 0, v: 3)
    }
    func testInsertNode() {
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...4 {
            graph.addNode()
        }
        XCTAssertEqual(graph.nodes.count, 9)
    }
    func testRemoveNode() {
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...4 {
            graph.addNode()
        }
        graph.removeNode(id: 4)
        XCTAssertEqual(graph.nodes.count, 8)
    }
    func testBFS() {
        addSampleUndirectedEdges()
        let results = graph.bfs(start: 0)
        XCTAssertEqual(results, [0, 1, 2, 3])
    }
}
