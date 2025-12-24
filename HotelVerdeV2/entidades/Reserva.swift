//
//  Reserva.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import Foundation

struct Reserva {
    var id: String?
    var idHotel: String     // <--- AGREGADO: Para saber el ID técnico del hotel
    var nombreHotel: String // Para mostrarlo rápido en la lista sin buscar
    var nombreCliente: String
    var apellidoCliente: String // Opcional si solo usas un campo nombre
    var dniCliente: String
    var fechaInicio: Date
    var fechaFin: Date
    var fechaCreacion: Date
}
