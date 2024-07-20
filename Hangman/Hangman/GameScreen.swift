//
//  ViewController.swift
//  Hangman
//
//  Created by Franck Kindia on 17/07/2024.
//

import UIKit

class GameScreen: UIViewController {

    //Initializing all the views
    var scoreLabel: UILabel!
    var trialsLabel: UILabel!
    var backgroundLifeView: UIImageView!
    var currentWord: UILabel!
    var buttonsView: UIView!
    let primaryColor = UIColor(red: 0.45, green: 0.66, blue: 0.51, alpha: 1.00)
    let backgroundColor = UIColor(red: 0.22, green: 0.24, blue: 0.23, alpha: 1.00)
    let textColor = UIColor(red: 0.89, green: 0.97, blue: 0.88, alpha: 1.00)
    
    //Initializing all the logical elements
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score) points"
        }
    }
    
    var trials = 10 {
        didSet {
            trialsLabel.text = "\(trials) trials remaining"
        }
    }
    var solution = "adam'5"
    var pressedButton = [UIButton]()
    var letterButtons = [UIButton]()
    var level = 1
    
    
    override func loadView(){
        
        super.loadView()
        
        view.backgroundColor = backgroundColor
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        scoreLabel.textAlignment = .center
        scoreLabel.text = "0 points"
        view.addSubview(scoreLabel)
        
        backgroundLifeView = UIImageView()
        backgroundLifeView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLifeView.setContentHuggingPriority(.dragThatCanResizeScene, for: .vertical)
        let backgroundPath = Bundle.main.path(forResource: "startpaper", ofType: "jpg")
        backgroundLifeView.image = UIImage(contentsOfFile: backgroundPath!)
        backgroundLifeView.contentMode = .scaleAspectFill
        backgroundLifeView.clipsToBounds = true
        view.addSubview(backgroundLifeView)
        
        currentWord = UILabel()
        currentWord.translatesAutoresizingMaskIntoConstraints = false
        currentWord.text = "READY?"
        currentWord.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(currentWord)
        
        trialsLabel = UILabel()
        trialsLabel.translatesAutoresizingMaskIntoConstraints = false
        trialsLabel.textAlignment = .center
        trialsLabel.text = "\(trials) trials remaining"
        trialsLabel.font = UIFont.systemFont(ofSize: 10)
        view.addSubview(trialsLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            trialsLabel.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
            trialsLabel.topAnchor.constraint(equalTo: backgroundLifeView.bottomAnchor),
            trialsLabel.bottomAnchor.constraint(equalTo: currentWord.topAnchor),
            currentWord.topAnchor.constraint(equalTo: trialsLabel.bottomAnchor),
            currentWord.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
            currentWord.bottomAnchor.constraint(equalTo: buttonsView.topAnchor),
            buttonsView.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5),
            backgroundLifeView.centerXAnchor.constraint(equalTo: scoreLabel.centerXAnchor),
            backgroundLifeView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            backgroundLifeView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            backgroundLifeView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            backgroundLifeView.bottomAnchor.constraint(equalTo: trialsLabel.topAnchor)
        ])
        DispatchQueue.global(qos: .default).async {
            if let path = Bundle.main.url(forResource: "alphabet", withExtension: "txt") {
                if let lettersJoined = try? String(contentsOf: path) {
                    let alphabet = lettersJoined.components(separatedBy: "\n")
                    
                    let buttonsPerRow = 9
                    var currentRow = 0
                    var currentColumn = 0
                    
                    for (index, letter) in alphabet.enumerated() {
                        let letterButton = UIButton(type: .system)
                        letterButton.setTitle(letter, for: .normal)
                        letterButton.setTitleColor(self.primaryColor, for: .normal)
                        letterButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: letterButton.titleLabel!.font.pointSize)
                        letterButton.translatesAutoresizingMaskIntoConstraints = false
                        letterButton.addTarget(self, action: #selector(self.letterTapped), for: .touchUpInside)
                        DispatchQueue.main.async {
                            self.buttonsView.addSubview(letterButton)
                            
                            if currentColumn >= buttonsPerRow {
                                currentColumn = 0
                                currentRow += 1
                            }
                            
                            let topAnchor = currentRow == 0 ? self.buttonsView.topAnchor : self.buttonsView.subviews[index - buttonsPerRow].bottomAnchor
                            let leadingAnchor = currentColumn == 0 ? self.buttonsView.leadingAnchor : self.buttonsView.subviews[index - 1].trailingAnchor
                            
                            NSLayoutConstraint.activate([
                                letterButton.widthAnchor.constraint(equalTo: self.buttonsView.widthAnchor, multiplier: 1.0/CGFloat(buttonsPerRow)),
                                letterButton.heightAnchor.constraint(equalTo: self.buttonsView.heightAnchor, multiplier: 1.0/3.0),
                                letterButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                                letterButton.topAnchor.constraint(equalTo: topAnchor)
                            ])
                            
                            currentColumn += 1
                        }
                    }
                }
            }
        }
        
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = textColor
                label.font = UIFont(name: "Avenir-Heavy", size: label.font.pointSize)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRandomWord(action: UIAlertAction())
    }
    
    func fetchRandomWord(action: UIAlertAction){
        let decoder = JSONDecoder() //Create a json decoder to decipher result
        
        let apiKey = "cVXPjRM3zwU3Ahom48xA9g==oXUsul4Mp3LYBzvi" // Api Key
        let url = URL(string: "https://api.api-ninjas.com/v1/randomword")! //Api URL
        
        var request = URLRequest(url: url) //Create a request based on the api's url
        
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key") //Change the API's Header so that it can read my key.
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.handleClientError()
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.handleServerError()
                }
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json"{
                guard let data = data else { return }
                if let random = try? decoder.decode(randomWord.self, from: data){
                    DispatchQueue.main.async {
                        self.solution = random.word[0].uppercased()
                        self.loadLevel()
                    }
                }
            }
        }
        task.resume()
    }
    
    func loadLevel(){
    
        for button in pressedButton {
            button.isEnabled = true
            button.setTitleColor(primaryColor, for: .normal)
        }
        backgroundLifeView.alpha = 1
        trials = 10
        print(solution)
        currentWord.text = ""
        pressedButton.removeAll()
        
        for _ in 0 ... solution.count-2 {
            currentWord.text? += "-"
        }
        currentWord.text? += "- "
        
    }
    
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonLetter = sender.titleLabel?.text else { return }
        var r = solution.ranges(of: buttonLetter)
        if r.count > 0 {
            score += 1
            while r.count > 0 {
                replace(in: currentWord.text!, atIndex: r[0].lowerBound, with: Character(buttonLetter))
                r.removeFirst()
            }
            if currentWord.text!.trimmingCharacters(in: .whitespacesAndNewlines) == solution {
                gameOver(state: "win")
            }
        } else {
            wrongLetter(sender)
        }
        pressedButton.append(sender)
        sender.setTitleColor(.black, for: .normal)
        sender.isEnabled = false
        
    }
    
    func replace(in myString: String, atIndex ind: String.Index, with c: Character){
        var stringArray = Array(myString)
        let index = myString.distance(from: myString.startIndex, to: ind)
        stringArray[index] = c
        currentWord.text = String(stringArray)
    }
    
    func wrongLetter(_ button: UIButton){
        trials -= 1
        score -= 1
        backgroundLifeView.alpha -= 0.1
        if trials == 0 {
            gameOver(state: "lose")
        }
        
    }
    
    func handleClientError(){
        let ac = UIAlertController(title: "Oops", message: "Something went wrong. Check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: fetchRandomWord))
        present(ac, animated: true)
    }
    
    func handleServerError(){
        let ac = UIAlertController(title: "Oops", message: "Something went wrong. Try again in a few minutes", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Retry", style: .cancel, handler: fetchRandomWord))
        present(ac, animated: true)
    }
    
    func gameOver(state: String){
        let alertTitle: String
        let alertMessage: String
        print("Game Over")
        
        if state == "win"{
            alertTitle = "Congratulations!"
            alertMessage = "You found \(solution). Wanna try again?"
            level += 1
        } else {
            alertTitle = "Too bad."
            alertMessage = "Better luck next time? You should try again."
            score = 0
        }
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: fetchRandomWord))
        present(ac, animated: true)
    }
}

