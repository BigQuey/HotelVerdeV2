//
//  ReservaDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import Foundation
import FirebaseFirestore

class ReservaDAO {
    
    let db = Firestore.firestore()
    let coleccion = "reservas"
    
    // MARK: - Guardar Reserva
    func guardar(reserva: Reserva, completion: @escaping (Bool) -> Void) {
        
        let datos: [String: Any] = [
            "nombreCliente": reserva.nombreCliente,
            "apellidoCliente": reserva.apellidoCliente,
            "dniCliente": reserva.dniCliente,
            "nombreHotel": reserva.nombreHotel,
            "fechaInicio": reserva.fechaInicio,
            "fechaFin": reserva.fechaFin,
            "fechaCreacion": FieldValue.serverTimestamp()
        ]
        
        db.collection(coleccion).addDocument(data: datos) { error in
            if let error = error {
                print("Error guardando reserva: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - Listar Todas (Tiempo Real)
    // Usamos addSnapshotListener para que si agregas una, aparezca sola.
    func escucharReservas(completion: @escaping ([Reserva]) -> Void) -> ListenerRegistration {
        
        return db.collection(coleccion)
            .order(by: "fechaCreacion", descending: true)
            .addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                var lista: [Reserva] = []
                
                for doc in documents {
                    let data = doc.data()
                    
                    // Convertir Timestamp de Firebase a Date de Swift
                    let timestampInicio = data["fechaInicio"] as? Timestamp
                    let timestampFin = data["fechaFin"] as? Timestamp
                    let timestampCreacion = data["fechaCreacion"] as? Timestamp
                    
                    let nuevaReserva = Reserva(
                        id: doc.documentID,
                        idHotel: data["idHotel"] as? String ?? "",
                        nombreHotel: data["nombreHotel"] as? String ?? "",
                        nombreCliente: data["nombreCliente"] as? String ?? "",
                        apellidoCliente: data["apellidoCliente"] as? String ?? "",
                        dniCliente: data["dniCliente"] as? String ?? "",
                        fechaInicio: timestampInicio?.dateValue() ?? Date(),
                        fechaFin: timestampFin?.dateValue() ?? Date(),
                        fechaCreacion: timestampCreacion?.dateValue() ?? Date()
                    )
                    
                    lista.append(nuevaReserva)
                }
                
                completion(lista)
            }
    }
    func actualizar(reserva: Reserva, completion: @escaping (Bool) -> Void) {
            guard let idReserva = reserva.id else { return }
            
            let datos: [String: Any] = [
                "nombreCliente": reserva.nombreCliente,
                "apellidoCliente": reserva.apellidoCliente,
                "dniCliente": reserva.dniCliente,
                "nombreHotel": reserva.nombreHotel,
                "fechaInicio": reserva.fechaInicio,
                "fechaFin": reserva.fechaFin
                // No actualizamos fechaCreacion
            ]
            
            db.collection(coleccion).document(idReserva).updateData(datos) { error in
                completion(error == nil)
            }
        }
        
        // MARK: - Eliminar Reserva
        func eliminar(id: String, completion: @escaping (Bool) -> Void) {
            db.collection(coleccion).document(id).delete { error in
                completion(error == nil)
            }
        }
}
