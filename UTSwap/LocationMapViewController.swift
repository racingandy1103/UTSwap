//
//  LocationMapViewController.swift
//  UTSwap
//
//  Created by Jessica Trejo on 11/27/21.
//

import UIKit
import MapKit

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

let GDC_COOR = (30.286313, -97.736479)
let TOWER_COOR = (30.2861, -97.7393)
let JESTER_COOR = (30.282980, -97.736811)
let UNION_COOR = (30.286587, -97.741197)
let LITTLEFIELD_COOR = (30.283823, -97.739546)

let LOC_MAP = [
    "GDC": GDC_COOR,
    "TOWER": TOWER_COOR,
    "JESTER": JESTER_COOR,
    "UNION": UNION_COOR,
    "LITTLEFIELD": LITTLEFIELD_COOR,
]

class MeetLocation: NSObject, MKAnnotation {
  let locationName: String?
  let coordinate: CLLocationCoordinate2D

  init(
    locationName: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.locationName = locationName
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}

class LocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var meetLocation: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapkit()
        mapView.showsUserLocation = true

    }
    
    func setupMapkit() {
        
        // UT TOWER
        let initialLocation = CLLocation(latitude: 30.2861, longitude: -97.7393)
        
        mapView.centerToLocation(initialLocation)
        
        if meetLocation != nil {
            let meet = meetLocation?.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
            var coords: (Double,Double)? = nil
            for i in LOC_MAP.keys {
                if i.caseInsensitiveCompare(meet!) == .orderedSame {
                    coords = LOC_MAP[meet!]
                    break
                }
            }
            
            if coords != nil {
                
                let (lat, long) = coords!
                let meetLocationCenter = CLLocation(latitude: lat, longitude: long)
                
                let region = MKCoordinateRegion(
                  center: meetLocationCenter.coordinate,
                  latitudinalMeters: 50000,
                  longitudinalMeters: 60000)
                mapView.setCameraBoundary(
                  MKMapView.CameraBoundary(coordinateRegion: region),
                  animated: true)
                
                let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
                mapView.setCameraZoomRange(zoomRange, animated: true)
                
                let meetLocName = meetLocation
                // Show meetLocation on map
                let meetLoc = MeetLocation(
                  locationName: meetLocName,
                  coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                mapView.addAnnotation(meetLoc)
            }
        }
    }
}
