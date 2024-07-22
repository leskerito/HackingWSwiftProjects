//
//  Start.swift
//  Hangman
//
//  Created by Franck Kindia on 20/07/2024.
//

import UIKit

class Start: UIViewController {
    
    var titleLabel: UILabel!
    var startLabel: UILabel!
    var rulesButton: UIButton!
    var settingsButton: UIButton!
    var background: UIImageView!
    let sp = SharedProperties()
    
    override func loadView() {
        
        super.loadView()
        
        if let nc = self.navigationController {
            nc.isNavigationBarHidden = true
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startGame(tapGestureRecognizer:)))
        view.addGestureRecognizer(gestureRecognizer)

        background = UIImageView()
        background.image = UIImage(contentsOfFile: sp.backgroundPath!)
        print(background.image!)
        background.isUserInteractionEnabled = true
        background.translatesAutoresizingMaskIntoConstraints = false
        background.contentMode = .scaleToFill
        
        view.addSubview(background)
        
        
        titleLabel = UILabel()
        titleLabel.text = "The Hangman"
        titleLabel.textColor = sp.backgroundColor
        titleLabel.font = UIFont(name: "Avenir Next Ultra Light", size: 50)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        startLabel = UILabel()
        startLabel.text = "Tap the screen to start"
        startLabel.textColor = sp.backgroundColor
        startLabel.font = UIFont(name: sp.font, size: 30)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startLabel)
        
        rulesButton = UIButton(type: .system)
        rulesButton.setTitle("Rules", for: .normal)
        rulesButton.setTitleColor(sp.backgroundColor, for: .normal)
        rulesButton.translatesAutoresizingMaskIntoConstraints = false
        rulesButton.titleLabel?.font = UIFont(name: sp.font, size: 20)
        rulesButton.addTarget(self, action: #selector(showRules), for: .touchUpInside)
        view.addSubview(rulesButton)
        
        settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(sp.backgroundColor, for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: sp.font, size: 20)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.topAnchor.constraint(equalTo: view.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            startLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 80),
            rulesButton.centerXAnchor.constraint(equalTo: startLabel.centerXAnchor),
            rulesButton.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 50),
            settingsButton.topAnchor.constraint(equalTo: rulesButton.bottomAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: rulesButton.centerXAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func showRules(){
        let rules = Rules()
        present(rules, animated: true)
    }
    
    @objc func showSettings(){
        self.navigationController?.pushViewController(Settings(), animated: true)
    }
    
    @objc func startGame(tapGestureRecognizer: UITapGestureRecognizer){
        self.navigationController?.pushViewController(GameScreen(), animated: true)
        
    }
}
