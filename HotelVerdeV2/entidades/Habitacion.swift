//
//  Habitacion.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit

struct Habitacion {
        var id: String?      // ID de Firebase
        var idHotel: String  // <--- CLAVE: Para saber a qué hotel pertenece
        var codigo: String
        var numero: String
        var precio: Double
        var tipo: String
        var descripcion: String
}
