import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'gemini_service.dart';

/// Service responsible for handling Optical Character Recognition (OCR) 
/// to extract text from physical receipts and bills.
class OCRService {

  /// Processes an image file using Google ML Kit's Text Recognizer.
  /// After extracting the raw text locally on the device, it delegates 
  /// the unstructured text to Gemini AI to format it into structured JSON data.
  static Future<Map<String, dynamic>?> scanReceipt(File imageFile) async {
    try {
      // 1. Process image locally to ensure data privacy and faster extraction
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      await textRecognizer.close();

      String rawText = recognizedText.text;
      
      if (rawText.trim().isEmpty) {
        return null; // Return early if no text is found in the image
      }

      // 2. Delegate to Generative AI to parse unstructured string into deterministic JSON
      final structuredData = await GeminiService.parseReceipt(rawText);
      return structuredData;
    } catch (e) {
      print("Error in OCR Scan: $e");
      return null;
    }
  }
}
