//
//  SentimentViewController.swift
//  neuroverse
//
//  Created by Anuva Garg on 21/05/23.
//
import NaturalLanguage
import UIKit

class SentimentViewController: UIViewController {

    @IBOutlet weak var sentimentScoreTextView: UITextView!
    
    @IBOutlet weak var sentimentImageView: UIImageView!
    
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentimentImageView.image = UIImage(named: "neutral")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextView.resignFirstResponder()
    }
    
    @IBAction func analyzeButtonTapped(_ sender: Any) {
        guard let text = inputTextView.text else {
                    return
                }
                
                let sentiment = analyzeSentiment(for: text)
                displaySentiment(sentiment)
    }
    func analyzeSentiment(for text: String) -> String {
        guard let modelURL = Bundle.main.url(forResource: "MyTextClassifier", withExtension: "mlmodelc") else {
            fatalError("Failed to load the MLModel.")
        }
        guard let model = try? NLModel(contentsOf: modelURL) else {
            fatalError("Failed to create the NLModel.")
        }
        let predictedLabel = model.predictedLabel(for: text)
        // Example implementation using a switch statement for emotion mapping
        var emotionLabel = ""
        switch predictedLabel {
        case "0":
            emotionLabel = "sadness"
        case "1":
            emotionLabel = "joy"
        case "2":
            emotionLabel = "love"
        case "3":
            emotionLabel = "anger"
        case "4":
            emotionLabel = "fear"
        default:
            emotionLabel = "unknown"
        }
        return emotionLabel
    }
    func displaySentiment(_ sentiment: String?) {
            guard let sentiment = sentiment else {
                sentimentImageView.image = UIImage(named: "neutral")
                sentimentScoreTextView.text = "Unable to determine sentiment"
                return
            }
            
            if sentiment == "sadness" {
                sentimentImageView.image = UIImage(named: "sadness")
                sentimentScoreTextView.text = "sentiment: sadness"
            } else if sentiment == "joy" {
                sentimentImageView.image = UIImage(named: "joy")
                sentimentScoreTextView.text = "sentiment: joy"
            } else if sentiment == "love" {
                sentimentImageView.image = UIImage(named: "love")
                sentimentScoreTextView.text = "sentiment: love"
            } else if sentiment == "anger"{
                sentimentImageView.image = UIImage(named: "anger")
                sentimentScoreTextView.text = "sentiment: anger"
            } else if sentiment == "fear" {
                sentimentImageView.image = UIImage(named: "fear")
                sentimentScoreTextView.text = "sentiment: fear"
            } else {
                sentimentImageView.image = UIImage(named: "unknown")
                sentimentScoreTextView.text = "sentiment: unknown"
            }
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
