#RPI Tours iOS

RPI Tours makes taking tours of RPI's campus as simple as downloading an app.

*This application is still under development and is currently in a stable beta state.*

Want to read a more in depth discussion about the why and how behind RPI Tours? Check out [our wiki]()!
	
#Building RPI Tours
1. [Requirements](#Requirements)
2. [Building](#Building)


###Requirements
In order to build and run RPI Tours for iOS, you will need the following

* [Latest version of XCode 8](https://developer.apple.com/xcode/)
* [Cocoapods](https://cocoapods.org)
* [Mapbox developer account](https://www.mapbox.com)
* [User provided file for credentials](#Credentials)

###Credentials
Since we are using Mapbox as our mapping service, you must have a set of API keys from Mapbox. Mapbox provides you with these upon account creation. They need to live in a file somewhere in the project structure called `mapBoxAPIKeys.swift`.

This file needs to have the contents like this.

    import Foundation
    let mapBoxAPIKey:String = INSERT_YOUR_API_KEY_HERE";
The project expects the API key to be assocated with the string value `mapBoxAPIKey`.

###Building
Building RPI Tours is a pretty simple process. Assuming you have Cocoapods installed (either the [command line version](#Command-Line-Installation) or the [GUI version](#GUI)), you need to install the pods.

#####Command Line Installation
1. Navigate to `../RPI_Tours_iOS/RPI Tours` 
2. Run `pod install` to install the dependencies

#####GUI
*TODO*

*Notice: You need to open the project by launching `RPI Tours.xcworkspace`, not `RPI Tours.xcodeproj`. This ensures that the dependiences are included in the worksapce and XCode can see them*

After installing the necessary dependiences via Cocoapods, all you should have to do is run the project. By default it will probably try to deploy to an iOS Simulator.


##Acknowledgements

The RPI Tours suite of applications is a collaboration between the [Web Technologies Group](http://www.rpiwtg.com/), the [Rensselaer Center for Open Source](http://rcos.io/), and the [Rensselaer Department of Admissions](http://admissions.rpi.edu/).

##Contact Information

* Team lead: [John Behnke ’17](behnkj@rpi.edu)

