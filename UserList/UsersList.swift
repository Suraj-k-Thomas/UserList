//
//  UsersList.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import Foundation

protocol HTTPClient {
    
    func get(from url : URL) async throws -> (Data , HTTPURLResponse)
}


class UsersList {
    
    public enum Error : Swift.Error {
        
        case connectivity
        case invalidResponse
    }
    
    
    let url : URL
    let client : HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load () async throws -> [UsersList] {
        
        do {
            let (_, response) = try await client.get(from: url)
            
            guard response.statusCode == 200 else {
                throw Error.invalidResponse
            }
        }
        catch let error as UsersList.Error {
            
            throw error
        }
        catch {
            
            throw Error.connectivity
        }
        return  []
    }}



    
