# UserList


Architecture

1.Data flow 
##swiftui-> mvvm -> Api 


2.##we will unit test  the Api (UserList)

3.uiflow
##UI - UsersListView -> [on tap] -> UserDetailView  displays UserDetails 


4.mmvm - api , i used dependency inversion. 
a protocol abstracion is used rather than concrete type .

5.Async / await used over completion handlers

6. Kept 3 modules for now 

view - viewmodel - api (can be extended to view - viewmodel - usecase - repositary - api) modules using protocols 




