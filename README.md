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
  - `models`
