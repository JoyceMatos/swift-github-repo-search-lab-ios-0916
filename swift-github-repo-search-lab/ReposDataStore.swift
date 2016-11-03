//
//  ReposDataStore.swift
//  swift-github-repo-search-lab
//
//  Created by Joyce Matos on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    
    class func toggleStarStatus(for repo: GithubRepository, completion: @escaping (Bool) -> ()){
        
        GithubAPIClient.checkIfRepositoryIsStarred(repo.fullName) { isStarred in
            
            if isStarred {
                GithubAPIClient.unstarRepository(named: repo.fullName, completion: {
                    
                })
                completion(false)
            } else {
                GithubAPIClient.starRepository(named: repo.fullName, completion: {
                    
                })
                completion(true)
                
            }
        }
    }
    
     func searchRepositories(name: String, completion: @escaping () -> ()) {
        
     GithubAPIClient.searchForRepo(name: name) { (response) in
        self.repositories.removeAll()
        
        let repos = response["items"] as! [[String: Any]]
     
        for person in repos {
        
        let repoDictionary = GithubRepository(dictionary: person)
            self.repositories.append(repoDictionary)
        }
        
        }
        completion()

    }
    
}
