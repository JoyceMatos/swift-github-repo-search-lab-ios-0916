//
//  GithubAPIClient.swift
//  swift-github-repo-search-lab
//
//  Created by Joyce Matos on 11/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        })
        task.resume()
        
        
    }
    
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> ()) {
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(accessToken)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 204:
                    print("You have starred this content")
                    completion(true)
                    break
                case 404:
                    print("You have not starred this content")
                    completion(false)
                    break
                default:
                    print("This is the default case")
                }
            }
        }
        task.resume()
        }
    
    class func starRepository(named: String , completion: @escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(accessToken)"
        
        Alamofire.request(urlString, method: .put).responseJSON { (response) in
            
            if let response = response.response {
                
                if response.statusCode == 204 {
                    print("You have just starred this content")
                }
            }
            completion()
            
        }
        
    }
    
    class func unstarRepository(named: String, completion:@escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(accessToken)"
        Alamofire.request(urlString, method: .delete).responseJSON { (response) in
            
            if let response = response.response {
                
                if response.statusCode == 204 {
                    print("You have just unstarred this content")
                }
            }
            completion()
            
        }
    }
    
    class func searchForRepo(name: String, completion: @escaping ([String: Any]) -> ()) {
        let githubURL = "https://api.github.com/search/repositories?q=\(name)"
        
        Alamofire.request(githubURL).responseJSON { (response) in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
        Alamofire.request(githubURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            guard let data = response.data else { return }
            
            let responseJson = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            completion(responseJson)
            
        }
        
        
    }
}
