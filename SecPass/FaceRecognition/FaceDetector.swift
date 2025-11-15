//
//  FaceDetector.swift
//  SecPass
//
//  Created by Jorge Luis Salcedo Orozco on 13/11/25.
//

import AVFoundation
import Vision
import Combine

class FaceDetector: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var session: AVCaptureSession?
    @Published var numberOfFaces: Int = 0
    
    func start() {
        let captureSession = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Can't get camera")
            return
        }
        
        captureSession.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera"))
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        self.session = captureSession
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }
    
    func stop() {
        session?.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let faceObservations = request.results as? [VNFaceObservation] else { return }
            
            DispatchQueue.main.async {
                self?.numberOfFaces = faceObservations.count
            }
            
            if let firstFace = faceObservations.first {
                let normalizedBoundingBox = firstFace.boundingBox
                print("Face detected at: \(normalizedBoundingBox)")
                print("Faces found: \(faceObservations.count)")
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
