//
//  HomeAdminViewController.swift
//  HotelVerdeV2
//
//  Created by DAMII on 22/12/25.
//

import FirebaseAuth
import UIKit

class HomeAdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnGestionHoteles(_ sender: UIButton) {
        navegar(alId: "HotelListaAdminViewController")
    }
    @IBAction func btnGestionReservasTapped(_ sender: UIButton) {
        navegar(alId: "ReservaListaAdminViewController")
    }

    @IBAction func btnPagosTapped(_ sender: UIButton) {
        navegar(alId: "PagoListaAdminViewController")
    }

    @IBAction func btnUsuariosTapped(_ sender: UIButton) {
        navegar(alId: "UsuarioListaAdminViewController")
    }

    @IBAction func btnReportesTapped(_ sender: UIButton) {
        print("Pantalla de reportes pendiente")
    }

    @IBAction func btnCerrarSesionTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)

        } catch let error {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }

    func navegar(alId id: String) {
        if let vc = self.storyboard?.instantiateViewController(
            withIdentifier: id)
        {

            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true, completion: nil)
        } else {
            print("ERROR: No se encontró una vista con el ID: \(id)")
        }
    }
}
