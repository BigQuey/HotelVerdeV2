//
//  HabitacionDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import Foundation
import FirebaseFirestore

class HabitacionDAO {
    
    let db = Firestore.firestore()
    
    func guardar(habitacion: Habitacion, completion: @escaping (Bool) -> Void) {
        
        let datos: [String: Any] = [
            "idHotel": habitacion.idHotel,
            "codigo": habitacion.codigo,
            "numero": habitacion.numero,
            "precio": habitacion.precio,
            "tipo": habitacion.tipo,
            "descripcion": habitacion.descripcion,
            "fecha_creacion": FieldValue.serverTimestamp()
        ]
        
        db.collection("habitaciones").addDocument(data: datos) { error in
            if let error = error {
                print("Error guardando habitación: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func listarPorHotel(idHotel: String, completion: @escaping ([Habitacion]) -> Void) {
        
        db.collection("habitaciones")
            .whereField("idHotel", isEqualTo: idHotel)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("Error listando: \(error)")
                    completion([])
                    return
                }
                
                var lista: [Habitacion] = []
                
                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }
                
                for doc in docs {
                    let data = doc.data()
                    let hab = Habitacion(
                        id: doc.documentID,
                        idHotel: data["idHotel"] as? String ?? "",
                        codigo: data["codigo"] as? String ?? "",
                        numero: data["numero"] as? String ?? "",
                        precio: data["precio"] as? Double ?? 0.0,
                        tipo: data["tipo"] as? String ?? "",
                        descripcion: data["descripcion"] as? String ?? ""
                    )
                    lista.append(hab)
                }
                
                completion(lista)
            }
    }
    
    func eliminar(idHabitacion: String, completion: @escaping (Bool) -> Void) {
        db.collection("habitaciones").document(idHabitacion).delete { error in
            completion(error == nil)
        }
    }
}
