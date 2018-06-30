//
//  DetailStarwarsController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 22/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

class DetailStarwarsResourcesController: UITableViewController {
  
  @IBOutlet weak var labelOne: UILabel!
  @IBOutlet weak var labelTwo: UILabel!
  @IBOutlet weak var labelThree: UILabel!
  @IBOutlet weak var labelFour: UILabel!
  @IBOutlet weak var labelFive: UILabel!
  
  @IBOutlet weak var valueOne: UILabel!
  @IBOutlet weak var valueTwo: UILabel!
  @IBOutlet weak var valueThree: UILabel!
  @IBOutlet weak var valueFour: UILabel!
  @IBOutlet weak var valueFive: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var costSegmentedControl: SegmentedControl!
  @IBOutlet weak var lengthSegmentedControl: SegmentedControl!
  
  @IBOutlet weak var vehiclesLabel: UILabel!
  @IBOutlet weak var vehiclesValue: UILabel!
  
  @IBOutlet weak var starshipsLabel: UILabel!
  @IBOutlet weak var starshipsValue: UILabel!
  
  @IBOutlet weak var separatorView: UIView!
  
  @IBOutlet weak var pickerView: UIPickerView!
  
  let client = StarwarsAPIClient()
  
  var charactersDataSource = GenericDataSource<Character>(collection: [])
  var characters: [Character] = [] {
    didSet {
      self.charactersDataSource.update(with: characters)
      self.pickerView.reloadAllComponents()
    }
  }
  
  var vehiclesDataSource = GenericDataSource<Vehicle>(collection: [])
  var vehicles: [Vehicle] = [] {
    didSet {
      self.vehiclesDataSource.update(with: vehicles)
      self.pickerView.reloadAllComponents()
    }
  }
  
  var starshipsDataSource = GenericDataSource<Starship>(collection: [])
  var starships: [Starship] = [] {
    didSet {
      self.starshipsDataSource.update(with: starships)
      self.pickerView.reloadAllComponents()
    }
  }
  
  var resourceType: ResourceType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.delegate = self
    
    if let resourceType = resourceType {
      self.navigationItem.title = resourceType.rawValue
      configureUI(withResourceType: resourceType)
      populatePicker(withResourceType: resourceType)
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func configureUI(withResourceType resourceType: ResourceType) {
    switch resourceType {
    case .characters:
      labelOne.text = "Born"
      labelTwo.text = "Home"
      labelThree.text = "Height"
      labelFour.text = "Eyes"
      labelFive.text = "Hair"
      costSegmentedControl.isHidden = true
    case .starships, .vehicles:
      labelOne.text = "Make"
      labelTwo.text = "Cost"
      labelThree.text = "Lenght"
      labelFour.text = "Class"
      labelFive.text = "Crew"
      vehiclesLabel.isHidden = true
      vehiclesValue.isHidden = true
      starshipsLabel.isHidden = true
      starshipsValue.isHidden = true
      separatorView.isHidden = true
    }
  }
  
  func populatePicker(withResourceType resourceType: ResourceType) {
    switch resourceType {
    case .characters:
      pickerView.dataSource = charactersDataSource
      getCharacters(byPage: 1)
    case .starships:
      pickerView.dataSource = starshipsDataSource
      getStarhips(byPage: 1)
    case .vehicles:
      pickerView.dataSource = vehiclesDataSource
      getVehicles(byPage: 1)
    }
  }
  
  func getCharacters(byPage page: Int) {
    client.getCharacters(byPage: page) { [unowned self] response in
      switch response {
      case .success(let characters):
        guard let characters = characters?.results else { return }
        self.characters = characters
        guard let firstCharacter = self.characters.first else { return }
        self.getCharacter(byId: firstCharacter.idByURL)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getStarhips(byPage page: Int) {
    client.getStarships(byPage: page) { [unowned self] response in
      switch response {
      case .success(let starships):
        guard let starships = starships?.results else { return }
        self.starships = starships
        guard let firstStarship = self.starships.first else { return }
        self.getStarship(byId: firstStarship.idByURL)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getVehicles(byPage page: Int) {
    client.getVehicles(byPage: page) { [unowned self] response in
      switch response {
      case .success(let vehicles):
        guard let vehicles = vehicles?.results else { return }
        self.vehicles = vehicles
        guard let firstVehicle = self.vehicles.first else { return }
        self.getVehicle(byId: firstVehicle.idByURL)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getCharacter(byId id: String) {
    client.getCharacter(withId: id) { [unowned self] response in
      switch response {
      case .success(let character):
        guard let character = character else { return }
        self.getPlanet(byId: character.idWorldByURL)
        self.getVehicles(byCharacter: character)
        self.getStarships(byCharacter: character)
        self.populateQuickBar(byResource: character)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getVehicles(byCharacter character: Character) {
    let collectionId = character.idVehiclesByURL
    var vehiclesValue = [String]()
    if collectionId.count == 0 {
      self.vehiclesValue.text = ""
      return
    }
    
    
    
    for id in collectionId {
      client.getVehicle(withId: id) { response in
        switch response {
        case .success(let vehicle):
          guard let vehicle = vehicle else { return }
          vehiclesValue.append(vehicle.name)
          if (vehiclesValue.count == collectionId.count) { self.vehiclesValue.text? =  vehiclesValue.joined(separator: " - ")}
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  func getStarships(byCharacter character: Character) {
    let collectionId = character.idStarshipsByURL
    var starshipsValue = [String]()
    if collectionId.count == 0 {
      self.starshipsValue.text = ""
      return
    }
    
    for id in collectionId {
      client.getStarship(withId: id) { response in
        switch response {
        case .success(let starship):
          guard let starship = starship else { return }
          starshipsValue.append(starship.name)
          if (starshipsValue.count == collectionId.count) { self.starshipsValue.text? =  starshipsValue.joined(separator: " - ")}
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  
  func getPlanet(byId id: String) {
    client.getPlanet(withId: id) { [unowned self] response in
      switch response {
      case .success(let planet):
        guard let planet = planet else { return }
        self.valueTwo.text = planet.name
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getStarship(byId id: String) {
    client.getStarship(withId: id) { response in
      switch response {
      case .success(let starship):
        guard let starship = starship else { return }
        self.populateQuickBar(byResource: starship)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getVehicle(byId id: String) {
    client.getVehicle(withId: id) { response in
      switch response {
      case .success(let vehicle):
        guard let vehicle = vehicle else { return }
        self.populateQuickBar(byResource: vehicle)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func populateQuickBar(byResource resource: Any) {
    switch resource {
    case let resource as Character:
      nameLabel.text = resource.name
      valueOne.text = resource.birthYear
      //valueTwo.text = resource.homeWorld
      valueThree.text = resource.height
      valueFour.text = resource.eyeColor
      valueFive.text = resource.hairColor
    case let resource as TransportCraft:
      nameLabel.text = resource.name
      valueOne.text = resource.manufacturer
      valueTwo.text = resource.costInCredits
      valueThree.text = resource.length
      valueFour.text = resource.´class´
      valueFive.text = resource.crew
    default:
      break
    }
  }
  
}

extension DetailStarwarsResourcesController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if let resourceType = resourceType {
      switch resourceType {
      case .characters: return self.characters[row].name
      case .starships: return self.starships[row].name
      case .vehicles: return self.vehicles[row].name
      }
    }
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if let resourceType = resourceType {
      switch resourceType {
      case .characters:
        let id = self.characters[row].idByURL
        getCharacter(byId: id)
      case .starships:
        let id = self.starships[row].idByURL
        getStarship(byId: id)
      case .vehicles:
        let id = self.vehicles[row].idByURL
        getVehicle(byId: id)
      }
    }
  }
}

