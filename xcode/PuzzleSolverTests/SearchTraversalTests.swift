//
//  Author:         Alex Cummaudo
//  Student ID:     1744070
//  Program:        A1 - PuzzleProblem
//  Unit:           COS30019 - Intro to AI
//  Date:           1/04/2016
//

import XCTest

class NodesTraversedTests: XCTestCase, SearchMethodObserver {
    // MARK: Implement search method subscriber
    var nodesTraversed: [Node] = []
    
    func didTraverseNode(node: Node, isSolved: Bool) {
        nodesTraversed.append(node)
    }
    
    // MARK: Test setup
    
    let goalState = State(matrix: [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0],
    ])
    
    var nodes: Dictionary<String, Node> = [:]
    
    override func setUp() {
        // Subscribe
        SearchMethodObservationCenter.sharedCenter.addObserver(self)
        // Clear all previous nodes traversed
        nodesTraversed.removeAll()
        
        /*              A
         *       ______/ \______
         *      /     /   \     \
         *     B     C     D     E
         *    / \   / \   / \   / \
         *   F   G H   I J   K L   M
         */
        
        //         1 2 3
        // (A) =>  4 0 5
        //         7 8 6
        let rootState = State(matrix: [
            [1, 2, 3],
            [4, 0, 5],
            [7, 8, 6],
        ])
        let action1States = [
            //      1 2 3      1 0 3
            // (B)  4 0 5  =>  4 2 5
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (C)  4 0 5  =>  0 4 5
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Left)),
            //      1 2 3      1 2 3
            // (D)  4 0 5  =>  4 8 5
            //      7 8 6      7 0 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Down)),
            //      1 2 3      1 2 3
            // (E)  4 0 5  =>  4 5 0
            //      7 8 6      7 8 6
            rootState.performAction(Action(movingPosition: (1,1), inDirection: .Right))
        ]
        let action2States = [
            //      1 0 3      0 1 3
            // (F)  4 2 5  =>  4 2 5
            //      7 8 6      7 8 6
            action1States[0].performAction(Action(movingPosition: (0,1), inDirection: .Left)),
            //      1 0 3      1 3 0
            // (G)  4 2 5  =>  4 2 5
            //      7 8 6      7 8 6
            action1States[0].performAction(Action(movingPosition: (0,1), inDirection: .Right)),
            //      1 2 3      0 2 3
            // (H)  0 4 5  =>  1 4 5
            //      7 8 6      7 8 6
            action1States[1].performAction(Action(movingPosition: (1,0), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (I)  0 4 5  =>  7 4 5
            //      7 8 6      0 8 6
            action1States[1].performAction(Action(movingPosition: (1,0), inDirection: .Down)),
            //      1 2 3      1 2 3
            // (J)  4 8 5  =>  4 8 5
            //      7 0 6      0 7 6
            action1States[2].performAction(Action(movingPosition: (2,1), inDirection: .Left)),
            //      1 2 3      1 2 3
            // (K)  4 8 5  =>  4 8 5
            //      7 0 6      7 6 0
            action1States[2].performAction(Action(movingPosition: (2,1), inDirection: .Right)),
            //      1 2 3      1 2 0
            // (L)  4 5 0  =>  4 5 3
            //      7 8 6      7 8 6
            action1States[3].performAction(Action(movingPosition: (1,2), inDirection: .Up)),
            //      1 2 3      1 2 3
            // (M)  4 5 0  =>  4 5 6
            //      7 8 6      7 8 0
            action1States[3].performAction(Action(movingPosition: (1,2), inDirection: .Down))
        ]
        
        // Set up traversed nodes
        nodes.updateValue(Node(initialState: rootState),                      forKey: "A")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[0]), forKey: "B")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[1]), forKey: "C")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[2]), forKey: "D")
        nodes.updateValue(Node(parent: nodes["A"]!, state: action1States[3]), forKey: "E")
        nodes.updateValue(Node(parent: nodes["B"]!, state: action2States[0]), forKey: "F")
        nodes.updateValue(Node(parent: nodes["B"]!, state: action2States[1]), forKey: "G")
        nodes.updateValue(Node(parent: nodes["C"]!, state: action2States[2]), forKey: "H")
        nodes.updateValue(Node(parent: nodes["C"]!, state: action2States[3]), forKey: "I")
        nodes.updateValue(Node(parent: nodes["D"]!, state: action2States[4]), forKey: "J")
        nodes.updateValue(Node(parent: nodes["D"]!, state: action2States[5]), forKey: "K")
        nodes.updateValue(Node(parent: nodes["E"]!, state: action2States[6]), forKey: "L")
        nodes.updateValue(Node(parent: nodes["E"]!, state: action2States[7]), forKey: "M")
    }
    
    func testBFSTraversal() {
        // Goes by breadth first FIFO
        // Expect A B C D E F G H I J K L M
        BreadthFirstSearch(goalState: goalState).traverse(nodes["A"]!)
        let expectedTraversal = [
            nodes["A"]!,
            nodes["B"]!,
            nodes["C"]!,
            nodes["D"]!,
            nodes["E"]!,
            nodes["F"]!,
            nodes["G"]!,
            nodes["H"]!,
            nodes["I"]!,
            nodes["J"]!,
            nodes["K"]!,
            nodes["L"]!,
            nodes["M"]!,
        ]
        XCTAssert(nodesTraversed == expectedTraversal)
    }
    
    func testGBFSTraversal() {
        // Goes by best evaluation function
        // Expect A E M
        let heuristic = MisplacedTilesCount(goalState: goalState)
        GreedyBestFirstSearch(goalState: goalState, heuristicFunction: heuristic).traverse(nodes["A"]!)
        let expectedTraversal = [
            nodes["A"]!,
            nodes["E"]!,
            nodes["M"]!,
        ]
        XCTAssert(nodesTraversed == expectedTraversal)
    }
    
    func testASTraversal() {
        // Goes by best evaluation function 
        // Expect A E M
        let heuristic = MisplacedTilesCount(goalState: goalState)
        AStarSearch(goalState: goalState, heuristicFunction: heuristic).traverse(nodes["A"]!)
        let expectedTraversal = [
            nodes["A"]!,
            nodes["E"]!,
            nodes["M"]!,
        ]
        XCTAssert(nodesTraversed == expectedTraversal)
    }
}