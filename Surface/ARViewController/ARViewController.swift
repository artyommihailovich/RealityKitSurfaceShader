//
//  ARViewController.swift
//  Surface
//
//  Created by Artyom Mihailovich on 10/5/21.
//

import ARKit
import UIKit
import RealityKit

final class ARViewController: UIViewController {
    
    private lazy var arView = ARView().do {
        $0.environment.sceneUnderstanding.options.insert([.occlusion])
        $0.renderOptions.insert(.disableMotionBlur)
        $0.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MetalLibLoader.initializeMetal()
        configureWorldTracking()
        setupSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obtainSphereEntity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        arView.session.pause()
    }
    
    private func setupSubview() {
        view.addSubview(arView)
    }
    
    private func configureWorldTracking() {
        let configuration = ARWorldTrackingConfiguration()
        
        let personSegmentation: ARWorldTrackingConfiguration.FrameSemantics = .personSegmentationWithDepth
        if ARWorldTrackingConfiguration.supportsFrameSemantics(personSegmentation) {
            configuration.frameSemantics.insert(personSegmentation)
        }
        
        let sceneReconstruction: ARWorldTrackingConfiguration.SceneReconstruction = .mesh
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(sceneReconstruction) {
            configuration.sceneReconstruction.insert(sceneReconstruction)
        }
        
        configuration.planeDetection.insert(.horizontal)
        arView.session.run(configuration)
    }
    
    private func obtainSphereEntity() {
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        let customMaterial: CustomMaterial
        let surfaceShader = CustomMaterial.SurfaceShader(named: "rainbow", in: MetalLibLoader.library)
        
        do {
            try customMaterial = CustomMaterial(surfaceShader: surfaceShader, lightingModel: .lit)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let entity = ModelEntity(mesh: .generateSphere(radius: 0.6),
                             materials: [customMaterial])
        
        entity.generateCollisionShapes(recursive: true)
        entity.setParent(anchorEntity)
        
        entity.position.y = 0.6
        
        arView.installGestures(.all, for: entity)
        arView.scene.anchors.append(anchorEntity)
    }
}
