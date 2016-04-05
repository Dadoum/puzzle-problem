//
//  IterativeAStarSearch.swift
//  PuzzleProblem
//
//  Created by Alex on 5/04/2016.
//  Copyright © 2016 Alex. All rights reserved.
//

///
/// An Iterative Deepening A Star Search is essentially an A Star search however
/// it will not expand nodes whose evaluation function results in a value greater than
/// the threshold
/// - Complexity:
///     - **Time:**  O(b<sup>m</sup>)
///     - **Space:** O(b<sup>mb</sup>)
///
struct IterativeDeepeningAStarSearch: SearchMethod {
    // MARK: Implement SearchMethod
    static var name: String = "Iterative Deepening A Star Search"
    static var code: String = "IDAS"
    var goalState: State
    var frontier: Frontier
    
    // Override the expand node and only expand if this node doesn't exceed the threshold
    func shouldTryToExpandNode(node: Node) -> Bool {
        let distanceToGoal = (self.frontier as? EvaluatedFrontier)!.distanceToGoal(node)
        return distanceToGoal < self.threshold
    }
    
    ///
    /// The threshold value to not expand nodes when evaluated to be greater than this value
    ///
    let threshold: Int
    
    ///
    /// Initaliser for a Depth First Search
    /// - Parameter goalState: The search's goal state
    /// - Parameter heuristicFunction: The heuristic used in the evaluation function
    /// - Parameter threshold: Do not traverse nodes who evaluate to a value greater than
    ///                        the threshold
    ///
    init(goalState: State, heuristicFunction: HeuristicFunction, threshold: Int) {
        self.goalState = goalState
        self.threshold = threshold
        // A Star uses a heuristic frontier with a heuristic and path cost
        // evaluation function, that is f(n) = g(n) + h(n)
        let evaluationFunction = HeuristicAndPathCostEvaluation(heuristicFunction: heuristicFunction)
        self.frontier = EvaluatedFrontier(evaluationFunction: evaluationFunction)
    }
}