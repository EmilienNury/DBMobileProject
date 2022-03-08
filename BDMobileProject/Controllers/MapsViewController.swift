//
//  MapsViewController.swift
//  BDMobileProject
//
//  Created by lpiem on 08/03/2022.
//

import UIKit
import MapKit
import CoreData

class MapsViewController: UIViewController {
    private var landmarks: [Landmark] = []
    let dbManagerInstance = CoreDataManager.sharedInstance
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        displayAllLandmarks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        displayAllLandmarks()
    }
    
    func displayAllLandmarks() {
        landmarks = dbManagerInstance.fetchAllLandmarks()
        let initialLocation = CLLocation(latitude: landmarks.first!.coordinate!.latitude, longitude: landmarks.first!.coordinate!.longitude)
        mapView.centerToLocation(initialLocation)
        for landmark in landmarks {
            let annotation = MapAnnotation(
                landmark: landmark,
                title: landmark.title,
                desc: landmark.desc,
                coordinate: CLLocationCoordinate2D(latitude: landmark.coordinate!.latitude, longitude: landmark.coordinate!.longitude)
            )
            mapView.addAnnotation(annotation)
        }
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension MapsViewController: MKMapViewDelegate {
  // 1
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        viewController.landmark = (view.annotation as? MapAnnotation)?.landmark
        viewController.title = viewController.landmark?.title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.detents = [.medium(), .large()]
        present(navigationController, animated: true, completion: nil)
        
    }
    
}
