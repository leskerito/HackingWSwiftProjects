//
//  Start.swift
//  Hangman
//
//  Created by Franck Kindia on 20/07/2024.
//

import UIKit

class Start: UIViewController {
    
    var startLabel: UILabel!
    var rulesButton: UIButton!
    var settingsButton: UIButton!
    var background: UIImageView!
    let sp = SharedProperties()
    
    override func loadView() {
        
        super.loadView()
        
        
        background = UIImageView(image: UIImage(contentsOfFile: sp.backgroundPath!))
        background.contentMode = .scaleAspectFit
        background.clipsToBounds = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startGame(tapGestureRecognizer:)))
        background.addGestureRecognizer(gestureRecognizer)
        background.isUserInteractionEnabled = true
        
        view.addSubview(background)
        
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
            startLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
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
        print("Rules screen should appear")
        self.navigationController?.pushViewController(Rules(), animated: true)
    }
    
    @objc func showSettings(){
        self.navigationController?.pushViewController(Settings(), animated: true)
    }
    
    @objc func startGame(tapGestureRecognizer: UITapGestureRecognizer){
        self.navigationController?.pushViewController(GameScreen(), animated: true)
        
    }
}
