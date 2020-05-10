![LabeSwitch](https://github.com/Tobaloidee/LabelSwitch/blob/master/logo/logotype-a-05.png)

[![Build Status](https://travis-ci.org/Cookiezby/LabelSwitch.svg?branch=master)](https://travis-ci.org/Cookiezby/LabelSwitch)
[![Version](https://img.shields.io/cocoapods/v/LabelSwitch.svg?style=flat)](http://cocoapods.org/pods/LabelSwitch)
[![License](https://img.shields.io/cocoapods/l/LabelSwitch.svg?style=flat)](http://cocoapods.org/pods/LabelSwitch)
[![Platform](https://img.shields.io/cocoapods/p/LabelSwitch.svg?style=flat)](http://cocoapods.org/pods/LabelSwitch)

<img src= "sample2.png" width = "240" height = "309" />

## Installation

LabelSwitch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LabelSwitch'
```

## Usage

**You can create the view through code or InterfaceBuilder**

### Use with Interface Builder
Set the position constarint for the switch, and set the width and height constraint to larger than zero.

### Use with code
```swift
let ls = LabelSwitchConfig(text: "Text1",
                      textColor: .white,
                           font: UIFont.boldSystemFont(ofSize: 15),
                backgroundColor: .red)
        
let rs = LabelSwitchConfig(text: "Text2",
                      textColor: .white,
                           font: UIFont.boldSystemFont(ofSize: 20),
                backgroundColor: .green)

// Set the default state of the switch,
let labelSwitch = LabelSwitch(center: .zero, leftConfig: ls, rightConfig: rs)

// Set the appearance of the circle button
labelSwitch.circleShadow = false
labelSwitch.circleColor = .red

// Make switch be triggered by tapping on any position in the switch
labelSwitch.fullSizeTapEnabled = true

// Set the delegate to inform when the switch was triggered
labelSwitch.delegate = self

extension ViewController: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        switch sender.curState {
            case .L: print("left state")
            case .R: print("right state")
        }
    }
}

```
you can also make the switch background to be image or gradient color
```
// gradient color
init(text: String, textColor: UIColor, font: UIFont, gradientColors: [CGColor], startPoint: CGPoint, endPoint: CGPoint)

// image
init(text: String, textColor: UIColor, font: UIFont, image: UIImage?)
```

## Author

cookiezby@gmail.com

## License

LabelSwitch is available under the MIT license. See the LICENSE file for more info.

logo by [@Tobaloidee](https://github.com/Tobaloidee)
