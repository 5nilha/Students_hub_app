//
//  MapViewController.swift
//  StudentHub
//
//  Created by Fabio Quintanilha on 9/8/19.
//  Copyright © 2019 StudentHub. All rights reserved.
//

import UIKit
import Mapbox
import RadarSDK
import CoreLocation
import MapboxDirections
import MapboxNavigation
import MapboxCoreNavigation

class MapViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var locationManagerView: UIView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var parkingCarButton: UIButton!
    @IBOutlet weak var findMyCarButton: UIButton!
    @IBOutlet weak var topMenu: UIButton!
    
    var parkedCarCoordinates: CLLocationCoordinate2D!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.logoView.isHidden = true
        self.mapView.attributionButton.isHidden = true
        self.mapView.allowsTilting = true
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
         Radar.setDelegate(self)
        self.findMyCarButton.isHidden = true
        self.addSideMenuButton(menuButton: topMenu)
        
        self.mapView.styleURL = NSURL(string: "mapbox://styles/thestudenthub/ck0aj1o902w721cn8083fudcw")! as URL
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 28.553669, longitude: -81.251474), altitude: 600, pitch: 80, heading: 1)
        self.setLocationAuthorization()
    }
    
    func setLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            self.locationManagerView.isHidden = true
            let trackingOptions = RadarTrackingOptions()
            trackingOptions.priority = .efficiency // use .efficiency instead to reduce location update frequency
            trackingOptions.offline = .replayOff // use .replayOff instead to disable offline replay
            trackingOptions.sync = .all // use .all instead to sync all location updates
            
            Radar.startTracking(trackingOptions: trackingOptions)
            break
        case .authorizedWhenInUse:
            self.locationManagerView.isHidden = true
            Radar.trackOnce(completionHandler: { (status: RadarStatus, location: CLLocation?, events: [RadarEvent]?, user: RadarUser?) in
                // do something with status, location, events, user
            })
            break
        case .notDetermined:
            self.locationManagerView.isHidden = false
            self.locationManager.requestAlwaysAuthorization()
            break
        case .restricted:
            self.locationManagerView.isHidden = false
            break
        case .denied:
            self.locationManagerView.isHidden = false
            break
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction func findMyCarButtonTapped(_ sender: UIButton) {
        if let locationManager = self.locationManager {
            if let userLocation = locationManager.location {
                if let parkedCarCoordinates = self.parkedCarCoordinates {
                    self.BuildPolyline(destination: parkedCarCoordinates, user_location: userLocation.coordinate) {
                    }
                }
            }
        }
    }
    
    
    @IBAction func parkingCarButtonTapped(_ sender: UIButton) {
        self.findMyCarButton.isHidden = false
        //TODO Will call the user current location where parked the car, and save the car location to database
        self.parkingCarButton.isHidden = true
        let carAnnotation = MyCustomPointAnnotation()
        carAnnotation.coordinate = CLLocationCoordinate2D(latitude: 28.550163, longitude: -81.251044)
        carAnnotation.title = "My Car"
        carAnnotation.willUseImage = true
        self.parkedCarCoordinates = carAnnotation.coordinate
        
        mapView.addAnnotation(carAnnotation)
    }
    
    
    func setRegionToParkedCar() {
        if let parkedCarCoordinates = parkedCarCoordinates {
            let region = CLCircularRegion(center: parkedCarCoordinates, radius: 200, identifier: "parked_car")
            self.locationManager.startMonitoring(for: region)
        }
    }
}

//MARK: ------------------------------- MONITORING LOCATION MANAGER ------------------------------
extension MapViewController {
    //------------------------------- MONITORING REGION ------------------------------
    
    //MARK: -> REGION MONITORING
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        var distance = 0.0
        if locationManager.location != nil && self.parkedCarCoordinates != nil{
            distance = Double(locationManager.location?.distance(from: CLLocation(latitude: self.parkedCarCoordinates.latitude, longitude: self.parkedCarCoordinates.longitude)) ?? 0.0)
        }
        
        if distance < 15 {
            //TODO: Make the logic here
            self.parkingCarButton.isHidden = false
            self.findMyCarButton.isHidden = true
            //TODO = delete the car coordinates from database
            self.parkedCarCoordinates = nil
            self.locationManager.stopMonitoring(for: region)
        }
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if locationManager != nil {
            var distance = 0.0
            if locationManager.location != nil && self.parkedCarCoordinates != nil{
                distance = Double(locationManager.location?.distance(from: CLLocation(latitude: self.parkedCarCoordinates.latitude, longitude: self.parkedCarCoordinates.longitude)) ?? 0.0)
            }
            
            if distance < 15 {
                switch state {
                case .inside:
                    let region_identifier = region.identifier
                    if region_identifier != "MMELocationManagerRegionIdentifier.fence.center" {
                        self.parkingCarButton.isHidden = false
                        self.findMyCarButton.isHidden = true
                        //TODO = delete the car coordinates from database
                        self.parkedCarCoordinates = nil
                        self.locationManager.stopMonitoring(for: region)
                        
                    } else {
                        self.locationManager.stopMonitoring(for: region)
                    }
                    break;
                case .outside:
                    break
                case .unknown:
                    break
                default:
                    break
                }
            }
        }
    }
    
    //------------------------------- MONITORING LOCATION MANAGER ------------------------------
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.setLocationAuthorization()
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    
}

//------------------------------- MONITORING RADAR GEOFENCINGS ------------------------------
extension MapViewController: RadarDelegate {
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) {
        //TODO: events triggering here
    }
}


//------------------------------- CREATING POLYLINE ------------------------------
extension MapViewController {
    func BuildPolyline(destination: CLLocationCoordinate2D, user_location: CLLocationCoordinate2D,  completion: @escaping () -> ()) {
        
        calculateRoute(from: user_location, to: destination) { (route, error) in
            if let error = error {
                print("ERROR -> \(error.localizedDescription)")
                return
            }
            completion()
        }
    }
    
    func calculateRoute(from originCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> Void) {
        let origin = Waypoint(coordinate: originCoordinate, coordinateAccuracy: -1, name: "Me")
        
        
        let destination = Waypoint(coordinate: destinationCoordinate, coordinateAccuracy: -1, name: "My parked car")
        destination.targetCoordinate = destinationCoordinate
        
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobile)
        
        let directions = Directions.shared.calculate(options, completionHandler: { (Waypoints, routes, error) in
            
            if let error = error {
                print("Polyline error")
                return
            }
            
            if let routes = routes {
                let directionsRoute = routes.first
                if let directionsRoute = directionsRoute {
                    self.drawRoute(route: directionsRoute)
                    let coordinateBounds = MGLCoordinateBounds(sw: destinationCoordinate, ne: originCoordinate)
                    let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
                    let routeCamera = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
                    
                    let pitched_camera = MGLMapCamera(lookingAtCenter: routeCamera.centerCoordinate, altitude: 300, pitch: 60.0, heading: self.locationManager.location?.course ?? 1)
                    self.mapView.camera = pitched_camera
                    self.mapView.setCamera(routeCamera, animated: true)
                    
                    completion(directionsRoute, nil)
                    
                }
            }
        })
        
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        
        if let routeCoordinates = route.coordinates {
            let polyline = MGLPolylineFeature(coordinates: routeCoordinates, count: route.coordinateCount)
            
            if let mapStyle = mapView.style {
                let source = mapStyle.source(withIdentifier: "route-source") as? MGLShapeSource
            }
            
            if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
                source.shape = polyline
            }
            else {
                let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
                
                let lineStyle = MGLLineStyleLayer(identifier: "route_style", source: source)
                lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.6823529412, green: 0.1215686275, blue: 0.7215686275, alpha: 0.6877407962))
                lineStyle.lineWidth = NSExpression(forConstantValue: 8)
                
                mapView.style?.addSource(source)
                mapView.style?.addLayer(lineStyle)
            }
        }
        
    }
    
}
