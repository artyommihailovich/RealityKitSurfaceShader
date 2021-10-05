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
        $0.frame = view.bounds
    }
    
    private var entity: ModelEntity!
    private var anchorEntity = AnchorEntity(plane: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MetalLibLoader.initializeMetal()
        setupSubview()
        obtainSphereEntity()
    }
    
    private func setupSubview() {
        view.addSubview(arView)
    }
    
    private func obtainSphereEntity() {
        let surfaceShader = CustomMaterial.SurfaceShader(named: "rainbow", in: MetalLibLoader.library)
        let material = PhysicallyBasedMaterial()
        
        entity = ModelEntity(mesh: .generateSphere(radius: 0.4),
                             materials: [material])
        
        entity.model?.materials = entity.model?.materials.compactMap {
            try? CustomMaterial(from: $0, surfaceShader: surfaceShader)
        } ?? [Material]()
        
        entity.generateCollisionShapes(recursive: true)
        entity.setParent(anchorEntity)
        
        entity.position.y = 0.4
        
        arView.installGestures(.all, for: entity)
        arView.scene.anchors.append(anchorEntity)
    }
}
