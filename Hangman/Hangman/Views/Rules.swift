//
//  Rules.swift
//  Hangman
//
//  Created by Franck Kindia on 20/07/2024.
//

import UIKit

class Rules: UIViewController {
    
    var ruleView: UIScrollView!
    var rules: [UILabel] = []
    private let sp = SharedProperties()
    
    override func loadView() {
        super.loadView()
                
        view.backgroundColor = sp.backgroundColor
        
        ruleView = UIScrollView()
        ruleView.isScrollEnabled = true
        ruleView.translatesAutoresizingMaskIntoConstraints = false
        ruleView.backgroundColor = .blue
        view.addSubview(ruleView)
                
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        ruleView.addSubview(contentView)
        
        let path = Bundle.main.url(forResource: "rules", withExtension: "txt")!
        let file = try? String(contentsOf: path)
        let separatedFile = file?.components(separatedBy: "\n")
            if let rulesLines = separatedFile {
                for line in rulesLines {
                    let l = UILabel()
                    if line.hasPrefix("##") {
                        l.font = UIFont(name: sp.font, size: 30)
                    } else if line.hasPrefix("#") {
                        l.font = UIFont(name: sp.font, size: 35)
                    } else {
                        l.font = UIFont(name: "Avenir Next", size: 20)
                    }
                    l.text = line.replacingOccurrences(of: "#", with: "")
                    l.textColor = sp.primaryColor
                    l.translatesAutoresizingMaskIntoConstraints = false
                    l.numberOfLines = 0
                    rules.append(l)
                }
            }
            for (index, rule) in rules.enumerated() {
                contentView.addSubview(rule)
                if index == 0 {
                    rule.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
                } else {
                    rule.topAnchor.constraint(equalTo: rules[index - 1].bottomAnchor, constant: 10).isActive = true
                }
                rule.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
                rule.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            }
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: ruleView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: ruleView.trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: ruleView.widthAnchor),
                contentView.heightAnchor.constraint(equalTo: ruleView.heightAnchor)
            ])
                
            NSLayoutConstraint.activate([
                ruleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                ruleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                ruleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                ruleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
