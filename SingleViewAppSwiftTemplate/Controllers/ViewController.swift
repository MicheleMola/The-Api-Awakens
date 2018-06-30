//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let client = StarwarsAPIClient()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    client.getCharacters { response in
      switch response {
      case .success(let characters):
        guard let characters = characters?.results else { return }
        print(characters.first!.idByURL)
        
        self.client.getCharacter(withId: characters.first!.idByURL) { response in
          switch response {
          case .success(let character):
            print(character!)
          case .failure(let error):
            print(error)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

