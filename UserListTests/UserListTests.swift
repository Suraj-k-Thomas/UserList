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

    
    func test_RequestDataFromLoad () {
        
        
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
    
    var requestedUrls : [URL] = []
    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        throw URLError(.badURL)

    }
    
}


class UsersList {
    let url : URL
    let client : HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
        
}
