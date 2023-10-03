
## Getting Started

- ### **Tools**
    - Flutter: Version 3.13.2 (channel stable)
    - Dart: Version 3.1.0
    - DevTools: Version 2.25.0

- ### **General**
    - When starting the project with an existing backend that uses the JSON transport protocol, install and use the "Dart Data Class" or "JsonToDart" Plugin for IntelliJ. **This way, you don't need to write model classes by hand.**
    - App Icon: run in terminal 'dart run flutter_launcher_icons:main'
    - Splash Screen: run in terminal 'dart run flutter_native_splash:create'
    - Hive Adapters: run in terminal 'dart run build_runner build'
      on first build and every time you make changes on the model classes
    - Environment Variables: For security reasons, they are not checked in into Version Control.
      Get the ".env" file from developer and add it to the root folder
    - To check for any unused dependencies, run "dart run dependency_validator"

- ### **Android**
    - Add to 'local.properties:
      flutter.minSdkVersion=21
      flutter.compileSdkVersion=33
      flutter.targetSdkVersion=33
    - Add file 'key.properties' file to build release version
    - Add file 'google-services.json' from firebase
      console (https://console.firebase.google.com/u/2/project/oeko-shop/settings/general/android:io.winkler_software.oeko_shop.bio_courier) to enable
      notifications

- **IOS**

## Version Designation

- In the "pubspec.yaml" file, when doing any changes to the code base, update the version code according to the following convention:
  **X.Y.Z+V**
    - X: Release of a new app version
    - Y: Major change in functionality, added feature or fix of app breaking bug
    - Z: Minor changes (e.g. design, performance, refactoring) and bug fixes; update at least after push to dev
    - V: Version code that indicates the app store release number


