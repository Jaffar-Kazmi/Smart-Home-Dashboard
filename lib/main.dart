import 'package:flutter/material.dart';

void main() => runApp(const SmartHomeApp());

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class Device {
  String name;
  String type;
  String room;
  bool isOn;
  double value;

  Device({
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.value = 50,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Device> devices = [
    Device(name: "Living Room Light", type: "Light", room: "Living Room"),
    Device(name: "Bedroom Fan", type: "Fan", room: "Bedroom"),
    Device(name: "Air Conditioner", type: "AC", room: "Bedroom"),
    Device(name: "Security Camera", type: "Camera", room: "Entrance"),
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case "Light":
        return Icons.lightbulb;
      case "Fan":
        return Icons.toys;
      case "AC":
        return Icons.ac_unit;
      case "Camera":
        return Icons.videocam;
      default:
        return Icons.device_unknown;
    }
  }

  void _addDeviceDialog() {
    String name = '';
    String room = '';
    String type = 'Light';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Device"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: "Device Name"),
                  onChanged: (v) => name = v,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Room Name"),
                  onChanged: (v) => room = v,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: type,
                  items: ["Light", "Fan", "AC", "Camera"]
                      .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setStateDialog(() => type = v!),
                  decoration: const InputDecoration(labelText: "Device Type"),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty && room.isNotEmpty) {
                setState(() {
                  devices.add(Device(name: name, type: type, room: room));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add Device"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Smart Home Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDeviceDialog,
        label: const Text("Add Device"),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: devices.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 3 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isWide ? 1.2 : 1,
          ),
          itemBuilder: (context, index) {
            final device = devices[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceDetailsScreen(device: device),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: device.isOn ? Colors.teal[50] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: device.isOn
                          ? Colors.teal.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: device.name,
                      child: Icon(
                        _getIcon(device.type),
                        size: 40,
                        color:
                        device.isOn ? Colors.teal : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      device.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Switch(
                      value: device.isOn,
                      onChanged: (v) =>
                          setState(() => device.isOn = v),
                      activeColor: Colors.teal,
                    ),
                    Text(
                      device.isOn ? "Device is ON" : "Device is OFF",
                      style: TextStyle(
                        fontSize: 13,
                        color: device.isOn
                            ? Colors.teal
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;
  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  IconData _getIcon(String type) {
    switch (type) {
      case "Light":
        return Icons.lightbulb;
      case "Fan":
        return Icons.toys;
      case "AC":
        return Icons.ac_unit;
      case "Camera":
        return Icons.videocam;
      default:
        return Icons.device_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    double sliderMax = device.type == "Fan" ? 5 : 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Hero(
                tag: device.name,
                child: Icon(
                  _getIcon(device.type),
                  size: 120,
                  color: device.isOn ? Colors.teal : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Status: ${device.isOn ? "ON" : "OFF"}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: device.type == "Light" || device.type == "Fan"
                    ? Column(
                  key: ValueKey(device.type),
                  children: [
                    Text(
                      device.type == "Light"
                          ? "Brightness"
                          : "Fan Speed",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      min: 0,
                      max: sliderMax,
                      divisions: sliderMax.toInt(),
                      value: device.value,
                      activeColor: Colors.teal,
                      onChanged: (value) {
                        setState(() => device.value = value);
                      },
                    ),
                    Text(
                      device.type == "Light"
                          ? "${device.value.toInt()}%"
                          : "${device.value.toInt()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                )
                    : const SizedBox(),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => device.isOn = !device.isOn);
                },
                icon: Icon(
                  device.isOn ? Icons.power_settings_new : Icons.power,
                ),
                label: Text(
                  device.isOn ? "Turn OFF" : "Turn ON",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  device.isOn ? Colors.redAccent : Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
