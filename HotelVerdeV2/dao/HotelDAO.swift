//
//  HotelDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit

class HotelDAO: IMetodos {
    func save(bean: Hotel) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = HotelEntity(context: bd)
        tabla.codigo = Int32(bean.codigo)
        tabla.nombre = bean.nombre
        tabla.descripcion = bean.descripcion
        tabla.ciudad = bean.ciudad
        tabla.servicio = bean.servicio
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: HotelEntity) -> Int {
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

    func delete(bean: HotelEntity) -> Int {
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

    func findAll() -> [HotelEntity] {
        var lista: [HotelEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = HotelEntity.fetchRequest()
            lista = try bd.fetch(datos)
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }

    typealias Bean = Hotel

    typealias Entity = HotelEntity

}
