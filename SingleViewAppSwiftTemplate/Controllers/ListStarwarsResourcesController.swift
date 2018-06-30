//
//  ListStarwarsResourcesController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 22/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

enum ResourceType: String {
  case characters = "Characters"
  case vehicles = "Vehicles"
  case starships = "Starships"
}

class ListStarwarsResourcesController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "show" {
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        let detailStarwarsResourcesController = segue.destination as! DetailStarwarsResourcesController
        
        var resourceType: ResourceType = .characters
        
        switch selectedIndexPath.row {
        case 1: resourceType = .vehicles
        case 2: resourceType = .starships
        default: break
        }
        
        detailStarwarsResourcesController.resourceType = resourceType
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "show", sender: nil)
  }
  
}
