# lab_manager

## Documenting My App
In order to create the documents locally run in the terminal the following commands:
- run `dart pub global activate dartdoc`
- run `dart pub global run dartdoc .`
=> These will generate all the documentations at `./lib/doc` folder.
  
Then run the following commands:
- `dart pub global run dhttpd --path ./doc/api`
=> This command will initiate a web server which will host the documentations.
  
Then navigate to: `http://localhost:8080/`

## Project Hierarchy
- `lib`
  - `models`: Contains models and customized objects used in the application.
    - **_lab_permissions_** - Represents a documnet in `Permissions` collection (if the user is authorized/unauthorized to use specific station).
    - **_lab_station_** - Represents a documnet in `LabStations` collection.
    - **_lab_user_** - Represents a document in `LabUsers` collection.
    - **_lab_usage_history_** - Represents a document in `UsageHistory` collection.
  - `screens`: Contains all the visible screen to the user.
    - 
  - `services`: Contains services to 3rd party applications like **firestore** and **googleAuthenatication**
    - **_auth_** - Service which handles all the API calls to _FirebaseAuth_ services!
    - **_permissions_db_** - Service which handles all the API calls to _Permissions_ database at firestore!
    - **_stations_db_** - Service which handles all the API calls to _LabStations_ database at firestore!
    - **_usage_history_db_** - Service which handles all the API calls to _UsageHistory_ database at firestore!
    - **_users_db_** - Service which handles all the API calls to _LabUsers_ database at firestore!
  - `shared`: Contains the shared components and widgets accross the applicaiton.
    - **__**
