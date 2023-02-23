//
//  ContentView.swift
//  SnakeGame
//
//  Created by Mohammed Alsayed on 19/06/1444 AH.
//

import SwiftUI

enum direction {
    case up, down, left, right
}

struct ContentView: View {
    @State var startPos : CGPoint = .zero  // the start poisition of our swipe
    @State var isStarted = true  // did the user started the swipe?
    @State var gameOver = false// for ending the game when the snake hits the screen borders
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    // to updates the snake position every 0.1 second
    
    
    @State private var score = 0
    
    @State var dir = direction.down // the direction the snake is going to take
    
    @State var posArray = [CGPoint(x: 0, y: 0)]  // array of the snake's body positions
    @State var foodPos = CGPoint(x: 0, y: 0)  // the position of the food
    
    let snakeSize : CGFloat = 20  // width and height of the snake
    
    
    
    var body: some View {

        
        ZStack {
            Color.white.opacity(0.3)
            
            ZStack {
         
                
                ForEach (0..<posArray.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: self.snakeSize, height: self.snakeSize)
                        .cornerRadius(2)
                        .position(self.posArray[index])
                }
                Circle()
                    .fill(Color.red)
                    .frame(width: snakeSize, height: snakeSize)
                    .position(foodPos)
                
                
                HStack{
                    //                    Text("SCORE: ")
                    //                        .font(.headline)
                    Text("\(score)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top,85)
                    
                }
                
                   

            }
            
            
            if self.gameOver {
                
                ZStack{
                    Rectangle()
                        .frame(width: 300 , height: 200)
                        .foregroundColor(.white)
//                        .border(.black)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.5), radius: 10)
                    
                    VStack{
                        
                        VStack{
                            Text("SCORE")
                                .font(.title2)
                                .padding()
                            
                            Text("\(score)")
                                .font(.title2)
                                .fontWeight(.medium)
                               
                           
                        }
                        .padding()
                        
                        Button("PLAY AGAIN"){
                            startGame()
                               
                        }
                        .padding()
                        .background(Color(red: 0, green: 0, blue: 0.5))
                        .clipShape(Capsule())
                        

                        
                    }
                    
                }
                
            }
            
            
        }.onAppear() {
            self.foodPos = self.changeRectPos()
            self.posArray[0] = self.changeRectPos()
        }
        .gesture(DragGesture()
        .onChanged { gesture in
            if self.isStarted {
                self.startPos = gesture.location
                self.isStarted.toggle()
            }
        }
        .onEnded {  gesture in
            let xDist =  abs(gesture.location.x - self.startPos.x)
            let yDist =  abs(gesture.location.y - self.startPos.y)
            if self.startPos.y <  gesture.location.y && yDist > xDist {
                self.dir = direction.down
            }
            else if self.startPos.y >  gesture.location.y && yDist > xDist {
                self.dir = direction.up
            }
            else if self.startPos.x > gesture.location.x && yDist < xDist {
                self.dir = direction.right
            }
            else if self.startPos.x < gesture.location.x && yDist < xDist {
                self.dir = direction.left
            }
            self.isStarted.toggle()
            }
        )
        .onReceive(timer) { (_) in
            if !self.gameOver {
                self.changeDirection()
                if self.posArray[0] == self.foodPos {
                    self.posArray.append(self.posArray[0])
                    self.foodPos = self.changeRectPos()
                    self.score+=1
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    let minX = UIScreen.main.bounds.minX
    let maxX = UIScreen.main.bounds.maxX
    let minY = UIScreen.main.bounds.minY
    let maxY = UIScreen.main.bounds.maxY
    
    
    func changeDirection () {
        if self.posArray[0].x < minX || self.posArray[0].x > maxX && !gameOver{
            gameOver.toggle()
        }
        else if self.posArray[0].y < minY || self.posArray[0].y > maxY  && !gameOver {
            gameOver.toggle()
        }
        var prev = posArray[0]
        if dir == .down {
            self.posArray[0].y += snakeSize
        } else if dir == .up {
            self.posArray[0].y -= snakeSize
        } else if dir == .left {
            self.posArray[0].x += snakeSize
        } else {
            self.posArray[0].x -= snakeSize
        }
        
        for index in 1..<posArray.count {
            let current = posArray[index]
            posArray[index] = prev
            prev = current
        }
    }
    
    func changeRectPos() -> CGPoint {
        let rows = Int(maxX/snakeSize)
        let cols = Int(maxY/snakeSize)
        
        let randomX = Int.random(in: 1..<rows) * Int(snakeSize)
        let randomY = Int.random(in: 1..<cols) * Int(snakeSize)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
  
    func startGame() {
          withAnimation(.easeInOut) {
              score = 0
              posArray = [CGPoint(x: 0, y: 0)]
              
              gameOver = false
              isStarted = true
              foodPos = changeRectPos()
              posArray[0] = changeRectPos()
              changeDirection()
          }
      }
    
}

