//
//  ServicioDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//


import UIKit
import CoreData

class ServicioDAO: IMetodos {
    
    typealias Bean = Servicio
    typealias Entity = ServicioEntity

    func save(bean: Servicio) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = ServicioEntity(context: bd)
        
        tabla.codigo = bean.codigo
        tabla.nombre = bean.nombre
        tabla.descripcion = bean.descripcion
        tabla.precio = bean.precio
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: ServicioEntity) -> Int {
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

    func delete(bean: ServicioEntity) -> Int {
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

    func findAll() -> [ServicioEntity] {
        var lista: [ServicioEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = ServicioEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [ServicioEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}