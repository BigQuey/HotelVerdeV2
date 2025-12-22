//
//  HomeAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import UIKit

class HomeAdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

    @IBAction func btnGestionHoteles(_ sender: UIButton) {
        navegar(alId: "HotelListaAdminViewController")
    }
    
    
    
    @IBAction func btnGestionReservas(_ sender: UIButton) {
    }
    
    
    func navegar(alId id: String) {
            // Intentamos crear la vista buscándola por su ID
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: id) {
                
                // Configuración visual:
                // .fullScreen tapa toda la pantalla (recomendado para menús principales)
                vc.modalPresentationStyle = .fullScreen
                
                // Presentamos la vista
                self.present(vc, animated: true, completion: nil)
            } else {
                print("ERROR: No se encontró una vista con el ID: \(id)")
            }
        }
}
