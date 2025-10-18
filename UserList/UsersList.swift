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
    
    func load () async throws -> [USerProfile] {
        
        do {
            let (data, response) = try await client.get(from: url)
            
            guard response.statusCode == 200 else {
                throw Error.invalidResponse
            }
            return try JSONDecoder().decode([USerProfile].self, from: data)
            
        }
        catch let error as UsersList.Error {
            
            throw error
        }
        catch {
            
            throw Error.connectivity
        }
    }}





    
