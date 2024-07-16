import UIKit

var greeting = "Hello, playground"

var level = 1
var solutions = [String]()

func loadLevel(){
    var clueString = ""
    var solutionString = ""
    var letterBits = [String]()
    
    if let levelFileURL = URL(string: "/Users/lskr/Code/Apple/HackingWithSwift/Project8/Project8/level1.txt"){
        print(levelFileURL)
        if let levelContents = try? String(contentsOf: levelFileURL){
            var lines = levelContents.components(separatedBy: "\n")
            lines.shuffle()
            
            for (index, line) in lines.enumerated() {
                let parts = line.components(separatedBy: ":")
                let answer = parts[0]
                let clue = parts[1]
                
                clueString = "\(index + 1). \(clue)\n"
                
                let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                solutionString += "\(solutionWord.count) letters\n"
                solutions.append(solutionWord)

                let bits = answer.components(separatedBy: "|")
                letterBits += bits
            }
        } else {
            print("Failure")
        }
    }
}

loadLevel()
