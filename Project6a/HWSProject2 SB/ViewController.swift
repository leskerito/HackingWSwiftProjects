//
//  ViewController.swift
//  HWSProject2 SB
//
//  Created by Franck Kindia on 30/06/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    @IBOutlet var toBeGuessed: UITextView!
    @IBOutlet weak var responseText: UITextView!
    @IBOutlet weak var lastQuestionText: UITextView!
    
    var countries = [String]()
    var  correctAnswer = 0
    var score = 0
    var questionsAsked = 0
    let animationMovement = CGFloat(10)
    var fadeIn: (Double, UIView?) -> Void = {
        (length: Double, view: UIView!) in
        UIView.animate (withDuration: length, animations: {
            view.layer.opacity = 1
        })
    }
    var fadeOut: (Double, UIView?) -> Void = {
        (arg: Double, str: UIView!) in
        UIView.animate (withDuration: arg, animations: {
            str.layer.opacity = 0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        responseText.layer.opacity = 0
        lastQuestionText.layer.opacity = 0
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(showScore))
    }
    
    @objc func showScore(){
        let vc = UIAlertController(title: "Score Break", message: "Your score right now is \(score)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Roger that.", style: .cancel))
        
        present(vc, animated: true)
        
    }
    
    
    func askQuestion(action: UIAlertAction! = nil){
        fadeOut(0.8, responseText)

        if questionsAsked == 9 {
            fadeIn(0.3, lastQuestionText)
            UIView.animate(withDuration: 3, animations: {
                self.lastQuestionText.layer.opacity = 0
            })
        }
        
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        toBeGuessed.text = "GUESS THE FLAG:\n\(countries[correctAnswer].uppercased())"
    
        print(questionsAsked, "Questions Asked")
        questionsAsked += 1
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        var answerIs: String = ""
        self.responseText.frame.origin.y = self.responseText.frame.origin.y - self.animationMovement
        
        if sender.tag == correctAnswer {
            answerIs = "Correct! +1"
            responseText.textColor = UIColor.green
            score+=1
        } else {
            answerIs = "Wrong! -1"
            responseText.textColor = UIColor.red
            score-=1
        }
        if countries[sender.tag] == "russia" {
            answerIs += ", comrade!"
        }
        responseText.text = answerIs
        fadeIn(0.1, responseText)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.responseText.frame.origin.y = self.responseText.frame.origin.y + self.animationMovement
        })
        
        let endMessage = score >= 5 ? "Congrats! You scored \(score)" : "Too bad... You only scored \(score). Better luck next time!"
        
        let restart = UIAlertController(title: "Game Over!", message: endMessage, preferredStyle: .alert)
        restart.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: askQuestion))

        
        if questionsAsked == 10 {
            print("Question 10")
            questionsAsked = 0
            score = 0
            present(restart, animated: true)
        }
        
        askQuestion()
    }
}

