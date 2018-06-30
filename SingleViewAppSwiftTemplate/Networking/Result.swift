//
//  Result.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 21/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

enum Response<T, U> where U: Error  {
  case success(T)
  case failure(U)
}
