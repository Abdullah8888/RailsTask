//
//  RequestSerializer.swift
//  RailsTask
//
//  Created by Jimoh Babatunde  on 19/07/2020.
//  Copyright © 2020 Tunde. All rights reserved.
//

import Foundation
import GraphQLicious
import SwiftyJSON

public class KGRequestSerializer: NSObject {
    
    //MARK: Login
    public func login() -> String {
        let query = Query(request: Request(
            name: "viewer",
            fields: [
                "login",
            ]
            )
        )
        return query.create()
    }
    
    public func getRepo(owner: String, name: String) -> String {
        let query = Query(request: Request(
            name: "repository",
            arguments: [
                Argument(key: "owner", value: owner),
                Argument(key: "name", value: name)
            ],
            fields: [
                "url",
            ]
            )
        )
        return query.create()
    }
    
    public func getCommits(owner: String, name: String) -> String {
        
        let author = Request(
            name: "author",
            fields: [
                "name"
            ]
        )
        let secondCommit = Fragment(
            withAlias: "secondCommit",
            name: "Commit",
            fields: [
                "committedDate",
                "commitUrl",
                "message",
                author
            ]
        )
        let nodes = Request(
            name: "node",
            fields: [
                secondCommit
            ]
        )
        let edges = Request(
            name: "edges",
            fields: [
                nodes
            ]
        )
        let history =  Request(
            name: "history",
            arguments: [
                Argument(key: "first", value: 30)
            
            ],
            fields: [
                edges
            ]
            
        
        )
        let firstCommit = Fragment(
            withAlias: "firstCommit",
            name: "Commit",
            fields: [
                history
                
            ]
        )
        let target = Request(
            name: "target",
            fields: [
                firstCommit
            ]
        )
        
        let defaultBranch = Request(
            name: "defaultBranchRef",
            fields: [
                target
            ]
        )
        
        let query = Query(request: Request(
            name: "repository",
            arguments: [
                Argument(key: "owner", value: owner),
                Argument(key: "name", value: name)
            ],
            fields: [
                defaultBranch
            ]
            ),
            fragments:[
                firstCommit,
                secondCommit
            ]
        )
        return query.create()
    }
}
