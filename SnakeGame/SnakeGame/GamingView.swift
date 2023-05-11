//
//  GamingView.swift
//  SnakeGame
//
//  Created by Sarvar Qosimov on 03/05/23.
//

import UIKit

class GamingView: UIViewController {

    @IBOutlet weak var gameArea: UIView!
    
    @IBOutlet weak var startBtn: UIButton!
    
    var timer: Timer!
    
    
    let gridSize = 20
    static var maxX: CGFloat!
    static var maxY: CGFloat!
    var snakeView = [UIView]()
    var x = 10, y = 8
    var foodView = UIView.init()
    var snake = Snake(points: [
        Points(x: 5, y: 5),
        Points(x: 6, y: 5),
        Points(x: 7, y: 5)
    ])
    
    var shouldRestart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GamingView.maxX = gameArea.frame.width / CGFloat(gridSize)
        GamingView.maxY = gameArea.frame.height / CGFloat(gridSize)
        
        for direction in [
            UISwipeGestureRecognizer.Direction.up,
            UISwipeGestureRecognizer.Direction.right,
            UISwipeGestureRecognizer.Direction.left,
            UISwipeGestureRecognizer.Direction.down,
        ] {
            
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
            swipeGesture.direction = direction
            swipeGesture.numberOfTouchesRequired = 1
           
            self.gameArea.addGestureRecognizer(swipeGesture)
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameArea.layer.borderColor = UIColor.black.cgColor
        gameArea.layer.borderWidth = 3
    }
    
//MARK: swiped
    
    @objc func swiped(_ recognizer: UISwipeGestureRecognizer) {
        
        switch recognizer.direction {
        case .down: snake.direction = .down
        case .left: snake.direction = .left
        case .right: snake.direction = .right
        default: snake.direction = .up
        }
    }
    
//MARK: timerAction
    
    @objc func timerAction(_ sender: Any){
        
        snake.move()
        
        if !snake.isHitToArea() && !snake.isHitToBody(){
            drawSnake()
            makeFood()
        } else {
          
            endGame()
            startBtn.backgroundColor = .red
            startBtn.setTitle("Try again", for: .normal)
            startBtn.isHidden = false
        }
       
        
    }
    
//MARK: - startPressed -
    
    @IBAction func startPressed(_ sender: Any) {

        resetGame()
        startBtn.isHidden = true
        
    }
    
//MARK: createSnakView
    
    func createSnakView(point: Points){
        
        let view = UIView.init(frame: CGRect(
            x: point.x * gridSize,
            y: point.y * gridSize,
            width: gridSize,
            height: gridSize)
        )
        
        if snakeView.count == 0 {
            view.backgroundColor = .brown
            view.layer.cornerRadius = CGFloat(gridSize / 2)
            gameArea.addSubview(view)
        } else {
            view.backgroundColor = .brown
            view.layer.opacity = 0.75
            view.layer.cornerRadius = CGFloat(gridSize / 2)
            gameArea.addSubview(view)
        }
        
        snakeView.append(view)
        
    }
    
//MARK: makeFood
    
    func makeFood(){
       
        var isInSnakeBody = false
        
        for point in snake.points {
            if point.x == x && point.y == y {
                isInSnakeBody = true
            }
        }
        
        if isInSnakeBody {
            x = Int.random(in: 1...Int(GamingView.maxX-1))
            y = Int.random(in: 1...Int(GamingView.maxY-1))
            
            snake.increaseSnakeLength(point: snake.points.last!)
            createSnakView(point: snake.points.last!)
            print(snakeView.count)
            if isUserWon() {
                endGame()
            }
            foodView.frame = CGRect(
                x: x * gridSize,
                y: y * gridSize,
                width: gridSize,
                height: gridSize)
        }
    }
    
//MARK: - drawSnake -
    
    func drawSnake(){
        for i in 0...snake.points.count - 1 {
            snakeView[i].frame.origin.x = CGFloat(snake.points[i].x * gridSize)
            snakeView[i].frame.origin.y = CGFloat(snake.points[i].y * gridSize)
        }
    }
    
//MARK: isUserWon
    
    func isUserWon() -> Bool{
        if snakeView.count == 15 {
            startBtn.backgroundColor = .green
            startBtn.setTitle("You won", for: .normal)
            startBtn.isHidden = false
            return true
        }
            return false
    }
   
//MARK: endGame
    
    func endGame(){
        timer.invalidate()
        timer = nil
    }

//MARK: resetGame
    
    func resetGame(){
        //remove views
        for view in snakeView.enumerated() {
            view.element.removeFromSuperview()
        }
        snakeView.removeAll()
        foodView.removeFromSuperview()
        foodView = UIView()
        snake.points = [
            Points(x: 5, y: 5),
            Points(x: 6, y: 5),
            Points(x: 7, y: 5)
        ]
        snake.direction = .down
        // setup 3 default snake to begin game
        for i in snake.points {
            createSnakView(point: i)
        }
        
        // setup foodView
        foodView.frame = CGRect(
            x: x * gridSize,
            y: y * gridSize,
            width: gridSize,
            height: gridSize)
        
        foodView.backgroundColor = .red
        gameArea.addSubview(foodView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
    }
    
}
