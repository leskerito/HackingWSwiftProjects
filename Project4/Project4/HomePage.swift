//
//  ViewController.swift
//  Project4
//
//  Created by Franck Kindia on 09/07/2024.
//

import UIKit
import WebKit

class HomePage: UITableViewController, WKNavigationDelegate {

    var websites = ["apple", "9gag", "outalpha"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "WebView") as? DetailViewController {
            vc.webView.load(URLRequest(url: URL(string: "https://\(websites[indexPath.row]).com/")!))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

