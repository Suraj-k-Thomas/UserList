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
        await client.enqueue(response: .failure(URLError(.notConnectedToInternet)))
        
        do {
          _ =  try await sut.load()
            
        }
        catch  let error as UsersList.Error {
            
            XCTAssertEqual(error ,.connectivity)
        }
        catch{
            XCTFail("error")
        }
    }
    
    
    func  test_ThrowsErrorOnNon200HTTPURLResponse () async {
        let url = URL(string: "https://Aurl.com")!
        let (sut , client ) = makesut(url: url)
        let badresponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields:nil)!
        await client.enqueue(response: .success(Data(),badresponse))
        do {
          _ =  try await sut.load()
            XCTFail("passed")
            
        }
        catch  let error as UsersList.Error {
            
            XCTAssertEqual(error ,.invalidResponse)
        }
        catch{
            XCTFail("error")
        }
        
    }
    
    func  test_EmptyResponseon200HttpUrlResponse () async {
        
        let url = URL(string: "https://Aurl.com")!
        let (sut , client ) = makesut(url: url)
        let validjson = try! JSONSerialization.data(withJSONObject: [])
        let validresponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)!
       await client.enqueue(response: .success(validjson, validresponse))
        let items = try? await sut.load()
        XCTAssertEqual(items, [])
        
    }
    
    func test_ValidDataon200HttpStatusCode () async {
        
        
        let url = URL(string: "https://Aurl.com")!
        let (sut , client) = makesut(url: url)
        
        let item = USerProfile(id: 1 , name: "someName", company: "someCompany", username: "someUSername", email: "https://someemail.com", address: "someaddress", zip: "12345", state: "somestate", country: "somecountry", phone:"1234587656" , photo: "https://somephoto.com")
        
        let json = [[
            "id": item.id,
                "name": item.name,
                "company": item.company,
                "username": item.username,
                "email": item.email,
                "address":item.address,
                "zip": item.zip,
                "state": item.state,
                "country": item.country,
                "phone": item.phone,
                "photo": item.photo
            ]]
        
        
        let data = try! JSONSerialization.data(withJSONObject: json)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        await client.enqueue(response: .success(data, response))
        
        let items = try? await sut.load()
        
        XCTAssertEqual([item], items)
    }
    
    
    
    
    //Helpers
    func makesut (url :URL = URL(string: "https://someurl.com")!) -> (UsersList , ClientSpy)
    {
        
        let client = ClientSpy ()
        let sut =  UsersList(url: url, client: client)
        
        return (sut ,client)
    }
}


// client spy for testing 
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


