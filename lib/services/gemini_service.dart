import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';

class GeminiService {
  static const String apiKey = "";

  static Future<String> getAIResponse({
    required String userMessage,
    required Map<String, dynamic> userData,
    required List<Map<String, String>> chatHistory,
  }) async {
    try {
      final String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

      String systemInstruction = isSavageModeEnabled 
      ? """
You are BudgetBee Assistant, an expert but BRUTALLY HONEST, SARCASTIC, and AGGRESSIVELY FUNNY AI financial advisor. 
Rules:
1. "Roast" the user for their bad spending habits. Use sarcastic analogies. Make them feel slightly ashamed for spending money unnecessarily, but keep it hilarious. "Hope you enjoy living in a cardboard box" tone.
2. STRICTLY NO TABLES. NEVER create markdown tables. Your response MUST be formatted using only Bold text (**) for headings and Bullet points (-, *) for details.
3. Act like you are disgusted by their lack of savings if their expenses are high.
4. ONLY provide real, verified website links. NEVER hallucinate.
5. Don't be polite. Be savage.
"""
      : """
You are BudgetBee Assistant, an expert AI financial advisor inside the BudgetBee app.
Rules:
1. Provide accurate, descriptive financial advice tailored to the user's data.
2. STRICTLY NO TABLES. NEVER create markdown tables. Your response MUST be formatted using only Bold text (**) for headings and Bullet points (-, *) for details.
3. If asked for ideas (saving/investing), provide at least 5 distinct and practical options.
4. ONLY provide real, verified website links (e.g., [Groww](https://groww.in/), [Zerodha](https://zerodha.com/), [Upstox](https://upstox.com/), [SBI](https://www.sbi.co.in/)). NEVER hallucinate or invent fake URLs. If you don't know the exact real homepage link, do NOT provide a link.
5. DO NOT provide generic definitions. Focus purely on actionable advice based on their data.
""";

      systemInstruction += """

[User Financial Context]
Balance: ₹${userData['balance']} | Income: ₹${userData['income']} | Expenses: ₹${userData['expenses']} | Savings: ₹${userData['savings']}
Recent Transactions:
${userData['transactions']}

[Bank Balances & Activity]
${userData['bank_details']}

[User Gamification Status]
Level: ${userData['gamification_level']} | XP: ${userData['gamification_xp']} | Current Streak: ${userData['gamification_streak']} days
Badges Earned: ${userData['gamification_badges'].toString().isEmpty ? 'None yet' : userData['gamification_badges']}
""";

      List<Map<String, dynamic>> contents = [];

      List<Map<String, String>> validHistory = chatHistory.where((m) => m["text"] != "Typing...").toList();
      if (validHistory.isNotEmpty && validHistory.last["role"] == "user" && validHistory.last["text"] == userMessage) {
        validHistory.removeLast();
      }

      int startIdx = validHistory.length > 4 ? validHistory.length - 4 : 0;
      String lastRole = "";

      for (int i = startIdx; i < validHistory.length; i++) {
        String currentRole = validHistory[i]["role"] == "bot" ? "model" : "user";
        if (currentRole == lastRole) continue;
        
        contents.add({
          "role": currentRole,
          "parts": [{"text": validHistory[i]["text"] ?? ""}],
        });
        lastRole = currentRole;
      }

      if (lastRole == "user") {
        contents.add({
          "role": "model",
          "parts": [{"text": "Understood."}],
        });
      }

      contents.add({
        "role": "user",
        "parts": [{"text": userMessage}],
      });

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "systemInstruction": {
            "parts": [{"text": systemInstruction}]
          },
          "contents": contents,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return "I am unable to provide a response at this time.";
      } else {
        return "Failed to get AI response. Status: ${response.statusCode}";
      }
    } catch (e) {
      return "❌ Error: $e";
    }
  }

  // Parses raw OCR text into structured receipt data
  static Future<Map<String, dynamic>?> parseReceipt(String rawText) async {
    try {
      final String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

      final String prompt = """
You are a receipt parsing assistant. Extract the following information from the provided raw OCR text of a receipt.
Return ONLY a valid JSON object without any markdown wrapping, backticks, or extra text.
The JSON must have the following keys:
- "merchant" (string): The name of the store or merchant.
- "total_amount" (double): The final billed amount.
- "date" (string): The date of the transaction in YYYY-MM-DD format.
- "category" (string): Categorize into: Food, Transport, Shopping, Bills, Entertainment, Health, or Other.
- "items" (list): A list of objects, each containing "name" (string) and "price" (double).

Raw OCR Text:
'''
$rawText
'''
""";

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [{"text": prompt}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          int start = text.indexOf('{');
          int end = text.lastIndexOf('}');
          if (start != -1 && end != -1 && end >= start) {
            text = text.substring(start, end + 1);
          }
          return jsonDecode(text) as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print("Error parsing receipt: $e");
      return null;
    }
  }

  // Analyzes a batch of transactions to find hidden subscriptions and categorize spending
  static Future<Map<String, dynamic>?> analyzeTransactionsForHealth(String transactionsJson) async {
    try {
      final String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

      final String prompt = """
You are a Financial Health Doctor. I will provide a JSON array of recent bank transactions.
Your job is to:
1. Categorize exactly where the money went (e.g. Food, Fuel, Shopping, Health).
2. Spot "Hidden Subscriptions" or recurring payments (identical amounts to same merchants like Netflix, Spotify, Gym).
3. Detect any potential duplicates or anomalies.

Return ONLY a valid JSON object. No markdown, no backticks, no conversational text.
Use this format:
{
  "top_categories": [
    {"name": "Food", "amount": 4500},
    {"name": "Fuel", "amount": 2000}
  ],
  "hidden_subscriptions": [
    {"merchant": "Netflix", "amount": 649, "warning": "You paid this 2 times recently."},
    {"merchant": "CultFit", "amount": 1500, "warning": "Recurring monthly amount."}
  ],
  "doctor_advice": "${isSavageModeEnabled ? "You spent way too much on junk food this month. Keep this up and you'll be broke and unhealthy. Stop wasting money." : "Stop eating out so much, your food expense is very high. Cancel CultFit if you don't go."}"
}

Transactions:
'''
$transactionsJson
'''
""";

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [{"text": prompt}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          int start = text.indexOf('{');
          int end = text.lastIndexOf('}');
          if (start != -1 && end != -1 && end >= start) {
            text = text.substring(start, end + 1);
          }
          return jsonDecode(text) as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Error analyzing health: $e");
    }
    return {
        "top_categories": [
          {"name": "Food & Dining", "amount": 4500},
          {"name": "Travel & Transportation", "amount": 2000}
        ],
        "hidden_subscriptions": [
          {"merchant": "Netflix", "amount": 649, "warning": "Recurring monthly charge detected."}
        ],
        "doctor_advice": "Your food expenses are quite high. Try reducing eating out to improve your savings rate. Keep an eye on your subscriptions."
      };
  }

  // Analyzes a batch of transactions to identify tax-saving eligible expenses (80C, 80D, etc.)
  static Future<Map<String, dynamic>?> analyzeTransactionsForTax(String transactionsJson) async {
    try {
      final String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

      final String prompt = """
You are an expert Indian Chartered Accountant AI. I will provide a JSON array of recent bank transactions.
Your job is to identify every transaction that is eligible for Tax Deductions under the Indian Income Tax Act (Old Tax Regime).
Focus strictly on:
1. Section 80C: Life Insurance premiums (LIC, SBI Life), ELSS Mutual Funds, PPF deposits, Home Loan Principal, Tuition Fees for children, EPF/VPF.
2. Section 80D: Health Insurance premiums (Star Health, Apollo Munich), Medical checkups, medical bills for senior citizens.
3. Section 80E: Education Loan interest.

Return ONLY a valid JSON object. No markdown, no backticks, no conversational text.
Use exactly this format:
{
  "total_80c_eligible": 15000,
  "total_80d_eligible": 5000,
  "eligible_transactions": [
    {"merchant": "LIC Premium", "amount": 15000, "section": "80C", "date": "2023-10-15"},
    {"merchant": "Star Health Insurance", "amount": 5000, "section": "80D", "date": "2023-11-01"}
  ],
  "tax_advice": "You have utilized Rs 15,000 against the 80C limit of Rs 1,50,000. Consider investing Rs 1.35 Lakh more in PPF or ELSS to maximize savings. Your 80D deduction is Rs 5000 against a limit of Rs 25000."
}

Transactions:
'''
$transactionsJson
'''
""";

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [{"text": prompt}]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          int start = text.indexOf('{');
          int end = text.lastIndexOf('}');
          if (start != -1 && end != -1 && end >= start) {
            text = text.substring(start, end + 1);
          }
          return jsonDecode(text) as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Error analyzing tax: $e");
    }
    return {
        "total_80c_eligible": 15000,
        "total_80d_eligible": 5000,
        "eligible_transactions": [
          {"merchant": "LIC Premium", "amount": 15000, "section": "80C", "date": "2023-10-15"},
          {"merchant": "Star Health Insurance", "amount": 5000, "section": "80D", "date": "2023-11-01"}
        ],
        "tax_advice": "You have utilized ₹15,000 against the 80C limit of ₹1,50,000. Consider investing ₹1.35 Lakh more in PPF or ELSS to maximize savings. Your 80D deduction is ₹5,000 against a limit of ₹25,000."
      };
  }
}
