import XCTest
import OrderedCollections
@testable import GraphKit

final class GraphKitTests: XCTestCase {
    private var graph: Graph!
    var testUUIDs: [UUID] = []
    override func setUp() {
        var graph = Graph(numberOfNodes: 0)
        self.testUUIDs = [UUID(), UUID(), UUID(), UUID()]
        for (index, id) in self.testUUIDs.enumerated() {
            graph.addNode(node: Node(id: id, description: "hi \(index)"))
        }
        self.graph = graph
    }
    override func tearDown() {
        self.graph = nil
    }
    func testEdgelessGraph() throws {
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertTrue(graph.edges.isEmpty)
    }
    func testAddingDirectedEdges() {
        addSampleDirectedEdges()
        XCTAssertEqual(graph.edges.count, 3)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 3)
        XCTAssertEqual(graph.degree(node: graph.nodes[1]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[2]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[3]), 0)
    }
    func testRemovingDirectedEdges() {
        addSampleDirectedEdges()
        XCTAssertEqual(graph.edges.count, 3)

        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.removeDirectedEdge(u: testUUIDs[0], v: testUUIDs[3])

        XCTAssertEqual(graph.edges.count, 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 0)
    }
    func addSampleDirectedEdges() {
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[3])
    }
    func testAddingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertEqual(graph.edges.count, 6)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 3)
        XCTAssertEqual(graph.degree(node: graph.nodes[1]), 1)
        XCTAssertEqual(graph.degree(node: graph.nodes[2]), 1)
        XCTAssertEqual(graph.degree(node: graph.nodes[3]), 1)
    }
    func testRemovingUndirectedEdges() {
        addSampleUndirectedEdges()
        XCTAssertEqual(graph.edges.count, 6)

        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.removeUndirectedEdge(u: testUUIDs[0], v: testUUIDs[3])

        XCTAssertEqual(graph.edges.count, 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[0]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[1]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[2]), 0)
        XCTAssertEqual(graph.degree(node: graph.nodes[3]), 0)
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
        var nodeDictResults: [any GraphNode] = []
        for n in graph.nodes {
            nodeDictResults.append(graph[n.id])
        }
        XCTAssertEqual(nodeDictResults.count, 9)
        
        XCTAssertEqual(graph.nodes.count, 9)
    }
    func testInsertDifferentNodes() {
        XCTAssertEqual(graph.nodes.count, 4)
        struct TestNode: GraphNode {
            var description: String
            
            var id: UUID
            
            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>
            
        }
        struct TestNode2: GraphNode {
            var description: String
            
            var id: UUID
            
            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>
            
        }
        for _ in 0...4 {
            graph.addNode()
        }
        let id1 = UUID()
        let id2 = UUID()
        graph.addNode(node: TestNode(description: id1.uuidString, id: id1, edges: []))
        graph.addNode(node: TestNode2(description: id2.uuidString, id: id2, edges: []))
        XCTAssertEqual(graph.nodes.count, 11)
        XCTAssertTrue(graph.nodes.contains(where: {$0 is TestNode}))
        XCTAssertTrue(graph.nodes.contains(where: {$0 is TestNode2}))
    }
    func testRemoveNode() {
        XCTAssertEqual(graph.nodes.count, 4)
        for _ in 0...3 {
            graph.addNode()
        }
        
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.edges.count, 0)
        
        
        graph.addUndirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        XCTAssertEqual(graph.edges.count, 2)
        
        
        graph.removeNode(id: testUUIDs[0])
        XCTAssertEqual(graph.edges.count, 0)
        XCTAssertEqual(graph.nodes.count, 7)
        var nodeDictResults: [any GraphNode] = []
        for n in graph.nodes {
            nodeDictResults.append(graph[n.id])
        }
        XCTAssertEqual(nodeDictResults.count, 7)
    }
    func testRemoveEdge() {
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.edges.count, 0)
        
        
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[1])
        graph.addDirectedEdge(u: testUUIDs[0], v: testUUIDs[2])
        graph.addDirectedEdge(u: testUUIDs[1], v: testUUIDs[2])
        graph.addDirectedEdge(u: testUUIDs[2], v: testUUIDs[1])
        XCTAssertEqual(graph.edges.count, 4)
        
        
        
        graph.removeNode(id: testUUIDs[1])
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssertEqual(graph.edges.count, 1)
        var nodeDictResults: [any GraphNode] = []
        for n in graph.nodes {
            nodeDictResults.append(graph[n.id])
        }
        XCTAssertEqual(nodeDictResults.count, 3)
    }
    func testBFS() {
        addSampleUndirectedEdges()
        let results = graph.bfs(start: testUUIDs[0])
        XCTAssertEqual(results, OrderedSet(testUUIDs))
    }
    func testGraphViz() {
        struct TestNode: GraphNode {
            var description: String
            
            var id: UUID
            
            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>
            
        }
        struct TestNode2: GraphNode {
            var description: String
            
            var id: UUID
            
            var edges: OrderedCollections.OrderedSet<GraphKit.Edge>
            
        }
        addSampleDirectedEdges()
        let views = graph.nodes.flatMap({NodeView(node: $0, attributes: [])})
        let edges = graph.edges.flatMap({EdgeView(edge: $0, attributes: [.init(key: EdgeAttributeKey.color, value: "red"), .init(key: EdgeAttributeKey.label, value: "calls")], uDescription: graph[$0.u].description, vDescription: graph[$0.v].description)})
        let allViews: [any DOTView] = views + edges
        let graphView = GraphView {
            allViews
        }
        print(graphView.build().joined(separator: "\n"))
    }
}
