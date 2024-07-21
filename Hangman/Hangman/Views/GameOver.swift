//
//  GameOver.swift
//  Hangman
//
//  Created by Franck Kindia on 20/07/2024.
//

import UIKit

class GameOver: UIViewController {
    
    var state: String?
    
    convenience init(){
        self.init(state: nil)
    }
    
    init(state: String?){
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        print(state ?? "Hello World")
    }
}
