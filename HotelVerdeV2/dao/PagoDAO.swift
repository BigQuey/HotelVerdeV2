//
//  PagoDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import Foundation
import FirebaseFirestore

class PagoDAO {
    
    let db = Firestore.firestore()
    let coleccion = "pagos"
    
    // MARK: - Guardar Pago
    func guardar(pago: Pago, completion: @escaping (Bool) -> Void) {
        
        let datos: [String: Any] = [
            "nombreCliente": pago.nombreCliente,
            "monto": pago.monto,
            "fecha": pago.fecha,
            "metodo": pago.metodo,
            "fechaCreacion": FieldValue.serverTimestamp()
        ]
        
        db.collection(coleccion).addDocument(data: datos) { error in
            if let error = error {
                print("Error guardando pago: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - Listar Pagos (Tiempo Real)
    func escucharPagos(completion: @escaping ([Pago]) -> Void) -> ListenerRegistration {
        
        return db.collection(coleccion)
            .order(by: "fechaCreacion", descending: true)
            .addSnapshotListener { snapshot, error in
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                var lista: [Pago] = []
                
                for doc in documents {
                    let data = doc.data()
                    let timestamp = data["fecha"] as? Timestamp
                    
                    let nuevoPago = Pago(
                        id: doc.documentID,
                        nombreCliente: data["nombreCliente"] as? String ?? "Desconocido",
                        monto: data["monto"] as? Double ?? 0.0,
                        fecha: timestamp?.dateValue() ?? Date(),
                        metodo: data["metodo"] as? String ?? "Efectivo"
                    )
                    
                    lista.append(nuevoPago)
                }
                
                completion(lista)
            }
    }
}
