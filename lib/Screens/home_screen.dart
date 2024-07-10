import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'package:first/Components/connection_flag.dart';
import 'package:first/Connection/ssh.dart';

class MyButton extends StatelessWidget {
  final String buttonText;

  MyButton(this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: ElevatedButton(
        onPressed: () async {
          // Handle button press
          if (buttonText == 'Search') {
            await _handleSearchButtonPress(context);
          } else {
            await handleButtonPress(context, buttonText);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: getButtonColor(buttonText),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
        child: Text(buttonText),
      ),
    );
  }

  Future<void> handleButtonPress(BuildContext context, String buttonText) async {
    // Display a confirmation dialog for warning buttons
    if (isWarningButton(buttonText)) {
      bool confirm = await showWarningDialog(context, buttonText);
      if (!confirm) {
        return;
      }
    }

    SSH ssh = SSH(); // Assuming you have an instance of SSH

    // Ensure connection before executing other commands
    bool? isConnected = await ssh.connectToLG();
    if (isConnected == null) {
      // Handle connection failure
      return;
    }

    switch (buttonText) {
      case 'Relaunch LG':
        await ssh.relaunchLG();
        break;
      case 'Clean KML':
        await ssh.clearKML();
        break;
      case 'Shutdown LG':
        await ssh.shutdownLG();
        break;
      case 'Reboot LG':
        await ssh.rebootLG();
        break;
      case 'Send KML':
        await ssh.sendKML();
        break;
      default:
        break;
    }
  }

  Future<void> _handleSearchButtonPress(BuildContext context) async {
    // Show a dialog to get the search query
    TextEditingController searchController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Search Query'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Enter your search query',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              String searchQuery = searchController.text;
              if (searchQuery.isNotEmpty) {
                SSH ssh = SSH(); // Assuming you have an instance of SSH
                bool? isConnected = await ssh.connectToLG();
                if (isConnected == null) {
                  // Handle connection failure
                  return;
                }
                await ssh.searchPlace(searchQuery);
                // await ssh.startorbitLG();
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  bool isWarningButton(String buttonText) {
    return buttonText == 'Relaunch LG' ||
        buttonText == 'Reboot LG' ||
        buttonText == 'Shutdown LG';
  }

  Color getButtonColor(String buttonText) {
    return isWarningButton(buttonText) ? Colors.red : Colors.blue;
  }

  Future<bool> showWarningDialog(BuildContext context, String buttonText) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Warning'),
        content: Text('Are you sure you want to $buttonText?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancel
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirm
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liquid Galaxy App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/low-angle-shot-mesmerizing-starry-sky.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/LIQUIDGALAXYLOGO.png',
                    width: 600,
                    height: 300,
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButton('Relaunch LG'),
                          MyButton('Clean KML'),
                          MyButton('Search'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButton('Shutdown LG'),
                          MyButton('Reboot LG'),
                          MyButton('Send KML'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        child: Icon(Icons.settings),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

