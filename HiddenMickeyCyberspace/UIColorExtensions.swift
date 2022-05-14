//
//  UIColorExtensions.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 1/28/22.
//

import Foundation
import UIKit
import MapKit

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    var hexString: String? {
        let rgb:Int = (Int)(rgba.red*255)<<16 | (Int)(rgba.green*255)<<8 | (Int)(rgba.blue*255)<<0
        let hex = NSString(format:"#%06x", rgb) as String
        if hex.count > 7 {
            print("wow \(hex)")
            print(coreImageColor.red)
            print(coreImageColor.green)
            print(coreImageColor.blue)
        }
        return hex
    }
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return (red: red, green: green, blue: blue, alpha: alpha)
        }

        var redComponent: CGFloat {
            var red: CGFloat = 0.0
            getRed(&red, green: nil, blue: nil, alpha: nil)

            return red
        }

        var greenComponent: CGFloat {
            var green: CGFloat = 0.0
            getRed(nil, green: &green, blue: nil, alpha: nil)

            return green
        }

        var blueComponent: CGFloat {
            var blue: CGFloat = 0.0
            getRed(nil, green: nil, blue: &blue, alpha: nil)

            return blue
        }

        var alphaComponent: CGFloat {
            var alpha: CGFloat = 0.0
            getRed(nil, green: nil, blue: nil, alpha: &alpha)

            return alpha
        }
}

class PinAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var _title: String = String("")
    private var _subtitle: String = String("")

    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }

    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }

     var title: String? {
        get {
            return _title
        }
        set (value) {
            self._title = value!
        }
    }

    var subtitle: String? {
        get {
            return _subtitle
        }
        set (value) {
            self._subtitle = value!
        }
    }
}
