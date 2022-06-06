# lab_manager

## Documentes For The Main Code Logic
In order to create the documents locally run in the terminal the following commands:
- run `dart pub global activate dartdoc`
- run `dart pub global run dartdoc .`
=> These will generate all the documentations at `./lib/doc` folder.
  
In order to view the documentations:
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
  - `authenticate`: Contains all the pages to signIn/signUp to our application.
    - **_wrapper_** - Wiget which redirect the user to sign-in page if not signned in, otherwise to home page.
    - **_sign_in_** - Sign-In page to our application.
    - **_register_** - If you don't have an accout you can register a new account via this page.
  - `screens`: Contains all the visible screen to the user.
    - **_home_** - Home page.
    - **_my_activity_logs_** - display all the activities done by the current user.
    - **_pending_permission_requests_** - Present all the pending request from other users to access specific station owned by the current user.
    - **_permissions_** - Page where the user can request to access another station, it also present the status of accessibiliy for each station.
    - **_permissions_manager_** - Page where the user can control access of another users to his/her stations (grand/deny access).
    - **_profile_settings_** - Profile settings page (the user can edit his username/phone-number/cid...).
    - **_user_stations_** - Present all the stations owned by the connected user, here he/she can edit/create stations.
  - `services`: Contains services to 3rd party applications like **firestore** and **googleAuthenatication**
    - **_auth_** - Service which handles all the API calls to _FirebaseAuth_ services!
    - **_permissions_db_** - Service which handles all the API calls to _Permissions_ database at firestore!
    - **_stations_db_** - Service which handles all the API calls to _LabStations_ database at firestore!
    - **_usage_history_db_** - Service which handles all the API calls to _UsageHistory_ database at firestore!
    - **_users_db_** - Service which handles all the API calls to _LabUsers_ database at firestore!
  - `shared`: Contains the shared components and widgets accross the applicaiton.
    - **_assets_** - static assests like images.
    - **_results/registration_results_** - class to contorl the authentication results.
    - **_loading_spinner_** - a spinner widget which is present in case we are invoking API call and waiting for its response.
    - **_widgets/_** -
      - **_activity_logs_** -> present all the acitivites by constraints & filter options.
      - **_background_image_** -> widgets which controls the background image in all of the application pages.
      - **_navigation_drawer_** -> drawer in the home page to navigate to other pages.
