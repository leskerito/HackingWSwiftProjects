//
//  RuleScreen.swift
//  Hangman
//
//  Created by Franck Kindia on 18/07/2024.
//

import UIKit

class RuleScreen: UIViewController {
    
    var rulesLabel: UILabel!
    var rulesText: String?

    override func loadView() {
        rulesLabel = UILabel()
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(rulesLabel)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let rulesURL = Bundle.main.url(forResource: "rules", withExtension: "txt"){
            print(rulesURL)
        }
    
    }
}
