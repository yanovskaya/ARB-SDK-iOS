//
//  StartViewController.swift
//  ARB_SDK
//
//  Created by Elena Yanovskaya on 10/02/2019.
//  Copyright © 2019 Elena Yanovskaya. All rights reserved.
//

import UIKit
import SceneKit
import ARB

class StartViewController: UIViewController {
    
    var model: Model!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    

    func fetchModel(completion: @escaping () -> Void) {
        let urlString = "https://fir-b1aa7.firebaseio.com/model.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self?.model = try JSONDecoder().decode(Model.self, from: data)
                completion()
            } catch { }
            }.resume()
    }
    
    func fetchImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        guard let image = UIImage(data: imageData) else { return }
                        completion(image)
                    }
                }
            }
        }.resume()
    }
    
    @IBAction func loadModel(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchModel { [weak self] in
            guard let model = self?.model else { return }
            self?.fetchImage(urlString: model.diffuse) { [weak self] diffuseImage in
                
                guard let modelURL = URL(string: model.model) else { return }
                guard let modelScene = try? SCNScene(url: modelURL) else { return }
                
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
                }
                let modelObjects = ModelObjects(model: modelScene, diffuse: diffuseImage)
                let router = ARBRouter(sender: strongSelf, modelObjects: modelObjects)
                router.showAR()
            }
        }
    }
    
}
