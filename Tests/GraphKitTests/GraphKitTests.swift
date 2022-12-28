import XCTest
import OrderedCollections
@testable import GraphKit

final class GraphKitTests: XCTestCase {
    private var graph: Graph!
    var testUUIDs: [UUID] = []
    override func setUp() {
        var graph = Graph(numberOfNodes: 0)
        self.testUUIDs = [UUID(), UUID(), UUID(), UUID()]
        for id in self.testUUIDs {
            graph.addNode(node: Node(id: id, edges: []))
        }
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
        XCTAssertTrue(graph.nodes[0].degree() == 3)
        XCTAssertTrue(graph.nodes[1].degree() == 0)
        XCTAssertTrue(graph.nodes[2].degree() == 0)
        XCTAssertTrue(graph.nodes[3].degree() == 0)
    }
    func testRemovingDirectedEdges() {
        addSampleDirectedEdges()
        XCTAssertTrue(graph.edges.count == 3)

        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[3])

        XCTAssertTrue(graph.edges.count == 0)
        XCTAssertTrue(graph.nodes[0].degree() == 0)
        XCTAssertTrue(graph.nodes[1].degree() == 0)
        XCTAssertTrue(graph.nodes[2].degree() == 0)
        XCTAssertTrue(graph.nodes[3].degree() == 0)
    }
    func addSampleDirectedEdges() {
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[3])
    }
    func testAddingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertTrue(graph.edges.count == 6)
        XCTAssertTrue(graph.nodes[0].degree() == 3)
        XCTAssertTrue(graph.nodes[1].degree() == 1)
        XCTAssertTrue(graph.nodes[2].degree() == 1)
        XCTAssertTrue(graph.nodes[3].degree() == 1)
    }
    func testRemovingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertTrue(graph.edges.count == 6)

        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[3])

        XCTAssertTrue(graph.edges.count == 0)
        XCTAssertTrue(graph.nodes[0].degree() == 0)
        XCTAssertTrue(graph.nodes[1].degree() == 0)
        XCTAssertTrue(graph.nodes[2].degree() == 0)
        XCTAssertTrue(graph.nodes[3].degree() == 0)
    }
    func addSampleUndirectedEdges() {
        graph.addUndirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.addUndirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.addUndirectedEdge(u: testUUIDs[0], v: testUUIDs[3])
    }
    func testInsertNode() {
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...4 {
            graph.addNode()
        }
        XCTAssertEqual(graph.nodes.count, 9)
    }
    func testInsertDifferentNodes() {
        struct TestNode: GraphNode {
            var id: UUID

            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>

        }
        struct TestNode2: GraphNode {
            var id: UUID

            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>

        }
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...4 {
            graph.addNode()
        }
        graph.addNode(node: TestNode(id: UUID(), edges: []))
        graph.addNode(node: TestNode2(id: UUID(), edges: []))
        XCTAssertEqual(graph.nodes.count, 11)
        XCTAssertTrue(graph.nodes.contains(where: {$0 is TestNode}))
        XCTAssertTrue(graph.nodes.contains(where: {$0 is TestNode2}))
    }
    func testRemoveNode() {
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...3 {
            graph.addNode()
        }
        graph.removeNode(id: testUUIDs[0])
        XCTAssertEqual(graph.nodes.count, 7)
    }
    func testBFS() {
        addSampleUndirectedEdges()
        let results = graph.bfs(start: testUUIDs[0])
        XCTAssertEqual(results, OrderedSet(testUUIDs))
    }
}
