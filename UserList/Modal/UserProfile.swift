//
//  UserProfile.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import Foundation

 struct USerProfile : Equatable , Codable , Identifiable , Hashable{
    public   let id: Int
    public   let name: String
    public   let company: String
    public   let username: String
    public   let email: String
    public   let address: String
    public   let zip: String
    public   let state: String
    public   let country: String
    public   let phone: String
    public   let photo: String
}

