//
//  PageViewController.swift
//  WeatherGift
//
//  Created by Sophia Howe on 11/4/21.
//

import UIKit

class PageViewController: UIPageViewController {

    var weatherLocations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadLocations()
        setViewControllers([createLocationDetailViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "weatherLocations") as? Data else {
            print("Warning: Could not load weatherLocations data from UserDefaults. This will always be the case the first time an app is installed, so if that is the case, ignore this error.")
            weatherLocations.append(WeatherLocation(name: "CURRENT LOCATION", latitude: 0.00, longitude: 0.00))
            return
        }
        let decoder = JSONDecoder()
        if let weatherLocations = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocation] {
            self.weatherLocations = weatherLocations
        } else {
            print("ERROR: Could not decode data read from UserDefaults.")
        }
        if weatherLocations.isEmpty {
            weatherLocations.append(WeatherLocation(name: "", latitude: 0.00, longitude: 0.00))
        }
    }
    
    func createLocationDetailViewController(forPage page: Int) -> LocationDetailViewController {
        let detailViewController = storyboard!.instantiateViewController(identifier: "LocationDetailViewController") as! LocationDetailViewController
        detailViewController.locationIndex = page
        return detailViewController
    }

}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if let currentViewController = viewController as? LocationDetailViewController {
        if currentViewController.locationIndex > 0 {
            return createLocationDetailViewController(forPage: currentViewController.locationIndex - 1)
        }
    }
    return nil
}

func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if let currentViewController = viewController as? LocationDetailViewController {
        if currentViewController.locationIndex < weatherLocations.count - 1 {
            return createLocationDetailViewController(forPage: currentViewController.locationIndex + 1)
        }
    }
    return nil

}
}
