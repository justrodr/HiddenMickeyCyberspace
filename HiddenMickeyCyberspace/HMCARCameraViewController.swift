//
//  HMCARCameraViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/29/21.
//

import UIKit
import ARKit

protocol HMCARCameraViewControllerDelegate: AnyObject {
    func didLeaveARView(score: Int)
}

class HMCARCameraViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leaveButton: UIButton!
    
    private let hiddenMickeyPlacementRadius: CGFloat = 3
    private let hiddenMickeySize: CGFloat = 0.2
    private let thresholdDistance: Float = 0.5
    private let earDisplacementFactor = 0.9
    private let earSizeProportion = 0.7
    private var score: Int = 0
    weak var delegate: HMCARCameraViewControllerDelegate?
    var mickeyHeadColor: UIColor = .blue
    var mickeyEarColor: UIColor = .blue
    var counter: Int = 60
    var timer: Timer?
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.session.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        counter = 60
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        placeRandomHiddenMickeys()
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            timerLabel.text = String(counter)
            counter -= 1
        } else {
            timer?.invalidate()
            delegate?.didLeaveARView(score: score)
        }
    }
    
    func placeRandomHiddenMickeys() {
        var hiddenMickeyCenterPoints: [(CGFloat, CGFloat, CGFloat)] = []
        for _ in 1...10 {
            hiddenMickeyCenterPoints.append((randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius), randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius), randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius)))
        }
        
        for center in hiddenMickeyCenterPoints {
            generateHiddenMickeyShape(center: center, size: hiddenMickeySize, headColor: mickeyHeadColor, earColor: mickeyEarColor)
        }
        
    }
    
    func generateHiddenMickeyShape(center: (CGFloat, CGFloat, CGFloat), size: CGFloat, headColor: UIColor, earColor: UIColor) {
        
        let headColorShadow = headColor.darker(by: 70)
        let earColorShadow = earColor.darker(by: 70)
        let headNode = SCNNode()
        let ear1Node = SCNNode()
        let ear2Node = SCNNode()
        let head = SCNSphere(radius: size)
        let ear1 = SCNSphere(radius: size * earSizeProportion)
        let ear2 = SCNSphere(radius: size * earSizeProportion)
        
        
        headNode.geometry = head
        headNode.geometry?.firstMaterial?.specular.contents = headColorShadow
        headNode.geometry?.firstMaterial?.diffuse.contents = headColor
        
        ear1Node.geometry = ear1
        ear1Node.geometry?.firstMaterial?.specular.contents = earColorShadow
        ear1Node.geometry?.firstMaterial?.diffuse.contents = earColor
        
        ear2Node.geometry = ear2
        ear2Node.geometry?.firstMaterial?.specular.contents = earColorShadow
        ear2Node.geometry?.firstMaterial?.diffuse.contents = earColor
        
        headNode.position = SCNVector3(center.0, center.1, center.2)
        ear1Node.position = SCNVector3(-(size * earDisplacementFactor), (size * earDisplacementFactor), 0)
        ear2Node.position = SCNVector3((size * earDisplacementFactor), (size * earDisplacementFactor), 0)
        
        headNode.addChildNode(ear1Node)
        headNode.addChildNode(ear2Node)
        self.sceneView.scene.rootNode.addChildNode(headNode)
        
        headNode.name = "head"
        ear1Node.name = "ear1"
        ear2Node.name = "ear2"
        
        self.sceneView.scene.rootNode.name = "root"
//        self.sceneView.scene.rootNode.addChildNode(ear1Node)
//        self.sceneView.scene.rootNode.addChildNode(ear2Node)
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
      return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer) {
        guard let sceneView = recognizer.view as? SCNView else { return }
        let touchLocation = recognizer.location(in: sceneView)

        let results = sceneView.hitTest(touchLocation, options: [:])

        if results.count == 1 {
            let node = results[0].node
            if node.name == "head" || node.name == "ear1" || node.name == "ear2" {
                score += 1
                scoreLabel.text = String(score)
            }
            node.enumerateChildNodes { (earNode, stop) in
                earNode.removeFromParentNode()
            }
            if node.parent?.name == "head" {
                guard let headNode = node.parent else {
                    return
                }
                headNode.enumerateChildNodes { (earNode, stop) in
                    earNode.removeFromParentNode()
                }
                headNode.removeFromParentNode()
            }
            node.removeFromParentNode()
        }
    }
    
    @IBAction func didPressLeaveButton(_ sender: Any) {
        delegate?.didLeaveARView(score: score)
    }
    
}

extension HMCARCameraViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let currentTransform = frame.camera.transform.columns.3
        let distanceSquared = currentTransform.x * currentTransform.x + currentTransform.y * currentTransform.y
        distanceLabel.text = String(distanceSquared.squareRoot())
        if let configuration = sceneView.session.configuration, distanceSquared >= (thresholdDistance * thresholdDistance) {
            sceneView.session.run(configuration, options: .resetTracking)
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            placeRandomHiddenMickeys()
        }
    }
}
