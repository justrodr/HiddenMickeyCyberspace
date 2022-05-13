//
//  ColorConstansts.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 2/12/22.
//

import UIKit


//let brightBlueColor: UIColor = UIColor.init(red: 11/255, green: 112/255, blue: 255/255, alpha: 1)
//let backgroundLightBlueColor: UIColor = UIColor.init(red: 41/255, green: 108/255, blue: 166/255, alpha: 1)
//
let HMCWhite: UIColor = UIColor.init(rgb: 0xF7F7F7)
//let HMCGrey: UIColor = UIColor.init(rgb: 0xF2F2F2)
//let HMCBrightBlue: UIColor = UIColor.init(rgb: 0x04C4D9)
////let HMCBlue: UIColor = UIColor.init(rgb: 0x0487D9)
////let HMCPurple: UIColor = UIColor.init(rgb: 0x024873)
//
//let HMCPurple: UIColor = UIColor.init(rgb: 0x7D7ABF)
//let HMCBlue: UIColor = UIColor.init(rgb: 0x44A1F2)
//let HMCLightBlue: UIColor = UIColor.init(rgb: 0x91D7F2)
//let HMCGreen: UIColor = UIColor.init(rgb: 0x30733A)
//let HMCYellow: UIColor = UIColor.init(rgb: 0xF2B807)

let HMCBlue: UIColor = UIColor.init(rgb: 0x3772FF)
let HMCGreen: UIColor = UIColor.init(rgb: 0x06A77D)
let HMCCream: UIColor = UIColor.init(rgb: 0xF1E9DA)
let HMCNavy: UIColor = UIColor.init(rgb: 0x2E294E)
let HMCOrange: UIColor = UIColor.init(rgb: 0xF06543)

let HMCButtonColor1 = HMCBlue
let HMCButtonColor2 = HMCGreen
let HMCBackgroundColor1 = HMCCream
let HMCBackgroundColor2 = HMCNavy
let HMCCardBackgroundColor1 = HMCNavy
let HMCTextColor1 = HMCNavy
let HMCTextColor2 = HMCWhite
let HMCHighlightColor = HMCOrange


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
