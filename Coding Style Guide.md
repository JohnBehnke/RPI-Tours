# RPI Tours Coding Style Guide
---
[Adapted from Ray Wenderlich's Style Guide](https://github.com/raywenderlich/swift-style-guide)

The notes here are specific to out project

## Naming

* All names should be descriptive (but not incredibly long), Camel case should be used (firstSecond), except for Class names, which are capitalized (FirstSecond). This extends to function parameters and init methods.

**Example:**

```swift
let numWaypoints:Int = 8

class TourDetails {
  let tourName:String
  let tourLength:Double

  init(tourName:String, tourLength:String){
  	...
  }
}

```
## Spacing

Indentation is to be set to 2 spaces (not tabs!)

Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.

**Example:**
```swift
if user.isHappy {
  // Do something
} else {
  // Do something else
}
```



## Commenting

Each function should have a brief comment to describe the function's usage, inputs, and outputs (similar to Java @params)

**Example**
```swift
//Calculate and return the length (in seconds) of a given tour
func getTourLength(inputTour:Tour) -> Int{
	...
}
```

Use MARK statements to group functions/constants/etc by type. Ideally, magic numbers/default functions/IBActions/IBOutlets/etc are towards the top, and helper functions towards the bottom.

**Example**
```swift
class MainViewController:  UIViewController{

	//MARK: Global Variables

	struct colors{...}

	let googleMapsAPIKey = INSERT_API_KEY_HERE

	//MARK: Default Functions

	override func viewDidLoad() {...}

	//MARK: Helper Functions

	func sortTourIDS(inputTours:[Tours]){...}
}
```
