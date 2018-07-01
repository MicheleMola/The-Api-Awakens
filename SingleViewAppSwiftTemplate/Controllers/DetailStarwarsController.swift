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
  
  @IBOutlet weak var smallestLabel: UILabel!
  @IBOutlet weak var largestLabel: UILabel!
  
  let client = StarwarsAPIClient()
  
  var charactersDataSource = GenericDataSource<Character>(collection: [])
  var characters: [Character] = [] {
    didSet {
      self.charactersDataSource.update(with: characters)
      self.pickerView.reloadAllComponents()
      let sortedCharacters = sort(characters, by: \.height)
      if let min = sortedCharacters.first, let max = sortedCharacters.last {
        smallestLabel.text = min.name
        largestLabel.text = max.name
      }
    }
  }
  
  var vehiclesDataSource = GenericDataSource<Vehicle>(collection: [])
  var vehicles: [Vehicle] = [] {
    didSet {
      self.vehiclesDataSource.update(with: vehicles)
      self.pickerView.reloadAllComponents()
      let sortedVehicles = sort(vehicles, by: \.length)
      if let min = sortedVehicles.first, let max = sortedVehicles.last {
        smallestLabel.text = min.name
        largestLabel.text = max.name
      }
    }
  }
  
  var starshipsDataSource = GenericDataSource<Starship>(collection: [])
  var starships: [Starship] = [] {
    didSet {
      self.starshipsDataSource.update(with: starships)
      self.pickerView.reloadAllComponents()
      let sortedStarships = sort(starships, by: \.length)
      if let min = sortedStarships.first, let max = sortedStarships.last {
        smallestLabel.text = min.name
        largestLabel.text = max.name
      }
    }
  }
  
  var resourceType: ResourceType?
  
  let spinner = Spinner()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Picker View Delegate
    pickerView.delegate = self
    
    //Sets spinner
    self.view.addSubview(spinner)
    
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
  
  // Custom Snippet Pasan Slack
  func sort<T, U: Comparable>(_ values: [T], by keyPath: KeyPath<T, U>) -> [T] {
    return values.sorted(by: {
      if let firstString = $0[keyPath: keyPath] as? String, let firstDouble = Double(firstString), let secondString = $1[keyPath: keyPath] as? String, let secondDouble = Double(secondString) {
        return firstDouble < secondDouble
      }
      return false
    })
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
    spinner.start()
    client.getCharacters(byPage: page) { [unowned self] response in
      self.spinner.stop()
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
    spinner.start()
    client.getStarships(byPage: page) { [unowned self] response in
      self.spinner.stop()
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
    spinner.start()
    client.getVehicles(byPage: page) { [unowned self] response in
      self.spinner.stop()
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
    spinner.start()
    client.getCharacter(withId: id) { [unowned self] response in
      switch response {
      case .success(let character):
        guard let character = character else { return }
        self.getOtherInfo(byCharacter: character)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getOtherInfo(byCharacter character: Character) {    
    var planetName = String()
    var vehiclesName = String()
    var starshipsName = String()
    
    let group = DispatchGroup()
    
    group.enter()
    client.getPlanet(withId: character.idWorldByURL) { response in
      group.leave()
      switch response {
      case .success(let planet):
        guard let planet = planet else { return }
        planetName = planet.name
      case .failure(let error):
        print(error)
      }
    }
    
    let collectionIdVehicles = character.idVehiclesByURL
    if !collectionIdVehicles.isEmpty {
      group.enter()
      client.getVehicles(byIds: collectionIdVehicles) { response in
        group.leave()
        switch response {
        case .success(let names):
          guard let names = names else { return }
          vehiclesName =  names.joined(separator: " - ")
        case .failure(let error):
          print(error)
        }
      }
    }
    
    let collectionIdStarships = character.idStarshipsByURL
    if !collectionIdStarships.isEmpty {
      group.enter()
      client.getStarshipsName(byIds: collectionIdStarships) { response in
        group.leave()
        switch response {
        case .success(let names):
          guard let names = names else { return }
          starshipsName =  names.joined(separator: " - ")
        case .failure(let error):
          print(error)
        }
      }
    }
    
    group.notify(queue: .main) {
      let characterViewModel = CharacterViewModel(character: character, planetName: planetName, vehiclesName: vehiclesName, starshipsName: starshipsName)
      self.populateQuickBar(byResource: characterViewModel)
      self.spinner.stop()
    }

  }
  
  func getStarship(byId id: String) {
    spinner.start()
    client.getStarship(withId: id) { response in
      self.spinner.stop()
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
    spinner.start()
    client.getVehicle(withId: id) { response in
      self.spinner.stop()
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
    case let resource as CharacterViewModel:
      nameLabel.text = resource.name
      valueOne.text = resource.birthYear
      valueTwo.text = resource.homeWorld
      valueThree.text = resource.height
      valueFour.text = resource.eyeColor
      valueFive.text = resource.hairColor
      vehiclesValue.text = resource.vehicles
      starshipsValue.text = resource.starships
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

