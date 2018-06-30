//
//  GenericDataSource.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 23/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class GenericDataSource<T>: NSObject, UIPickerViewDataSource {
  private var collection: [T]
  
  init(collection: [T]) {
    self.collection = collection
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return collection.count
  }
  
  func update(with collection: [T]) {
    self.collection = collection
  }
}
