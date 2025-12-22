//
//  UsuarioDAO.swift
//  HotelVerdeV2
//
//  Created by DAMII on 20/12/25.
//


import UIKit
import CoreData

class UsuarioDAO: IMetodos {
    
    typealias Bean = Usuario
    typealias Entity = UsuarioEntity

    func save(bean: Usuario) -> Int {
        var salida = -1
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        let tabla = UsuarioEntity(context: bd)
        
        tabla.codigo = bean.codigo
        tabla.nombre = bean.nombre
        tabla.apellido = bean.apellido
        tabla.correo = bean.correo
        tabla.password = bean.password
        tabla.rol = bean.rol
        
        do {
            try bd.save()
            salida = 1
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return salida
    }

    func update(bean: UsuarioEntity) -> Int {
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

    func delete(bean: UsuarioEntity) -> Int {
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

    func findAll() -> [UsuarioEntity] {
        var lista: [UsuarioEntity] = []
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let bd = delegate.persistentContainer.viewContext
        do {
            let datos = UsuarioEntity.fetchRequest()
            lista = try bd.fetch(datos) as! [UsuarioEntity]
        } catch let x as NSError {
            print(x.localizedDescription)
        }
        return lista
    }
}