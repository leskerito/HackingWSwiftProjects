//
//  ViewController.swift
//  Project7
//
//  Created by Franck Kindia on 15/07/2024.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoButton = UIButton(type: .infoLight)
        
        infoButton.addTarget(self, action: #selector(showCredits), for: .touchUpInside)
        
        let creditsButton  = UIBarButtonItem(customView: infoButton)
        
        navigationItem.rightBarButtonItem = creditsButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(filterPage))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    
    @objc func fetchJSON(){
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let data = try? Data(contentsOf: URL(string: urlString)!){
            parse(json: data)
            filteredPetitions = petitions
            return
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Define each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Create a singular petition that relates to the respective cell
        let petition = filteredPetitions[indexPath.row]
        
        //Use the content configuration to alter the cell's attributes
        var content = cell.defaultContentConfiguration()
        
        //Assign the cell's title and subtitle the parsed info from the petition
        content.text = petition.title
        content.secondaryText = petition.body
        
        //Modify the cell's content
        cell.contentConfiguration = content
        
        //Return the cell after all modification
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
   @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Credits", message: "This app takes its data from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func filterPage(){
        let ac = UIAlertController(title: "Filter by Keyword", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            var filtered = [Petition]()
            if let response = ac.textFields?[0].text {
                for petition in self!.petitions {
                    if petition.title.contains(response) || petition.body.contains(response){
                        filtered.append(petition)
                    }
                }
                self!.filteredPetitions = filtered
                self!.tableView.reloadData()
            }
        })
        ac.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.filteredPetitions = self.petitions
            self.tableView.reloadData()
        })
        present(ac, animated: true)
    }

}

