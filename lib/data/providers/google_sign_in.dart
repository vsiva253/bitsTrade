// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:in_app_webview/in_app_webview.dart'; // Import in_app_webview package

// class GoogleSignIn {
//   final String clientId;
//   final String clientSecret;
//   final String redirectUri;
//   final BuildContext context;

//   GoogleSignIn(this.context, {
//     required this.clientId,
//     required this.clientSecret,
//     required this.redirectUri,
//   });

//   Future<String?> signIn() async {
//     // 1. Create the Google login URL
//     final authorizationUrl = Uri.https(
//       'accounts.google.com',
//       'o/oauth2/v2/auth',
//       {
//         'client_id': clientId,
//         'redirect_uri': redirectUri,
//         'response_type': 'code',
//         'scope': 'profile email',
//       },
//     ).toString();

//     // 2. Try to open the URL in a web browser
//     if (await canLaunch(authorizationUrl)) {
//       await launch(authorizationUrl);
//       // Assume the user completes the login in the browser
//       // This step requires a custom URL scheme to redirect back to the app
//       return null; // Return null or a specific message to indicate browser usage
//     } else {
//       // If unable to launch the browser, fall back to WebView
//       return await Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => WebViewPage(authorizationUrl, redirectUri),
//         ),
//       );
//     }
//   }
// }

// class WebViewPage extends StatefulWidget {
//   final String authorizationUrl;
//   final String redirectUri;

//   WebViewPage(this.authorizationUrl, this.redirectUri);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late InAppWebViewController _webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign In'),
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: Uri.parse(widget.authorizationUrl)),
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (controller) {
//           _webViewController = controller;
//         },
//         navigationDelegate: (navigation) {
//           if (navigation.url.startsWith(widget.redirectUri)) {
//             // Extract the authorization code from the URL
//             final code = Uri.parse(navigation.url).queryParameters['code'];
//             Navigator.of(context).pop(code);
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignInPage(),
//     );
//   }
// }

// class SignInPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Google Sign In Example')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final googleSignIn = GoogleSignIn(
//               context,
//               clientId: 'YOUR_CLIENT_ID',
//               clientSecret: 'YOUR_CLIENT_SECRET',
//               redirectUri: 'YOUR_REDIRECT_URI',
//             );

//             final code = await googleSignIn.signIn();
//             if (code != null) {
//               // Exchange the authorization code for an access token
//               final response = await http.post(
//                 Uri.parse('https://oauth2.googleapis.com/token'),
//                 body: {
//                   'client_id': googleSignIn.clientId,
//                   'client_secret': googleSignIn.clientSecret,
//                   'code': code,
//                   'grant_type': 'authorization_code',
//                   'redirect_uri': googleSignIn.redirectUri,
//                 },
//               );

//               if (response.statusCode == 200) {
//                 // Successfully received the access token
//                 print('Access Token: ${response.body}');
//               } else {
//                 // Failed to get the access token
//                 print('Failed to get access token: ${response.body}');
//               }
//             }
//           },
//           child: Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }