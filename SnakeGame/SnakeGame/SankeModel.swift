//
//  SankeModel.swift
//  SnakeGame
//
//  Created by Sarvar Qosimov on 03/05/23.
//

import Foundation

enum Direction {
    case up, right, left, down
}

struct Points {
    var x: Int
    var y: Int
}

struct Snake {
    
    var points: [Points]

    var direction: Direction = .down
    
    init(points: [Points]) {
        self.points = points
    }
        
    mutating func getNewHeadPoint() -> Points{
       
        var newPoint = points[0]
        
        switch direction {
        case .up:       newPoint.y -= 1
        case .right:    newPoint.x += 1
        case .left:     newPoint.x -= 1
        case .down:     newPoint.y += 1
        }
        return newPoint
    }
    
    mutating func move(){
        
        let head = getNewHeadPoint()
        points.insert(head, at: 0)
        points.removeLast()
    }
    
    mutating func increaseSnakeLength(point: Points){
        points.append(point)
    }
    
    func isHitToArea() -> Bool {
        for point in points {
            if point.x < 0 || CGFloat(point.x) > GamingView.maxX {
                return true
            }
            
            if point.y < 0 || CGFloat(point.y) > GamingView.maxY {
                return true
            }
        }
        return false
    }
    
    func isHitToBody() -> Bool {
        for i in 1...points.count - 1 {
            if points[i].x == points[0].x &&
                points[i].y == points[0].y {
                return true
            }
        }
        return false
    }
    
    
    
}
