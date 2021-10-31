//
//  CountryDetailsDto.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation

struct CountryDetailsDto {
    
    let name: String
    let alpha2Code: String
    let capital: String
    let region: String
    let population: String
    let coordinate: CoordinateDto
    let currencies: String
    let languages: String
    
}

struct CoordinateDto {
    
    let latitude: Double
    let longitude: Double
    
}

//MARK: - Struct Custom init

extension CountryDetailsDto {
    init(from details: CountryDetailsModel) {
        name = details.name
        alpha2Code = details.alpha2Code
        capital = details.alpha2Code
        region = details.region
        population = "\(details.population) \(details.demonym)"
        
        coordinate = CoordinateDto(latitude: details.latlng[0], longitude: details.latlng[1])
        
        currencies = {
            let string = details.currencies
                .map { $0.code ?? "" }
                .joined(separator: ", ")
            
            return string.isEmpty ? Constant.UNAVAILABLE : string
        }()
        
        languages = {
            let string = details.languages
                .map { $0.name }
                .joined(separator: ", ")
            
            return string.isEmpty ? Constant.UNAVAILABLE : string
        }()
    }
}
