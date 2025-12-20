//
//  HabitacionDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit
import CoreData

class HabitacionDAO: IMetodos {
    
    typealias Bean = Habitacion
    typealias Entity = HabitacionEntity

    func save(bean: Habitacion) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = HabitacionEntity(context: bd)
        
        tabla.codigo = bean.codigo
        tabla.numero = bean.numero
        tabla.precio = bean.precio
        tabla.tipo = bean.tipo
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: HabitacionEntity) -> Int {
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

    func delete(bean: HabitacionEntity) -> Int {
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

    func findAll() -> [HabitacionEntity] {
        var lista: [HabitacionEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = HabitacionEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [HabitacionEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}
