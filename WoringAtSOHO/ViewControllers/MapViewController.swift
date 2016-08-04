//
//  MapViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/4.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let geoCoder = CLGeocoder()
    
    var locationManager: CLLocationManager {
        return sharedLocationManager
    }
    
    var projectInfo: ModelProjectItem? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        title = projectInfo?.projectName
//        if let location = projectInfo?.projectLocation {
//            weak var weakMapView = mapView
//            geoCoder.geocodeAddressString(location) { (listPlacemark: [CLPlacemark]?, error) in
//                if let mapView = weakMapView, listPlacemark = listPlacemark {
//                    
//                    var listAnnotation = [MKAnnotation]()
//                    listPlacemark.forEach({ placemark in
//                        let annotation = MKPlacemark(placemark: placemark)
//                        mapView.addAnnotation(annotation)
//                        listAnnotation.append(annotation)
//                    })
//                    mapView.showAnnotations(listAnnotation, animated: true)
//                    
//                }
//            }
//        }
        if let projectInfo = projectInfo, coordinate = projectInfo.localCoordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = projectInfo.projectName
            annotation.subtitle = projectInfo.projectLocation
            mapView.addAnnotation(annotation)
            mapView.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: true)
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            geoCoder.reverseGeocodeLocation(location) { (listPlacemark, error) in
                if let listPlacemark = listPlacemark {
                    if listPlacemark.count > 0 {
                        let placemark = listPlacemark[0]
                        userLocation.title = "当前位置"
                        var subtitle = ""
                        if let locality = placemark.locality {
                            subtitle += locality
                        }
                        if let name = placemark.name {
                            subtitle += " "
                            subtitle += name
                        }
                        userLocation.subtitle = subtitle
                    }
                }
            }
        }
    }

    deinit {
        mapView.delegate = nil
        locationManager.stopUpdatingLocation()
    }
}
