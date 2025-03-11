//
//  Helper.swift
//  NewAPIBS
//
//  Created by Humayun Kabir on 11/3/25.
//

import UIKit
import Network

extension UIViewController {
    private struct ActivityIndicatorHolder {
        static var activityIndicatorView: UIView?
    }
    
    func showActivityIndicator() {
        guard ActivityIndicatorHolder.activityIndicatorView == nil else { return }
        
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        ActivityIndicatorHolder.activityIndicatorView = loadingView
    }
    
    func hideActivityIndicator() {
        ActivityIndicatorHolder.activityIndicatorView?.removeFromSuperview()
        ActivityIndicatorHolder.activityIndicatorView = nil
    }
    
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let isConnected = path.status == .satisfied
                completion(isConnected)
            }
        }
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
    }
    
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

