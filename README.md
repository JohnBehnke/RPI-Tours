#RPI Tours iOS

This application forms the iOS application of the RPI Tours suite of applications. The source code for the server can be found [here](https://github.com/wtg/RPI_Tours_Server).

##Background
Currently, all prospective students take identical tours of RPI’s campus. The tour is given by a student tour guide around both academic campus and freshman hill. In some cases, recruited athletes receive special tours of the East Campus Athletic Village, which are conducted either by a team member or a coach. With a campus as large and as multi-disciplined as Rensselaer, seeing everything that the school has to offer in one, generalized tour is not feasible.

This is where RPI Tours comes in. By using GPS Location and details provided by the Department of Admissions, the RPI Tours application will provide a series of self-guided tours to allow prospective students, parents, and alumni to see different parts of the campus that they, otherwise, would not be able to see in a tour. These tour routes would be dynamic, as RPI Tours would have an administrative web dashboard for admissions officers to add, remove, edit, and toggle the tour routes currently accessible.

##Technical Details
This application will have three main components: an iOS application, a web-based admin dashboard, and a server. The fourth component, an Android application, is planned as a future addition. The core server will be written using Flask, an open-source microframework for Python, and store data using a PostgreSQL database. The iOS application will make use of Swift and interact with the server back end through queries that will provide JSON data. 

##Spring 2016 RCOS Schedule
* Stage I: Application design and scoping (1 week)
* Stage II: Implementation of the iOS application using test JSON data; implementation of the server backend (6 weeks)
* Stage III: Connection of the server to the iOS application; development of the web admin dashboard for CRUD operations of tour routes (3 weeks)
* Stage IV: Testing and deployment (length TBD)

##Acknowledgements

The RPI Tours suite of applications is a collaboration between the [Web Technologies Group](http://www.rpiwtg.com/), the [Rensselaer Center for Open Source](http://rcos.io/), and the [Rensselaer Department of Admissions](http://admissions.rpi.edu/).

##Contact Information

* Team lead: [John Behnke ’17](behnkj@rpi.edu)
* WebTech Chairman: [Justin Etzine ’18](webtech@union.rpi.edu)
