//
//  ScanTextViewController.swift
//  neuroverse
//
//  Created by Anuva Garg on 20/05/23.
//

import UIKit
import Vision
import VisionKit

class ScanTextViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    let textRecognitionQueue = DispatchQueue.init(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    var requests = [VNRequest]()
    
    @IBOutlet weak var scanTextView: UITextView!
    @IBOutlet weak var copyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVision()
    }
    
    @IBAction func copyText(_ sender: UIButton) {
        guard let text = scanTextView.text else {
            return
        }
        
        UIPasteboard.general.string = text
        
        let alert = UIAlertController(title: "Text Copied", message: "The text has been copied to the clipboard.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let documentCameraController = VNDocumentCameraViewController()
        documentCameraController.delegate = self
        self.present(documentCameraController, animated: true, completion: nil)
    }
    func setUpVision() {
        let textRecognitionRequest = VNRecognizeTextRequest {(request, Error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No Results Found.")
                return
            }
            var recognizedText = ""
            let maximumCandidates = 1
            for observation in observations {
                let candidate = observation.topCandidates(maximumCandidates).first
                recognizedText += candidate?.string ?? " " + "\n "
                if let recognizedText = candidate?.string {
                        let confidence = candidate?.confidence ?? 0.0
                        let textWithConfidence = "\(recognizedText) (Confidence: \(confidence))"
                        print(textWithConfidence)
                    }
            }
            self.scanTextView.text = recognizedText
        }
        textRecognitionRequest.recognitionLevel = .accurate
        self.requests = [textRecognitionRequest]
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true, completion: nil)
        for i in 0..<scan.pageCount {
            let scannedImage = scan.imageOfPage(at: i)
            if let cgImage = scannedImage.cgImage {
                let requestHandler = VNImageRequestHandler.init(cgImage: cgImage, options: [:])
                do {
                    try requestHandler.perform(self.requests)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true, completion: nil)
        print("ERROR")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
