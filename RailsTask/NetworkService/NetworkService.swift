//
//  NetworkService.swift
//  RailsTask
//
//  Created by Jimoh Babatunde  on 19/07/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import Foundation
import SwiftyJSON

public class NetworkService: NSObject {
    //init our requestSerializer app config
    private var requestSerializer = KGRequestSerializer.init()
    private var config = AppConfiguration.init()
    
    //A singleton object
    public static let sharedManager = NetworkService()
    
    //MARK: Get Recent Commits
    public func getCommits(owner: String, name: String, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        
        let request = createRequest(payload: self.requestSerializer.getCommits(owner: owner, name: name))
        post(request: request) { (success, object, response) in
            completion(success, object, response)
        }
    }
    
    //MARK: Get Repo
    public func getRepo(owner: String, name: String, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        
        let request = createRequest(payload: self.requestSerializer.getRepo(owner: owner, name: name))
        post(request: request) { (success, object, response) in
            completion(success, object, response)
        }
    }
    
    //MARK: login with PAT
    public func login(completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        
        let request = createRequest(payload: self.requestSerializer.login())
        post(request: request) { (success, object, response) in
            completion(success, object, response)
        }
    }
    
    private func createRequest(payload: String) -> NSMutableURLRequest {
        let urlString = config.host()
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let alteredPayload = payload.replacingOccurrences(of: "query  ", with: "", options: .literal, range: nil)
        let jsonData = try? JSONSerialization.data(withJSONObject: ["query":alteredPayload])
        let df = String(data: jsonData!, encoding: String.Encoding.utf8)  // This is use for debugging
        print("the json is \(df)")
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("bearer 7c19dcb82497675ba9881da1fe1f24aacae8959a", forHTTPHeaderField: "Authorization")
        request.setValue("", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    //MARK: Convenience Methods
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default);
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let obj = try? JSON(data: data)
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, obj, response)
                } else {
                    completion(false, obj, response!)
                }
            }
            }.resume();
    }
    
    private func post(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: SwiftyJSON.JSON?, _ response: URLResponse) -> ()) {
          dataTask(request: request, method: "POST", completion: completion)
      }
}
