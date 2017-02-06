//
//  MapPlaceViewController.swift
//  ActividadesIZV
//
//  Created by Fernando on 06/02/2017.
//  Copyright © 2017 Fernando. All rights reserved.
//

import MapKit
import UIKit

protocol HandleMapSearch {
    
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapPlaceViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Nos permite interacturar con el usuario y realizar las acciones del mapa de fora asyncrona
        locationManager.delegate = self
         
         /*
         Sobreescribimos el nivel de precision y lo aumentamos ya que por defecto tiene otro valor
         */
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         
         //Mostramos el dialogo de la solicitud permiso correspondiente
         locationManager.requestWhenInUseAuthorization()
         
         //Pedimos la ubicacion actual del dispositivo
         locationManager.requestLocation()
        
        //Instanciamos la tabla declarada en nuestro Storyboard
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! MapActivityTableViewController
        
        //Le asignamos el mapa a nuestra tabla
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
         //Indicamos quien se encarga de gestionar las busquedas
         resultSearchController  = UISearchController(searchResultsController: locationSearchTable)
         resultSearchController?.searchResultsUpdater = locationSearchTable
         
         let searchBar = resultSearchController!.searchBar
         searchBar.sizeToFit()
         searchBar.placeholder = "Buscando Lugares..."
         navigationItem.titleView = resultSearchController?.searchBar
         
         //Determina si la barra de navegacion desaparece cuando aparece la barra de busqueda
         resultSearchController?.hidesNavigationBarDuringPresentation = false
         //Da apariencia de modal
         resultSearchController?.dimsBackgroundDuringPresentation = true
         definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getDirections() {
        
        if let selectedPin = selectedPin {
            
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
            
        }
    }
}

extension MapPlaceViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //Si el usuario acepta el permiso pedimos la ubicacion
        if status == .authorizedWhenInUse {
            
            locationManager.requestLocation()
        }
    }
    
    /*
     Este metodo nos da un array de localizaciones donde nosotros utilizaremos solo la primera posicion
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            let span    = MKCoordinateSpanMake(0.05, 0.05)
            let region  = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error::(error)")
    }
    
}

extension MapPlaceViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        
        //Se cachea el pin
        selectedPin = placemark
        
        //Se pinta el punto existente eliminando los anteriores
        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if  let city  = placemark.locality,
            let state = placemark.administrativeArea {
            
            annotation.subtitle = city + " " + state
        }
        
        mapView.addAnnotation(annotation)
        let span    = MKCoordinateSpanMake(0.05,0.05)
        let region  = MKCoordinateRegionMake(placemark.coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            //Devuelve nil si es la ubicacion del usuario
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor   = UIColor.orange
        pinView?.canShowCallout = true
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x:0, y: 0), size: smallSquare))
        
        button.setBackgroundImage(UIImage(named:"Image"), for: .normal)
        button.addTarget(self, action: #selector(MapPlaceViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}
