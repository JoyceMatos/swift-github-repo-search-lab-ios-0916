//
//  ReposTableViewController.swift
//  swift-github-repo-search-lab
//
//  Created by Joyce Matos on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    @IBAction func searchButton(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
     
        alert.addTextField { (textfield) in
            textfield.placeholder = "Search Repositories"
       
        }

        
        let search = UIAlertAction(title: "Search", style: .default) { (complete) in
            
            
           self.store.searchRepositories(name: (alert.textFields?[0].text)!, completion: {
          
            OperationQueue.main.addOperation {
                self.tableView.reloadData()

            }
            
           })
            
           
        }
        
        alert.addAction(search)
        
        present(alert, animated: true, completion: nil)
    
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
     
//        store.searchRepositories(name: "mojo") { 
//            OperationQueue.main.addOperation({
//                self.tableView.reloadData()
//        })
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    func someFunction(success: Bool) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        let repository: GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = store.repositories[indexPath.row]
        let repoName = repo.fullName
        
        ReposDataStore.toggleStarStatus(for: repo) { (isStarred) in
            
            switch isStarred {
            case true:
                let alertController = UIAlertController(title: "Starred!", message: "You have just starred \(repoName)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            case false:
                let alertController = UIAlertController(title: "Unstar!", message: "You have unstarred this \(repoName)", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            default: "Default"
                
            }
            
        }
        
    }
}
