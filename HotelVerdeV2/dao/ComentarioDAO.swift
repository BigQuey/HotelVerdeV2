//
//  ComentarioDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import CoreData
import FirebaseFirestore
import UIKit

class ComentarioDAO {
    let db = Firestore.firestore()

    // Guardar nuevo comentario
    func guardar(comentario: Comentario, completion: @escaping (Bool) -> Void) {

        let datos: [String: Any] = [
            "contenido": comentario.contenido,
            "fecha": Timestamp(date: comentario.fecha),  // Firebase usa Timestamp
        ]

        db.collection("comentarios").addDocument(data: datos) { error in
            if let error = error {
                print("Error guardando comentario: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    // Listar comentarios en tiempo real
    func escucharComentarios(completion: @escaping ([Comentario]) -> Void)
        -> ListenerRegistration
    {
        return db.collection("comentarios")
            .order(by: "fecha", descending: true)  // Los más nuevos primero
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }

                var lista: [Comentario] = []
                for doc in docs {
                    let data = doc.data()
                    let contenido = data["contenido"] as? String ?? ""
                    let timestamp = data["fecha"] as? Timestamp
                    let fecha = timestamp?.dateValue() ?? Date()

                    let nuevo = Comentario(
                        id: doc.documentID, contenido: contenido, fecha: fecha)
                    lista.append(nuevo)
                }
                completion(lista)
            }
    }
}
