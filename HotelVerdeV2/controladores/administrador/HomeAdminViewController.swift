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
        // Asegúrate de crear esta vista y ponerle el ID
        navegar(alId: "ReservaListaAdminViewController")
    }

    // 3. PAGOS
    @IBAction func btnPagosTapped(_ sender: UIButton) {
        // Asegúrate de crear esta vista y ponerle el ID
        navegar(alId: "PagoListaAdminViewController")
    }

    // 4. USUARIOS
    @IBAction func btnUsuariosTapped(_ sender: UIButton) {
        // Asegúrate de crear esta vista y ponerle el ID
        navegar(alId: "UsuarioListaAdminViewController")
    }

    // 5. REPORTES
    @IBAction func btnReportesTapped(_ sender: UIButton) {
        // Si aún no tienes esta pantalla, puedes poner un print por ahora
        print("Pantalla de reportes pendiente")
    }

    // MARK: - CERRAR SESIÓN
    @IBAction func btnCerrarSesionTapped(_ sender: UIButton) {
        do {
            // 1. Cerrar sesión en Firebase
            try Auth.auth().signOut()

            // 2. Volver a la pantalla de Login
            // Al hacer dismiss, se cierra este Home y se ve lo que había atrás (el Login)
            self.dismiss(animated: true, completion: nil)

        } catch let error {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }

    func navegar(alId id: String) {
        // Intentamos crear la vista buscándola por su ID
        if let vc = self.storyboard?.instantiateViewController(
            withIdentifier: id)
        {

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
