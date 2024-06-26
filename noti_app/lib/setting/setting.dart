import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti_app/bottom_navigator/bottom_navigator.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const SettingPage(title: 'Ứng Dụng'),
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});
  final String title;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<List<dynamic>> _notifications = [];
  bool isSwitchedTeams = true;
  bool isSwitchedOutlook = true;
  bool isSwitchedQLDT = true;
  bool isSwitchedeHUST = true;

  @override
  void initState() {
    super.initState();
    _loadCSV();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitchedTeams = prefs.getBool('showTeams') ?? true;
      isSwitchedOutlook = prefs.getBool('showOutlook') ?? true;
      isSwitchedQLDT = prefs.getBool('showQLDT') ?? true;
      isSwitchedeHUST = prefs.getBool('showEhust') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showTeams', isSwitchedTeams);
    prefs.setBool('showOutlook', isSwitchedOutlook);
    prefs.setBool('showQLDT', isSwitchedQLDT);
    prefs.setBool('showEhust', isSwitchedeHUST);
  }

  Future<void> _loadCSV() async {
    final data = await rootBundle.loadString('assets/data.csv');
    final List<List<dynamic>> csvTable = CsvToListConverter().convert(data);
    setState(() {
      _notifications = csvTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          print("Tapped on index $index");
        },
      ),
      body: Container(
        padding: EdgeInsets.all(35),
        child: Column(
          children: [
            Container(
              child: Text(
                'Bật tắt ứng dụng thông báo',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 35),
            _buildSwitchRow('Teams', isSwitchedTeams, (value) {
              setState(() {
                isSwitchedTeams = value;
                _savePreferences();
              });
            }),
            SizedBox(height: 20),
            _buildSwitchRow('Outlook', isSwitchedOutlook, (value) {
              setState(() {
                isSwitchedOutlook = value;
                _savePreferences();
              });
            }),
            SizedBox(height: 20),
            _buildSwitchRow('QLDT', isSwitchedQLDT, (value) {
              setState(() {
                isSwitchedQLDT = value;
                _savePreferences();
              });
            }),
            SizedBox(height: 20),
            _buildSwitchRow('eHUST', isSwitchedeHUST, (value) {
              setState(() {
                isSwitchedeHUST = value;
                _savePreferences();
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String text, bool value, Function(bool) onChanged) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 218, 214, 198),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          _getLeadingIcon(text),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  Widget _getLeadingIcon(String title) {
    switch (title) {
      case 'eHUST':
        return Image.asset("assets/images/ehust.png", width: 50, height: 50);
      case 'Teams':
        return Image.asset("assets/images/teams.png", width: 50, height: 50);
      case 'Outlook':
        return Image.asset("assets/images/outlook.png", width: 50, height: 50);
      case 'QLDT':
        return Image.asset("assets/images/hust.png", width: 50, height: 50);
      default:
        return Icon(Icons.notifications);
    }
  }
}