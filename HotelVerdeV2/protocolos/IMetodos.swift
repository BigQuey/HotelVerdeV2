//
//  IMetodos.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit

import Foundation

protocol IMetodos {

    associatedtype Bean
    associatedtype Entity
    
    func save(bean: Bean) -> Int
    
    func update(bean: Entity) -> Int
    func delete(bean: Entity) -> Int
    func findAll() -> [Entity]
}
