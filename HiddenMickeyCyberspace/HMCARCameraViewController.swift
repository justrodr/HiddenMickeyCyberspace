//
//  HMCARCameraViewController.swift
//  HiddenMickeyCyberspace
//
//  Created by Justin Rodriguez on 6/29/21.
//

import UIKit
import ARKit

protocol HMCARCameraViewControllerDelegate: AnyObject {
    func didLeaveARView(score: Int, ride: HMCRide?)
}

class HMCARCameraViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var scoreContainerView: UIView!
    @IBOutlet weak var eggImageView: UIImageView!
    @IBOutlet weak var timerProgressBarView: TimerProgressBarView!
    
    private let hiddenMickeyPlacementRadius: CGFloat = 2
    private let hiddenMickeySize: CGFloat = 0.5
    private let thresholdDistance: Float = 0.5
    private let earDisplacementFactor = 1.1
    private let earSizeProportion = 0.7
    private var score: Int = 0
    private let hideDistanceLabel: Bool = true
    private let spinDuration: CGFloat = 2
    private var numMickeysGenerated: Int = 10
    weak var delegate: HMCARCameraViewControllerDelegate?
    var ride: HMCRide?
//    var mickeyHeadColor: UIColor = .blue
//    var mickeyEarColor: UIColor = .blue
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
        timerLabel.text = String(counter)
        timerLabel.textColor = HMCOrange
        scoreLabel.textColor = HMCTextColor1
        if let ride = ride {
            scoreLabel.textColor = ride.colors.headColor
            numMickeysGenerated = 11 - ride.difficulty
        }
        
        if var image = eggImageView.image {
            image = withHalfOverlayColor(myImage: image, color: ride?.colors.headColor ?? HMCNavy, isBottom: true)
            eggImageView.image = withHalfOverlayColor(myImage: image, color: ride?.colors.earColor ?? HMCBlue, isBottom: false)
        }
        
        leaveButton.layer.cornerRadius = 8
        scoreContainerView.layer.cornerRadius = 50
        timerProgressBarView.setupView()
        timerProgressBarView.animateBar()
        distanceLabel.isHidden = hideDistanceLabel
        scoreContainerView.backgroundColor = HMCWhite
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        placeRandomHiddenMickeys()
//        generateHiddenMickeyShape(center: (0,0,0), size: hiddenMickeySize, headColor: HMCNavy, earColor: HMCNavy)
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            timerLabel.text = String(counter)
            counter -= 1
        } else {
            timer?.invalidate()
            delegate?.didLeaveARView(score: score, ride: ride)
        }
    }
    
    func placeRandomHiddenMickeys() {
        var hiddenMickeyCenterPoints: [(CGFloat, CGFloat, CGFloat)] = []
        for _ in 1...numMickeysGenerated {
            hiddenMickeyCenterPoints.append((randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius), randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius), randomNumbers(firstNum: -hiddenMickeyPlacementRadius, secondNum: hiddenMickeyPlacementRadius)))
        }
        
        for center in hiddenMickeyCenterPoints {
            generateHiddenMickeyShape(center: center, size: hiddenMickeySize, headColor: ride?.colors.headColor ?? HMCNavy, earColor: ride?.colors.earColor ?? HMCBlue)
        }
        
    }
    
    func generateHiddenMickeyShape(center: (CGFloat, CGFloat, CGFloat), size: CGFloat, headColor: UIColor, earColor: UIColor) {
        
        self.sceneView.scene.rootNode.name = "root"
        
        let eggTopPath = UIBezierPath()
        eggTopPath.move(to: .zero)
        eggTopPath.addCurve(to: CGPoint(x: 1 * size, y: 0), controlPoint1: CGPoint(x: 0.2 * size, y: 1.2 * size), controlPoint2: CGPoint(x: 0.8 * size, y: 1.2 * size))
        eggTopPath.close()
        eggTopPath.fill()
        eggTopPath.flatness = 0.001
        let eggBottomPath = UIBezierPath()
        eggBottomPath.addArc(withCenter: CGPoint(x: 0.5 * size, y: 0), radius: 0.5 * size, startAngle: .pi, endAngle: 0, clockwise: true)
        eggBottomPath.close()
        eggBottomPath.fill()
        eggBottomPath.flatness = 0.001
        
        let eggTopShape = SCNShape(path: eggTopPath, extrusionDepth: 0.05)
        let eggTopNode = SCNNode()
        eggTopNode.geometry = eggTopShape
        eggTopNode.geometry?.firstMaterial?.specular.contents = earColor.darker(by:70)
        eggTopNode.geometry?.firstMaterial?.diffuse.contents = earColor
        eggTopNode.position = SCNVector3(center.0, center.1, center.2)
        eggTopNode.name = "eggTopNode"
        
        let eggBottomShape = SCNShape(path: eggBottomPath, extrusionDepth: 0.05)
        let eggBottomNode = SCNNode()
        eggBottomNode.geometry = eggBottomShape
        eggBottomNode.geometry?.firstMaterial?.specular.contents = headColor.darker(by:70)
        eggBottomNode.geometry?.firstMaterial?.diffuse.contents = headColor
        eggBottomNode.position = SCNVector3(center.0, center.1, center.2)
        eggBottomNode.name = "eggBottomNode"
        
        let eggParentNode = SCNNode()
        eggParentNode.name = "eggParentNode"
        eggParentNode.position = SCNVector3(center.0, center.1, center.2)
        
        eggParentNode.addChildNode(eggTopNode)
        eggParentNode.addChildNode(eggBottomNode)
        
        let minimum = float3(eggParentNode.boundingBox.min)
        let maximum = float3(eggParentNode.boundingBox.max)
        let translation = (maximum + minimum) * 0.5
        eggParentNode.pivot = SCNMatrix4MakeTranslation(translation.x, translation.y, translation.z)
        
        let action = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: spinDuration))
        eggParentNode.runAction(action)
        
        self.sceneView.scene.rootNode.addChildNode(eggParentNode)
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
            if node.name == "eggTopNode" || node.name == "eggBottomNode" || node.name == "eggParentNode" {
                score += 1
                scoreLabel.text = String(score)
            }
            
            if node.parent?.name == "eggParentNode" {
                guard let parentNode = node.parent else {
                    return
                }
                parentNode.enumerateChildNodes { (childNode, stop) in
                    childNode.removeFromParentNode()
                }
                parentNode.removeFromParentNode()
            }
            
            node.removeFromParentNode()
        }
    }
    
    @IBAction func didPressLeaveButton(_ sender: Any) {
        timer?.invalidate()
        delegate?.didLeaveARView(score: score, ride: ride)
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
