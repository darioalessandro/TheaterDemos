//
//  CameraViewController.swift
//  Actors
//
//  Created by Dario on 10/7/15.
//  Copyright © 2015 dario. All rights reserved.
//

import UIKit
import Theater
import AVFoundation
    
/**
ActorOutput is responsible for forwarding the images recorded in the AVCaptureSession of CameraViewController to the RemoteCam Session actor.
*/
    
public class ActorOutput : AVCaptureVideoDataOutput, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let videoQueue : DispatchQueue = DispatchQueue(label: "VideoQueue")
    
    lazy var remoteCamSession : ActorRef? = RemoteCamSystem.shared.selectActor(actorPath: "RemoteCam/user/RemoteCam Session")
    
    public init(delegate : AVCaptureVideoDataOutputSampleBufferDelegate) {
        super.init()
        self.setSampleBufferDelegate(delegate, queue: videoQueue)
    }
}
    
/**
  Camera UI
*/

public class CameraViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession : AVCaptureSession? = nil
    
    var captureVideoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var back : UIButton!
    
    let stillImageOutput = AVCaptureStillImageOutput()
    
    var session : ActorRef = RemoteCamSystem.shared.selectActor(actorPath: "RemoteCam/user/RemoteCam Session")!
    
    /**
    Default fps, it would be neat if we would adjust this based on network conditions.
    */
    
    let fps = 3
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupCamera()
        session ! UICmd.BecomeCamera(sender: nil, ctrl: self)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isBeingDismissed || self.isMovingFromParentViewController {
            if let cs = captureSession {
                cs.stopRunning()
            }
            session ! UICmd.UnbecomeCamera(sender : nil)
        }
    }
    
    public override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.rotateCameraToOrientation(orientation: toInterfaceOrientation)
    }
    
    @IBAction func goBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupCamera() -> Void {
        if let cs = self.captureSession {
            cs.stopRunning()
        }
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetHigh
        
        self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        captureVideoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill;
        captureVideoPreviewLayer!.frame = self.view.frame
        
        self.view.layer.insertSublayer(captureVideoPreviewLayer!, below: self.back.layer)
        
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        
        if captureSession!.canAddOutput(stillImageOutput) {
            captureSession!.addOutput(stillImageOutput)
        }
        
        if let videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo),
            let captureSession = captureSession {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    captureSession.addInput(videoDeviceInput)
                    
                    let output = ActorOutput(delegate: self)
                    captureSession.addOutput(output)
                    
                    output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : Int(kCVPixelFormatType_32BGRA)]
                    output.alwaysDiscardsLateVideoFrames = true
                    
                    self.setFrameRate(framerate: self.fps,videoDevice:videoDevice)
                    
                    session ! UICmd.ToggleCameraResp(flashMode:(videoDevice.hasFlash) ? videoDevice.flashMode : nil, camPosition: videoDevice.position, error: nil)
                    
                    self.captureSession?.startRunning()
                    self.rotateCameraToOrientation(orientation: UIApplication.shared.statusBarOrientation)
                } catch let error as NSError {
                    print("error \(error)")
                }
        }
    }
    
    func toggleCamera() -> Try<(AVCaptureFlashMode?,AVCaptureDevicePosition)> {
        do {
            if  let captureSession = self.captureSession,
                let genericDevice = captureSession.inputs.first as? AVCaptureDeviceInput,
                let device = genericDevice.device,
                let newPosition = device.position.toggle().toOptional(),
                let newDevice = self.cameraForPosition(position: newPosition) {
                    let newInput = try AVCaptureDeviceInput(device: newDevice)
                    captureSession.removeInput(genericDevice)
                    captureSession.addInput(newInput)
                if let res = self.setFrameRate(framerate: self.fps,videoDevice:newDevice) as? Failure {
                    return Failure(error : res.error!) //casting... swift sucks
                    } else {
                    self.rotateCameraToOrientation(orientation: UIApplication.shared.statusBarOrientation)
                        let newFlashMode : AVCaptureFlashMode? = (newInput.device.hasFlash) ? newInput.device.flashMode : nil
                        return Success(value: (newFlashMode, newInput.device.position))
                    }
            } else {
                return Failure(error: NSError(domain: "Unable to find camera", code: 0, userInfo: nil))
            }
        } catch let error as NSError {
            return Failure(error: error)
        }
    }
    
    func toggleFlash() -> Try<AVCaptureFlashMode> {
        if let captureSession = self.captureSession,
           let genericDevice = captureSession.inputs.first as? AVCaptureDeviceInput,
           let device = genericDevice.device {
            if device.hasFlash {
                return self.setFlashMode(mode: device.flashMode.next(), device: device)
            } else {
                return Failure(error: NSError(domain: "Current camera does not support flash.", code: 0, userInfo: nil))
            }
            
        }  else {
            return Failure(error: NSError(domain: "Unable to find camera", code: 0, userInfo: nil))
        }
    }
    
    func setFlashMode(mode : AVCaptureFlashMode, device : AVCaptureDevice) -> Try<AVCaptureFlashMode> {
        if device.hasFlash {
            do {
                try device.lockForConfiguration()
                device.flashMode = mode
                device.unlockForConfiguration()
            } catch let error as NSError {
                return Failure(error: error)
            } catch {
               return Failure(error: NSError(domain: "Unknown error", code: 0, userInfo: nil))
            }
        }
        return Success(value: mode)
    }
    
    func cameraForPosition(position : AVCaptureDevicePosition) -> AVCaptureDevice? {
        if let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] {
            let filtered : [AVCaptureDevice] = videoDevices.filter { return $0.position == position}
            return filtered.first
        } else {
            return nil
        }
    }

    private func rotateCameraToOrientation( orientation : UIInterfaceOrientation) {
        let o = OrientationUtils.transform(o: orientation)
        if let preview = self.captureVideoPreviewLayer {
            preview.connection.videoOrientation = o
            if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
                videoConnection.videoOrientation = o
                preview.frame = self.view.bounds
            }
        }        
        
        self.stillImageOutput.connections.forEach {
            ($0 as! AVCaptureConnection).videoOrientation = o //stupid swift
        }
    }
    
    func takePicture() -> Void {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {[unowned self]
                (imageSampleBuffer, error) in
                if imageSampleBuffer == nil {
                    self.session ! UICmd.OnPicture(sender: nil, error: NSError(domain: "Unable to take picture", code: 0, userInfo: nil))
                } else {
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer) {
                        self.session ! UICmd.OnPicture(sender: nil, pic:imageData)
                    }
                }
            }
        }
    }
    
    func setFrameRate(framerate:Int, videoDevice: AVCaptureDevice) -> Try<Int> {
        do {
            try videoDevice.lockForConfiguration()
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1,Int32(framerate))
            videoDevice.activeVideoMinFrameDuration = CMTimeMake(1,Int32(framerate))
            videoDevice.unlockForConfiguration()
            return Success(value:framerate)
        } catch let error as NSError {
            return Failure(error: error)
        } catch {
            return Failure(error: NSError(domain: "unknown error", code: 0, userInfo: nil))
        }
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if let cgBackedImage = UIImage(from: sampleBuffer, orientation: OrientationUtils.transformOrientationToImage(o: UIApplication.shared.statusBarOrientation)) {
            let imageData = UIImageJPEGRepresentation(cgBackedImage, 0.1)!
        
            if let captureSession = self.captureSession,
                let genericDevice = captureSession.inputs.first as? AVCaptureDeviceInput,
                let device = genericDevice.device {
                    let msg = RemoteCmd.SendFrame(data: imageData, sender: nil, fps:3, camPosition: device.position)
                    self.session ! msg
            }
        }
    }
}
