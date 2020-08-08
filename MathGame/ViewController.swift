//
//  ViewController.swift
//  MathGame
//
//  Created by Matt Moran on 8/4/20.
//  Copyright © 2020 Matt Moran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var correctAnswer = "" //Correct answer for each round
    var score = 0 //Current score
    var answers = [0,0,0,0] //Four possible answers
    var streak = 1 //Number of successful answers in a row
    var viewStreak = 0 //Displayed streak number
    var highScore = 0 //High score saved between sessions
    var counter = 120
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //timerLabel.text = String(counter)
        title = String(counter)
        
        //Load high score from past sessions
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "HighScore")
        highScoreLabel.text = String(highScore)
        
        //Reset button for resetting high score
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetHighScore))
        
        //Presents user with a tutorial
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "?", style: .plain, target: self, action: #selector(tutorial))
        
        tutorial() // Calls tutorial function to explain rules to user
        
        //Sets timer
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        prompt()
    }
    
    //Updates timer
    @objc func updateTimer() {
        counter = counter - 1
        //timerLabel.text = String(counter)
        title = String(counter)
        if counter == 0 {
            score = 0
            streak = 1
            viewStreak = 0
            counter = 120
            scoreLabel.text = String(score)
            streakLabel.text = String(viewStreak)
        }
    }
    
    //Explains to user how game works
    @objc func tutorial(){
        let ac = UIAlertController(title: "How to Play", message: "Choose the appropriate equivalent number. The number of correct answers in a row will impact the difficulty of the game. You have 2 minutes to answer as many questions as possible correctly.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    //Presents prompt asking user if they would like to reset their high score.
    @objc func resetHighScore(){
        let ac = UIAlertController(title: "Reset High Score?", message: "Select option.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reset))
        ac.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    //Resets high score
    func reset(action: UIAlertAction! = nil){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "HighScore")
        highScoreLabel.text = "0"
    }
    
    //Presents user with question
    func prompt(action: UIAlertAction! = nil) {
        //If the user has gotten more than 5 questions right in a row, they may recieve negative numbers to increase the difficulty
        if(streak > 5){
            if(Int.random(in: 0...1)==0){
                let firstNumber = Int.random(in: 0...(100*streak)) //Generates random number that increases in range with each correct answer
                let secondNumber = Int.random(in: 0...(100*streak))
                
                answers[0] = (firstNumber + secondNumber) //Sets answer
                correctAnswer = String(answers[0])
                
                answers[1] = (Int.random(in: 0...(200*streak))) //Generates wrong answers
                answers[2] = (Int.random(in: 0...(200*streak)))
                answers[3] = (Int.random(in: 0...(200*streak)))
                
                unique(x:0) //Checks to see if all possibel answers are unique
                answers.shuffle() //Randomizes the order of the answers
                
                button1.setTitle(String(answers[0]), for: .normal)
                button2.setTitle(String(answers[1]), for: .normal)
                button3.setTitle(String(answers[2]), for: .normal)
                button4.setTitle(String(answers[3]), for: .normal)
                
                //title = "\(firstNumber) + \(secondNumber)"
                timerLabel.text = "\(firstNumber) + \(secondNumber) = ?"
            } else {
                let firstNumber = Int.random(in: (-100*streak)...(100*streak))
                let secondNumber = Int.random(in: (-100*streak)...(100*streak))
                
                answers[0] = (firstNumber + secondNumber)
                correctAnswer = String(answers[0])
                
                answers[1] = (Int.random(in: (-200*streak)...(200*streak)))
                answers[2] = (Int.random(in: (-200*streak)...(200*streak)))
                answers[3] = (Int.random(in: (-200*streak)...(200*streak)))
                
                unique(x:1)
                answers.shuffle()
                
                button1.setTitle(String(answers[0]), for: .normal)
                button2.setTitle(String(answers[1]), for: .normal)
                button3.setTitle(String(answers[2]), for: .normal)
                button4.setTitle(String(answers[3]), for: .normal)
                
                //title = "\(firstNumber) + \(secondNumber)"
                timerLabel.text = "\(firstNumber) + \(secondNumber) = ?"
            }
            
        } else {
            let firstNumber = Int.random(in: 0...(100*streak))
            let secondNumber = Int.random(in: 0...(100*streak))
            
            answers[0] = (firstNumber + secondNumber)
            correctAnswer = String(answers[0])
            
            answers[1] = (Int.random(in: 0...(200*streak)))
            answers[2] = (Int.random(in: 0...(200*streak)))
            answers[3] = (Int.random(in: 0...(200*streak)))
            
            unique(x:0)
            answers.shuffle()
            
            button1.setTitle(String(answers[0]), for: .normal)
            button2.setTitle(String(answers[1]), for: .normal)
            button3.setTitle(String(answers[2]), for: .normal)
            button4.setTitle(String(answers[3]), for: .normal)
            
            //title = "\(firstNumber) + \(secondNumber)"
            timerLabel.text = "\(firstNumber) + \(secondNumber) = ?"
        }
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        //var title: String
        
        //Checks to see if the user chose the correct answer and adjusts the score appropriately
        if sender.currentTitle == correctAnswer {
            score+=1
            title = "Correct"
            streak+=1
            viewStreak+=1
            
            if streak > 10 {
                streak = 10
            }
            
            streakLabel.text = String(viewStreak) //Update displayed streak number
            
            let defaults = UserDefaults.standard
            
            if(score > defaults.integer(forKey: "HighScore")){ //If user attained a new high score, set high score appropriately
                defaults.set(score, forKey: "HighScore")
                highScore = defaults.integer(forKey: "HighScore")
                highScoreLabel.text = String(highScore)
            }
        } else {
            title = "Incorrect"
            streak = 1
            viewStreak = 0
            streakLabel.text = String(viewStreak)
        }
        
        scoreLabel.text = String(score) //Update displayed score number
        
        //Presents user with a prompt detailing updated scores
        //let ac = UIAlertController(title: title, message: "Your score is \(score). Your current streak is \(viewStreak). Your record is \(highScore).", preferredStyle: .alert)
        //ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: prompt))
        //present(ac, animated: true)
        prompt()
    }
    
    //Randomizes possible answers until they are all unique
    func unique(x: Int){
        if x == 0 {
            while (answers[0]==answers[1] || answers[0]==answers[2] || answers[0]==answers[3] || answers[1]==answers[2] || answers[1]==answers[3] || answers[2]==answers[3]){
                answers[1] = (Int.random(in: 0...(200*streak)))
                answers[2] = (Int.random(in: 0...(200*streak)))
                answers[3] = (Int.random(in: 0...(200*streak)))
                }
        } else {
            while (answers[0]==answers[1] || answers[0]==answers[2] || answers[0]==answers[3] || answers[1]==answers[2] || answers[1]==answers[3] || answers[2]==answers[3]){
            answers[1] = (Int.random(in: (-200*streak)...(200*streak)))
            answers[2] = (Int.random(in: (-200*streak)...(200*streak)))
            answers[3] = (Int.random(in: (-200*streak)...(200*streak)))
        }
        
    }
    }
}

