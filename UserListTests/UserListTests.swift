//
//  UserListTests.swift
//  UserListTests
//
//  Created by Suraj  Thomas on 18/10/25.
// unit test suite

import Testing
import XCTest
@testable import UserList
import Foundation

class UserListTests :XCTestCase{

    func test_DoesNotRequestData () async {
        
        let (_,client) = makesut()
        let requestedUrls = await client.requestedUrls
        XCTAssertTrue(requestedUrls.isEmpty)
    }

    
    func test_RequestDataFromLoad ()  async {
        
        let url =  URL(string: "https://a-url.com")!
        let (sut , client) = makesut(url: url)
       _ = try? await  sut.load()
        let requestedUrls = await client.requestedUrls
        XCTAssertEqual(requestedUrls, [url])
    }
    
    func  test_ThrowsErrorOnClinetError () async {
        
        let (sut , client) = makesut()
        await client.enqueue(response: .failure(NSError(domain: "error", code: 0, userInfo: nil)))
        
        
        do {
          _ =  try await sut.load()
            
        }
        catch  let error as UsersList.Error {
            
            XCTAssertEqual(error ,UsersList.Error.connectivity)
        }
        catch{
            XCTFail("error")
        }
        
        
    }
    
    
    //Helpers
    func makesut (url :URL = URL(string: "https://someurl.com")!) -> (UsersList , ClientSpy)
    {
        
        let client = ClientSpy ()
        let sut =  UsersList(url: url, client: client)
        
        return (sut ,client)
    }
}


protocol HTTPClient {
    
    func get(from url : URL) async throws -> (Data , HTTPURLResponse)
}


actor ClientSpy : HTTPClient {
    
    enum Response {
        case success (Data , HTTPURLResponse)
        case failure (Error)
        
    }
    
    var queue : [Response] = []
    
    func enqueue(response : Response) {
        
        queue.append(response)
    }
    
    var requestedUrls : [URL] = []
    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedUrls.append(url)
        
        guard !queue.isEmpty else {throw URLError(.badURL)}
        let item = queue.removeFirst()
        switch item {
        case .success(let data, let uRLResponse):
            return (data , uRLResponse)
        case .failure(let error):
            throw error
        }
    }
    
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
          _ =  try await client.get(from: url)}
        catch  {
            throw Error.connectivity
        
        }
        return []
    }
        
}
