//
//  ComentarioDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit

import UIKit
import CoreData

class ComentarioDAO: IMetodos {
    
    typealias Bean = Comentario
    typealias Entity = ComentarioEntity

    func save(bean: Comentario) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = ComentarioEntity(context: bd)
        
        // Mapeo de datos
        tabla.codigo = bean.codigo
        tabla.calificacion = bean.calificacion
        tabla.fecha = bean.fecha
        tabla.mensaje = bean.mensaje
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: ComentarioEntity) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func delete(bean: ComentarioEntity) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            bd.delete(bean)
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func findAll() -> [ComentarioEntity] {
        var lista: [ComentarioEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = ComentarioEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [ComentarioEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}
