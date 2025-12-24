

import Foundation

struct Reserva {
    
    var id: String?
    var idHotel: String
    var nombreHotel: String // Para mostrarlo rápido en la lista sin buscar
    var nombreCliente: String
    var apellidoCliente: String
    var dniCliente: String
    var fechaInicio: Date
    var fechaFin: Date
    var fechaCreacion: Date
}
