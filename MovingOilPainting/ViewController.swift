//
//  ViewController.swift
//  MovingOilPainting
//
//  Created by Dikey on 2021/4/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    var sceneView: ARSCNView! = ARSCNView.init(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                  let imageName = imageAnchor.referenceImage.name else{
                return
            }
            let overlayNode = self.getNode(withImageName: imageName)
            overlayNode.opacity = 0
            overlayNode.position.y = 0.2
            node.addChildNode(overlayNode)
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
    
    func getNode(withImageName name: String) -> SCNNode {
        
        let node = SCNNode()
        let gifPlane = SCNPlane(width: 1, height: 1)
        
        let gifImage = UIImage.gifImageWithName(name)
        
        assert(gifImage != nil, "getNode:nil image")
        
        let gifImageView = UIImageView(image: gifImage)
        gifPlane.firstMaterial?.diffuse.contents = gifImageView
    
        node.geometry = gifPlane
        node.position = SCNVector3(0, 0, -1)
        
        return node
    }
        
}
