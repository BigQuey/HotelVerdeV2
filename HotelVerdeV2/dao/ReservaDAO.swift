//
//  ReservaDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//


import UIKit
import CoreData

class ReservaDAO: IMetodos {
    
    typealias Bean = Reserva
    typealias Entity = ReservaEntity

    func save(bean: Reserva) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = ReservaEntity(context: bd)
        
        tabla.codigo = bean.codigo
        tabla.fechaEntrada = bean.fechaEntrada
        tabla.fechaSalida = bean.fechaSalida
        tabla.total = bean.total
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: ReservaEntity) -> Int {
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

    func delete(bean: ReservaEntity) -> Int {
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

    func findAll() -> [ReservaEntity] {
        var lista: [ReservaEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = ReservaEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [ReservaEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}