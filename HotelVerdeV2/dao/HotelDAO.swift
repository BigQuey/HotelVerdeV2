//
//  HotelDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//
import UIKit
import CoreData
import FirebaseFirestore

class HotelDAO {
    
    let db = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(bean: Hotel, completion: @escaping (Bool) -> Void) {
        
        let datosFirebase: [String: Any] = [
            "nombre": bean.nombre,
            "descripcion": bean.descripcion,
            "ciudad": bean.ciudad,
            "servicio": bean.servicio,
            "codigo": bean.codigo
        ]
        
        var ref: DocumentReference? = nil
        ref = db.collection("hoteles").addDocument(data: datosFirebase) { error in
            
            if let error = error {
                print("Error en Firebase: \(error)")
                completion(false)
            } else {
                print("Guardado en Firebase con ID: \(ref!.documentID)")
                self.saveLocal(bean: bean, firebaseID: ref!.documentID)
                completion(true)
            }
        }
    }
    
    private func saveLocal(bean: Hotel, firebaseID: String) {
        let entidad = HotelEntity(context: context)
        entidad.id = firebaseID
        entidad.codigo = bean.codigo
        entidad.nombre = bean.nombre
        entidad.descripcion = bean.descripcion
        entidad.ciudad = bean.ciudad
        entidad.servicio = bean.servicio
        
        do {
            try context.save()
            print("Copia local guardada en Core Data")
        } catch {
            print("Error guardando local: \(error)")
        }
    }
    

    func sincronizarHoteles(completion: @escaping ([Hotel]) -> Void) {
        
        db.collection("hoteles").getDocuments { snapshot, error in
            
            if let error = error {
                print("Sin internet o error nube: \(error). Usando datos locales.")
                completion(self.listarLocalmente())
                return
            }

            self.borrarTodoCoreData()
            
            var listaNueva: [Hotel] = []
            
            for doc in snapshot!.documents {
                let data = doc.data()
                
                let hotel = Hotel(
                    id: doc.documentID,
                    codigo: data["codigo"] as? String ?? "0",
                    nombre: data["nombre"] as? String ?? "",
                    descripcion: data["descripcion"] as? String ?? "",
                    servicio: data["servicio"] as? String ?? "",
                    ciudad: data["ciudad"] as? String ?? ""
                )
                
                listaNueva.append(hotel)
                
                self.saveLocal(bean: hotel, firebaseID: doc.documentID)
            }
            
            completion(listaNueva)
        }
    }
    
    // Función para leer solo de Core Data (cuando no hay internet)
    func listarLocalmente() -> [Hotel] {
        var lista: [Hotel] = []
        let fetchRequest: NSFetchRequest<HotelEntity> = HotelEntity.fetchRequest()
        
        do {
            let resultados = try context.fetch(fetchRequest)
            for item in resultados {
                let h = Hotel(
                    id: item.id,
                    codigo: item.codigo ?? "",
                    nombre: item.nombre ?? "",
                    descripcion: item.descripcion ?? "",
                    servicio: item.servicio ?? "",
                    ciudad: item.ciudad ?? ""
                    
                )
                lista.append(h)
            }
        } catch {
            print("Error leyendo Core Data")
        }
        return lista
    }
    
    // Limpieza de tabla local
    private func borrarTodoCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = HotelEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error limpiando caché local")
        }
    }
}
