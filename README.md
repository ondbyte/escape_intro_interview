## to browse the code
Install dart https://dart.dev/get-dart
make sure dart is installed by running
```
dart
```

get vscode

install dart extension for vs code to browse the code

clone this project and open in vs code

## to run the code
cd into root folder of this project
run 
```
dart ./bin/escape.dart <path-to-cities-json-file> <source-id-of-the-city>
```
to run in normal mode or 

```
dart ./bin/escape.dart <path-to-cities-json-file> <source-id-of-the-city> <optional-true>
```
 to run in bonus mode

### example 
```
dart ./bin/escape.dart ./cities.json BOM
``` 
runs in normal mode

```
dart ./bin/escape.dart ./cities.json BOM true
```
runs in bonus mode