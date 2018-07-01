//
//  CharacterViewModel.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Michele Mola on 30/06/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import Foundation

struct CharacterViewModel {
  let name: String
  let birthYear: String
  let homeWorld: String
  let height: String
  let eyeColor: String
  let hairColor: String
  let starships: String
  let vehicles: String
  
}

extension CharacterViewModel {
  init(character: Character, planetName: String, vehiclesName: String, starshipsName: String) {
    self.name = character.name
    self.birthYear = character.birthYear
    self.homeWorld = planetName
    self.height = character.height
    self.eyeColor = character.eyeColor
    self.hairColor = character.hairColor
    self.starships = starshipsName
    self.vehicles = vehiclesName
  }
}
