//
//  NetworkManager.swift
//  ProductHunt-API-Network-Layer
//
//  Created by timofey makhlay on 1/29/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import Foundation

class NetworkManager {
    let urlSession = URLSession.shared
    var baseURL = "https://api.producthunt.com/v1/"
    var token = "03d3113b03aed2378d7bfb46d6706f5f02588936fbcac830dfed93946732aa75"
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
        let query = "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        let fullURL = URL(string: baseURL + query)!
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "Host": "api.producthunt.com"
        ]
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return
            }
            let posts = result.posts
            
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        task.resume()
    }
}
