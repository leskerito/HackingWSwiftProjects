//
//  ViewController.swift
//  Project8
//
//  Created by Franck Kindia on 16/07/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
        
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Guess the word"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        let buttonSize: CGFloat = 50

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            submit.leadingAnchor.constraint(equalTo: currentAnswer.leadingAnchor, constant: 30),
            clear.trailingAnchor.constraint(equalTo: currentAnswer.trailingAnchor, constant: -30),
            submit.heightAnchor.constraint(equalToConstant: buttonSize),
            clear.heightAnchor.constraint(equalToConstant: buttonSize),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20)
        ])
        
        let buttonWidth = 150
        let buttonHeight = 80
        
        for i in 0 ..< 4 {
            for j in 0 ..< 5 {
                let button = UIButton(type: .system)
                
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                
                button.setTitle("BBC", for: .normal)
                
                let frame = CGRect(x: j * buttonWidth, y: i * buttonHeight, width: buttonWidth, height: buttonHeight)
                button.frame = frame
                
                button.layer.borderColor = UIColor.gray.cgColor
                button.layer.borderWidth = 1
                
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText){
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
                    splitAnswers?[solutionPosition] = answerText
                    answersLabel.text = splitAnswers?.joined(separator: "\n")

                    currentAnswer.text = ""
                    score += 1

            if score > 4 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            } else if score < 0 {
                let ac = UIAlertController(title: "You lost!", message: "You should try again!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: resetLevel))
                
            }
        } else {
            let fail = UIAlertController(title: "Bzzt ❌", message: "Try again!", preferredStyle: .alert)
            fail.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: failCancel))
            present(fail, animated: true)
        }
    }
    
    @objc func levelUp(action: UIAlertAction){
        solutions.removeAll(keepingCapacity: true)
        level += 1
        score = 0
        loadLevel()
        
        for btn in letterButtons {
            btn.titleLabel?.textColor = btn.titleColor(for: .normal)
            btn.isEnabled = true
        }
    }
    
    @objc func resetLevel(action: UIAlertAction){
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for btn in letterButtons {
            btn.titleLabel?.textColor = btn.titleColor(for: .normal)
            btn.isEnabled = true
        }
    }
    
    @objc func failCancel(action: UIAlertAction){
        score -= 1
        
        if score < 0 {
            
        }
        clearTapped()
    }
    
    @objc func clearTapped(){
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.titleLabel?.textColor = btn.titleColor(for: .normal)
            btn.isEnabled = true
        }
        
        activatedButtons.removeAll()
    }
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonText = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonText)
        activatedButtons.append(sender)
        sender.titleLabel?.textColor = .lightGray
        sender.isEnabled = false
    }


}

