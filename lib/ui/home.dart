import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class _HomeState extends State<Home> {
  List<dynamic> drivers = [];
  bool isLoading = true;
  dynamic selectedDriver;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    final response = await supabase.from('drivers').select();
    setState(() {
      drivers = response as List<dynamic>;
      if (drivers.isNotEmpty) {
        selectedDriver = drivers[0];
      }
      isLoading = false;
    });
  }

  Future<void> _updateDriverPlace(String placeType) async {
    if (selectedDriver == null) {
      print('No driver selected');
      return;
    }
    final driverId = selectedDriver['id'];
    final currentCount = selectedDriver[placeType] ?? 0;
    await supabase
        .from('drivers')
        .update({placeType: currentCount + 1}).eq('id', driverId);
    print("$placeType updated");
    _fetchDrivers(); // Refresh the list of drivers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drivers'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/011/102/559/small/two-crossed-racing-checkered-flags-png.png',
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                Expanded(child: driverList()),
                _driverSelectionDropdown(),
                _placeButtons(),
                AddDriverButton(onDriverAdded: _fetchDrivers),
              ],
            ),
    );
  }

  Widget driverList() {
    return ListView.builder(
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final driver = drivers[index];
        return ListTile(
          title: Text(driver['name']),
          subtitle: Text(
              '1st: ${driver['first_place'] ?? 0} | 2nd: ${driver['second_place'] ?? 0} | 3rd: ${driver['third_place'] ?? 0}'),
        );
      },
    );
  }

  Widget _driverSelectionDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<dynamic>(
        value: selectedDriver,
        hint: Text('Select a Driver'),
        items: drivers.map<DropdownMenuItem<dynamic>>((driver) {
          return DropdownMenuItem<dynamic>(
            value: driver,
            child: Text(driver['name']),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDriver = value;
          });
        },
      ),
    );
  }

  Widget _placeButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              _updateDriverPlace('first_place');
            },
            child: Text('Add First Place'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateDriverPlace('second_place');
            },
            child: Text('Add Second Place'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateDriverPlace('third_place');
            },
            child: Text('Add Third Place'),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class AddDriverButton extends StatefulWidget {
  final Function onDriverAdded;

  AddDriverButton({required this.onDriverAdded});

  @override
  _AddDriverButtonState createState() => _AddDriverButtonState();
}

class _AddDriverButtonState extends State<AddDriverButton> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addDriverToDatabase(String driverName) async {
    await supabase.from('drivers').insert({
      'name': driverName,
      'first_place': 0,
      'second_place': 0,
      'third_place': 0,
    });
    widget.onDriverAdded();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Add Driver'),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Driver Name',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final driverName = _controller.text;
                    if (driverName.isNotEmpty) {
                      await _addDriverToDatabase(driverName);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Add Driver'),
    );
  }
}
