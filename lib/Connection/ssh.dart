// TODO 2: Import 'dartssh2' package
import 'package:dartssh2/dartssh2.dart';
import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  // Initialize connection details from shared preferences
  initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';

    return {
      "ip": _host,
      "pass": _passwordOrKey,
      "port": _port,
      "username": _username,
      "numberofrigs": _numberOfRigs
    };
  }

  // Connect to the Liquid Galaxy system
  Future<bool?> connectToLG() async {
    await initConnectionDetails();

    try {
      // TODO 3: Connect to Liquid Galaxy system, using examples from https://pub.dev/packages/dartssh2#:~:text=freeBlocks%7D%27)%3B-,%F0%9F%AA%9C%20Example%20%23,-SSH%20client%3A
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
      print('IP: $_host, port: $_port');
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  Future<SSHSession?> execute() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      //   TODO 4: Execute a demo command: echo "search=" > /tmp/query.txt
      final execResult =
      await _client!.execute('echo "search=IIT Kanpur" > /tmp/query.txt');
      print('Execution okay');
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  // DEMO above, all the other functions below
//   TODO 11 UNDONE: Make functions for each of the tasks in the home screen
  Future<SSHSession?> relaunchLG() async {
    try {
      if (_client == null) {
        print('ssh client not initialized.');
        return null;
      }
      for (int i = int.parse(_numberOfRigs); i > 0; i--) {
        await _client!.execute("""RELAUNCH_CMD="\\
    if [ -f /etc/init/lxdm.conf ]; then
      export SERVICE=lxdm
    elif [ -f /etc/init/lightdm.conf ]; then
      export SERVICE=lightdm
    else
      exit 1
    fi
    if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
      echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
    else
      echo  echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
    fi
    " && sshpass -p $_passwordOrKey ssh -x -t lg@lg1 "\$RELAUNCH_CMD\"""");
      }
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

// for (int i = int.parse(_numberOfRigs); i > 0; i--) {
//         await _client!.execute(
//             'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff" ');
//       }
//       return null;
  Future<SSHSession?> clearKML() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      String KML = '';
      final execResult = await _client!.execute(
          "echo '$KML' > /var/www/html/kml/lg_3.kml"); //#TODO22 : change slave_3 to lg3
      print(
          "chmod 777 /var/www/html/kmls.txt; echo '$KML' > /var/www/html/kml/lg3.kml");
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> sendKML() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      double factor = 300 * (6190 / 6054);
      String KML = '''
      <kml xmlns="http://www.opengis.net/kml/2.2"
      xmlns:atom="http://www.w3.org/2005/Atom"
      xmlns:gx="http://www.google.com/kml/ext/2.2">
      <Document>
      <Folder>
      <name>Logos</name>
      <ScreenOverlay>
      <name>Logos</name>
      <Icon>
      <href>https://raw.githubusercontent.com/vedantkingh/Located-Voice-CMS/master/app/src/main/res/drawable/logos.png</href>
      </Icon>
      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.95" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <sizex="300"y="$factor" xunits="pixels" yunits="pixels"/>
      </ScreenOverlay>
      </Folder>
       </Document>
       </kml>
       ''';
      final execResult =
      await _client!.execute("echo '$KML' > /var/www/html/kml/lg3.kml");
      print(
          "chmod 777 /var/www/html/kmls.txt; echo '$KML' > /var/www/html/kml/lg3.kml");
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> searchPlace(String place) async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      final execResult =
      await _client!.execute('echo "search=$place" > /tmp/query.txt');
      print("Execution okay!");
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> shutdownLG() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      for (int i = int.parse(_numberOfRigs); i > 0; i--) {
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff" ');
      }
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> rebootLG() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      for (int i = int.parse(_numberOfRigs); i > 0; i--) {
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot" ');
        print(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot" ');
      }
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  startorbitLG() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }

      final res =
      await _client!.execute('echo "playtour=Orbit" > /tmp/query.txt');
      print('ok');
      return res;
    } catch (e) {
      print('An error occurred while executing the command: $e');

      return null;
    }
  }

// onPressed: () async {
//     await _saveSettings();
//     // TODO 6: Initialize SSH Instance and call connectToLG() function
//     SSH ssh = SSH();

//     try {
//       bool? result = await ssh.connectToLG();
//       if (result == true) {
//         // Successful connection
//         // Do something if needed
//       } else {
//         // This block will not execute if there's an exception
//         final scaffold = ScaffoldMessenger.of(context);
//         scaffold.showSnackBar(
//           SnackBar(
//             content: Text('Failed to connect. Check your connection details.'),
//           ),
//         );
//       }
//     } catch (error) {
//       // Catch any exception and display the exact error message
//       final scaffold = ScaffoldMessenger.of(context);
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text('Error: $error'),
//         ),
//       );
//     }
//   },
  Future<SSHSession?> stoporbitLG() async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      await _client!.execute('echo "exittour=true" > /tmp/query.txt');
      print("OKAY!");
      return null;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
  //  _getCredentials() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String ipAddress = preferences.getString('master_ip') ?? '';
  //   String password = preferences.getString('master_password') ?? '';
  //   String portNumber = preferences.getString('master_portNumber') ?? '';
  //   String username = preferences.getString('master_username') ?? '';
  //   String numberofrigs = preferences.getString('numberofrigs') ?? '';

  //   return {
  //     "ip": ipAddress,
  //     "pass": password,
  //     "port": portNumber,
  //     "username": username,
  //     "numberofrigs": numberofrigs
  //   };

  // }
  stopOrbit() async {
    await initConnectionDetails();

    // SSHClient client = SSHClient(
    //   host: '${credencials['ip']}',
    //   port: int.parse('${credencials['port']}'),
    //   username: '${credencials['username']}',
    //   _passwordOrKey: '${credencials['pass']}',
    // );
    await SSHSocket.connect(_host, int.parse(_port));
    //SSHClient client = SSHClient(socket, username: _username);

    try {
      return await _client!.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }

    // final socket = await SSHSocket.connect(_host, int.parse(_port));

    // _client = SSHClient(
    //   socket,
    //   username: _username,
    //   onPasswordRequest: () => _passwordOrKey,
    // );
    // print('IP: $_host, port: $_port');
    // try {
    //   // TODO 3: Connect to Liquid Galaxy system, using examples from https://pub.dev/packages/dartssh2#:~:text=freeBlocks%7D%27)%3B-,%F0%9F%AA%9C%20Example%20%23,-SSH%20client%3A
    //   //await _client!.connect();
    //   await SSHSocket.connect(_host, int.parse(_port));
    //   return await _client!.execute('echo "exittour=true" > /tmp/query.txt');
    // } on SocketException catch (e) {
    //   print('Failed to connect: $e');
    //   return false;
    // }
  }

  setRefreshLG() async {
    await initConnectionDetails();
    try {
      const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
      const replace =
          '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
      final command =
          'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

      final clear =
          'echo $_passwordOrKey | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';
      await SSHSocket.connect(_host, int.parse(_port));

      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        final clearCmd = clear.replaceAll('{{slave}}', i.toString());
        final cmd = command.replaceAll('{{slave}}', i.toString());
        String query = 'sshpass -p $_passwordOrKey ssh -t lg$i \'{{cmd}}\'';

        await _client!.execute(query.replaceAll('{{cmd}}', clearCmd));
        await _client!.execute(query.replaceAll('{{cmd}}', cmd));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  resetRefreshLG() async {
    await initConnectionDetails();
    try {
      const search =
          '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
      const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

      final clear =
          'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';
      await SSHSocket.connect(_host, int.parse(_port));

      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        final cmd = clear.replaceAll('{{slave}}', i.toString());
        String query = 'sshpass -p $_passwordOrKey ssh -t lg$i \'$cmd\'';

        await _client!.execute(query);
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  Future flyto(double lat, double lng) async {
    try {
      if (_client == null) {
        print('ssh client is not initialized.');
        return null;
      }
      double factor = 300 * (6190 / 6054);
      String KML = '''
      <?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2">
      <Placemark>
      <LookAt>
      <longitude>${lng}</longitude>
      <latitude>${lat}</latitude>
      <altitude>0</altitude>
      <heading>0</heading>
      <tilt>0</tilt>
      <range>1000</range>
      </LookAt>
      </Placemark>
      </kml>
      ''';
      final execResult =
      await _client!.execute("echo '$KML' > /var/www/html/kml/lg3.kml");
      print(
          "chmod 777 /var/www/html/kmls.txt; echo '$KML' > /var/www/html/kml/lg3.kml");
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
}
// 'echo "exittour=true" > /tmp/query.txt'
late String _host;
late String _port;
late String _username;
late String _passwordOrKey;
late String _numberOfRigs;
SSHClient? _client;

// Initialize connection details from shared preferences
Future<void> initConnectionDetails() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  _host = prefs.getString('ipAddress') ?? 'default_host';
  _port = prefs.getString('sshPort') ?? '22';
  _username = prefs.getString('username') ?? 'lg';
  _passwordOrKey = prefs.getString('password') ?? 'lg';
  _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
}

// Connect to the Liquid Galaxy system
Future<bool?> connectToLG() async {
  await initConnectionDetails();

  try {
    // TODO 3: Connect to Liquid Galaxy system, using examples from https://pub.dev/packages/dartssh2#:~:text=freeBlocks%7D%27)%3B-,%F0%9F%AA%9C%20Example%20%23,-SSH%20client%3A
    final socket = await SSHSocket.connect(_host, int.parse(_port));
    _client = SSHClient(
      socket,
      username: _username,
      onPasswordRequest: () => _passwordOrKey,
    );
    print('IP: $_host,port: $_port');
    return true;
  } on SocketException catch (e) {
    print('Failed to connect: $e');
    return false;
  }
}

Future<SSHSession?> execute() async {
  try {
    if (_client == null) {
      print('SSH client is not initialized.');
      return null;
    }
    //   TODO 4: Execute a demo command: echo "search=Lleida" >/tmp/query.txt
    final execResult = await _client!.execute('echo "search= IIT Kanpur" >/tmp/query.txt');
    return execResult;
  } catch (e) {
    print('An error occurred while executing the command: $e');
    return null;
  }
}
