//
//  UserListApp.swift
//  UserList
//
//  Created by Suraj  Thomas on 18/10/25.
//

import SwiftUI

@main
struct UserListApp: App {
    var body: some Scene {
        WindowGroup {
           // ContentView()
            
            let url = URL(string: "https://fake-json-api.mock.beeceptor.com/users")!
                       let client = URLSessionHTTPClient()
                       let loader = UsersList(url: url, client: client)
                       let vm = UsersViewModel(loader: loader)

                       UsersListView(viewModel: vm)
        }
    }
}
