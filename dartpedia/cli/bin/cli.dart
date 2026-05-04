import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) async {
  var runner = CommandRunner(); //Create an instance of the CommandRunner class
  await runner.run(arguments); //Call its run method and, awaiting its Future<void>
  
}

void searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  //if the user didn't provide an article title as an argument, prompt them to enter one
  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title to search for.');
    final inputFromStdin = stdin.readLineSync(); //Read input from stdin
    if (inputFromStdin == null || inputFromStdin.trim().isEmpty) {
      print('Error: No article title provided. Exiting.');
      return; // Exit if no valid input is provided
    }
    articleTitle = inputFromStdin;
    // add error handling for null input
  } else {
    //otherwise, join the arguments to form the article title
    articleTitle = arguments.join(' ');
  }

  print('Looking up articles about "$articleTitle". Please wait...');
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent); // Print the article content to the console (raw JSON response for now)

}

void printUsage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE_TITLE>'"
  );
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  }

    return 'Error: Failed to load article: "$articleTitle"  Status code: ${response.statusCode}';
  
}