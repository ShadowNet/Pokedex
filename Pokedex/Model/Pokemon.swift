//
//  Pokemon.swift
//  Pokedex
//
//  Created by Redghy on 5/7/22.
//

import Foundation
import Alamofire

// This is the class that will hold all the detail for each pokemon
class Pokemon {
    
    // Create the variables for the class, these are private variables.
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonUrl: String!
    
    // Create the getters for the variables.
    
    var description: String {
        if _description == nil {
            
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    // Initialize the variables so can pass the data
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        Alamofire.request(.GET, _pokemonUrl).responseJSON{ (response) -> Void in
            
            print(response.result) //SUCCESS
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                }
                
                print(self._defense)
                print(self._height)
                print(self._weight)
                print(self._attack)
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        
                        var x = 1; x < types.count; x++ {
                            
                            if let name = types[x]["name"] {
                                
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    } else {
                        
                        self._type = ""
                    }
                    
                    print(self._type)
                    
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0{
                        
                        if let url = descArr[0]["resource_uri"] {
                            
                            // here is where alamo goes
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            
                            Alamofire.request(.GET, nsurl).responseJSON{ (response) -> Void in
                                
                                if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                 
                                    if let description = descDict["description"] as? String {
                                        
                                        let newDescription = description.stringByReplacingOccurrencesOfString("POKMON", withString: "Pokemon")
                                        
                                        self._description = newDescription
                                        print(self._description)
                                    }
                                }
                                
                                completed()
                            }
                            
                            // here is where ends
                        }
                        
                    } else {
                        
                        self._description = ""
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                        
                        if let to = evolutions[0]["to"] as? String {
                            
                            //mega is NOT found. not currently supporting Mega data.
                            if to.rangeOfString("mega") == nil {
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    
                                    self._nextEvolutionId = num
                                    self._nextEvolutionTxt = to
                                    
                                    if let lvlExist = evolutions[0]["level"] {
                                        
                                        if let lvl = lvlExist as? Int {
                                            
                                            self._nextEvolutionLevel = "\(lvl)"
                                            
                                        }
                                        
                                        
                                    } else {
                                        
                                        self._nextEvolutionLevel = ""
                                        
                                    }
                                    
                                    print(self._nextEvolutionTxt)
                                    print(self._nextEvolutionLevel)
                                    print(self._nextEvolutionId)
                                }
                            }
                        }
                    }
                }
                
            }
            
    
        }
        
        
        
        
        
        
    }
    
    
}
