//
//  UsuarioDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//


import UIKit
import CoreData
import Foundation
import FirebaseFirestore

class UsuarioDAO {
    
    let db = Firestore.firestore()
    let coleccion = "usuarios"
    
    // MARK: - Guardar (Nuevo)
    func guardar(usuario: Usuario, completion: @escaping (Bool) -> Void) {
        let datos: [String: Any] = [
            "nombre": usuario.nombre,
            "email": usuario.email,
            "clave": usuario.clave,
            "rol": usuario.rol,
            "fecha_creacion": FieldValue.serverTimestamp()
        ]
        
        db.collection(coleccion).addDocument(data: datos) { error in
            if let error = error {
                print("Error guardando usuario: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - Listar (Tiempo Real)
    func escucharUsuarios(completion: @escaping ([Usuario]) -> Void) -> ListenerRegistration {
        return db.collection(coleccion)
            .order(by: "nombre")
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    completion([])
                    return
                }
                
                var lista: [Usuario] = []
                for doc in docs {
                    let data = doc.data()
                    let u = Usuario(
                        id: doc.documentID,
                        nombre: data["nombre"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        clave: data["clave"] as? String ?? "",
                        rol: data["rol"] as? String ?? "usuario"
                    )
                    lista.append(u)
                }
                completion(lista)
            }
    }
    
    // MARK: - Editar
    func editar(usuario: Usuario, completion: @escaping (Bool) -> Void) {
        guard let id = usuario.id else { return }
        
        let datos: [String: Any] = [
            "nombre": usuario.nombre,
            "email": usuario.email,
            "clave": usuario.clave
        ]
        
        db.collection(coleccion).document(id).updateData(datos) { error in
            completion(error == nil)
        }
    }
    
    // MARK: - Eliminar
    func eliminar(id: String, completion: @escaping (Bool) -> Void) {
        db.collection(coleccion).document(id).delete { error in
            completion(error == nil)
        }
    }
}
