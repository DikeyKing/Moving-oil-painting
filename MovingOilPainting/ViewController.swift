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
        sceneView.showsStatistics = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let imageName = imageAnchor.referenceImage.name else{
            return nil
        }
        let node = SCNNode()
        DispatchQueue.main.async {
            let gifPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                    height: imageAnchor.referenceImage.physicalSize.height)
            
            let gifImage = UIImage.gifImageWithName(imageName)
            assert(gifImage != nil, "getNode:nil image")
            let gifImageView = UIImageView(image: gifImage)
            gifPlane.firstMaterial?.diffuse.contents = gifImageView
            
            let planeNode = SCNNode(geometry: gifPlane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
        }
        return node
    }

    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }

}
