//
//  PagoDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//

import UIKit

import UIKit
import CoreData

class PagoDAO: IMetodos {
    
    typealias Bean = Pago
    typealias Entity = PagoEntity

    func save(bean: Pago) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = PagoEntity(context: bd)
        
        tabla.codigo = bean.codigo
        tabla.fecha = bean.fecha
        tabla.metodo = bean.metodo
        tabla.monto = bean.monto
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: PagoEntity) -> Int {
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

    func delete(bean: PagoEntity) -> Int {
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

    func findAll() -> [PagoEntity] {
        var lista: [PagoEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = PagoEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [PagoEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}
