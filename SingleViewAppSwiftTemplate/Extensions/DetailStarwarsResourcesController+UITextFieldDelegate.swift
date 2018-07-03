//
//  DetailStarwarsResourcesController+UITextFieldDelegate.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 03/07/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

extension DetailStarwarsResourcesController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    costSegmentedControl.isEnabled = updatedText.isEmpty ? false : true
    
    return updatedText.count < 10
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
