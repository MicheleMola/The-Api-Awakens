//
//  TransportCraft.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 23/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

protocol TransportCraft {
  var name: String { get }
  var manufacturer: String { get }
  var costInCredits: String { get }
  var length: String { get }
  var ´class´: String { get }
  var crew: String { get }
  var url: URL { get }
}

extension TransportCraft {
  var idByURL: String {
    return url.lastPathComponent
  }
}
