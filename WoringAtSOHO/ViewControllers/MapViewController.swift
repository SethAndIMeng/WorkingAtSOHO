//
//  MapViewController.swift
//  WoringAtSOHO
//
//  Created by Seth Jin on 16/8/4.
//  Copyright © 2016年 SOHO3Q. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let geoCoder = CLGeocoder()
    
    var projectInfo: ModelProjectItem? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = projectInfo?.projectName
        if let location = projectInfo?.projectLocation {
            weak var weakMapView = mapView
            geoCoder.geocodeAddressString(location) { (listPlacemark: [CLPlacemark]?, error) in
                if let mapView = weakMapView, listPlacemark = listPlacemark {
                    
                    var listAnnotation = [MKPlacemark]()
                    listPlacemark.forEach({ placemark in
                        let annotation = MKPlacemark(placemark: placemark)
                        mapView.addAnnotation(annotation)
                        listAnnotation.append(annotation)
                    })
                    mapView.showAnnotations(listAnnotation, animated: true)
                    
                }
            }
        }
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

}
