//
//  Double+Rounded.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 03/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

extension Double {
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
