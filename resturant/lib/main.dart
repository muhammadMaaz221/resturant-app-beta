import 'package:flutter/material.dart';

void main() {
  runApp(const MiniRestoApp());
}

class MiniRestoApp extends StatelessWidget {
  const MiniRestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M&D Restaurant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[800],
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/admin': (context) => const AdminLoginScreen(),
        '/main': (context) => const MainTabScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'M & D Restaurant',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class Order {
  String itemName;
  int quantity;
  double total;
  String status;
  String date;
  bool isApproved;

  Order({
    required this.itemName,
    required this.quantity,
    required this.total,
    required this.status,
    required this.date,
    this.isApproved = false,
  });
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Order> orders = [];
  List<MenuItem> menuItems = [
    MenuItem(name: 'Pizza', price: 1500),
    MenuItem(name: 'Burger', price: 750),
    MenuItem(name: 'Pasta', price: 1050),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addNewOrder(Order newOrder) {
    setState(() {
      orders.insert(0, newOrder);
    });
  }

  void updateOrderStatus(int index, String newStatus, bool isApproved) {
    setState(() {
      orders[index].status = newStatus;
      orders[index].isApproved = isApproved;
    });
  }

  void addMenuItem(MenuItem newItem) {
    setState(() {
      menuItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, color: Colors.amber[300]),
            const SizedBox(width: 12),
            const Text('M & D Restaurant'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.pushNamed(context, '/admin').then((value) {
                if (value != null && value is MenuItem) {
                  addMenuItem(value);
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber[300],
          labelColor: Colors.amber[300],
          unselectedLabelColor: Colors.white.withOpacity(0.8),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard)),
            Tab(icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DashboardTab(
            onAddOrder: addNewOrder,
            orders: orders,
            onUpdateStatus: updateOrderStatus,
            menuItems: menuItems,
          ),
          OrderHistoryTab(orders: orders),
        ],
      ),
    );
  }
}

class MenuItem {
  final String name;
  final double price;

  MenuItem({required this.name, required this.price});
}

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isIncorrectPin = false;

  void _checkPin() {
    if (_pinController.text == '2265') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminScreen(
            onAddMenuItem: (item) {
              Navigator.pop(context, item);
            },
          ),
        ),
      );
    } else {
      setState(() {
        _isIncorrectPin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.green),
            const SizedBox(height: 30),
            const Text(
              'Enter Admin PIN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'PIN',
                errorText: _isIncorrectPin ? 'Incorrect PIN' : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _checkPin,
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminScreen extends StatefulWidget {
  final Function(MenuItem) onAddMenuItem;

  const AdminScreen({super.key, required this.onAddMenuItem});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();

  void _addNewMenuItem() {
    if (_itemNameController.text.isNotEmpty &&
        _itemPriceController.text.isNotEmpty) {
      final newItem = MenuItem(
        name: _itemNameController.text,
        price: double.parse(_itemPriceController.text),
      );
      widget.onAddMenuItem(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu item added successfully!')),
      );

      _itemNameController.clear();
      _itemPriceController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainTabState = context.findAncestorStateOfType<_MainTabScreenState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Menu Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _itemPriceController,
              decoration: const InputDecoration(
                labelText: 'Item Price (PKR)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _addNewMenuItem,
              child: const Text('Add Item', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            const Text(
              'Admin Functions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Restaurant Settings'),
                    onTap: () {
                      // Add settings functionality
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('View Analytics'),
                    onTap: () {
                      // Add analytics functionality
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text('Generate Reports'),
                    onTap: () {
                      // Add reports functionality
                    },
                  ),
                  if (mainTabState != null)
                    ListTile(
                      leading: const Icon(Icons.check_circle),
                      title: const Text('Approve Orders'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderApprovalScreen(
                              orders: mainTabState.orders,
                              onUpdateStatus: mainTabState.updateOrderStatus,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderApprovalScreen extends StatefulWidget {
  final List<Order> orders;
  final Function(int, String, bool) onUpdateStatus;

  const OrderApprovalScreen({
    super.key, 
    required this.orders,
    required this.onUpdateStatus,
  });

  @override
  State<OrderApprovalScreen> createState() => _OrderApprovalScreenState();
}

class _OrderApprovalScreenState extends State<OrderApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    final pendingOrders = widget.orders.where((order) => !order.isApproved && order.status == 'Pending Approval').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders Approval'),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: pendingOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    'No Pending Orders',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  const Text('All orders have been processed'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
                final originalIndex = widget.orders.indexOf(order);
                
                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.itemName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                'PKR ${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green[800],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Quantity: ${order.quantity}'),
                        Text('Date: ${order.date}'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.close, color: Colors.red),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                              ),
                              onPressed: () {
                                _showRejectConfirmation(context, originalIndex);
                              },
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                              ),
                              onPressed: () {
                                widget.onUpdateStatus(originalIndex, 'Approved', true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order approved successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showRejectConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onUpdateStatus(index, 'Rejected', false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order rejected'),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatefulWidget {
  final Function(Order) onAddOrder;
  final List<Order> orders;
  final Function(int, String, bool) onUpdateStatus;
  final List<MenuItem> menuItems;

  const DashboardTab({
    super.key,
    required this.onAddOrder,
    required this.orders,
    required this.onUpdateStatus,
    required this.menuItems,
  });

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  int get totalOrders => widget.orders.length;

  double get totalEarnings {
    return widget.orders
        .where((order) => order.isApproved)
        .fold(0, (sum, order) => sum + order.total);
  }

  int get pendingOrders {
    return widget.orders.where((order) => !order.isApproved && order.status == 'Pending Approval').length;
  }

  void _showNewOrderDialog(BuildContext context) {
    if (widget.menuItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No menu items available. Please add some in admin panel.')),
      );
      return;
    }

    String selectedItem = widget.menuItems.first.name;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Order'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedItem,
                    items: widget.menuItems
                        .map((item) => DropdownMenuItem(
                              value: item.name,
                              child: Text(
                                  '${item.name} (PKR ${item.price.toStringAsFixed(2)})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Menu Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      quantity = int.tryParse(value) ?? 1;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final selectedMenuItem = widget.menuItems
                        .firstWhere((item) => item.name == selectedItem);
                    final newOrder = Order(
                      itemName: selectedItem,
                      quantity: quantity,
                      total: selectedMenuItem.price * quantity,
                      status: 'Pending Approval',
                      date: DateTime.now().toString().substring(0, 16),
                      isApproved: false,
                    );
                    widget.onAddOrder(newOrder);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully! It will be marked as completed after admin approval.')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Place Order'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewOrderDialog(context),
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.restaurant, size: 40, color: Colors.green[800]),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to M & D Restaurant!',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Manage your orders efficiently',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    totalOrders.toString(),
                    Icons.receipt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Total Earnings',
                    'PKR ${totalEarnings.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending Approval',
                    pendingOrders.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.orders.isEmpty
                  ? const Center(
                      child: Text('No orders yet. Place your first order!'),
                    )
                  : ListView.builder(
                      itemCount: widget.orders.length,
                      itemBuilder: (context, index) {
                        final order = widget.orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.fastfood),
                            title: Text(order.itemName),
                            subtitle: Text(
                                'Qty: ${order.quantity} | PKR ${order.total.toStringAsFixed(2)}'),
                            trailing: Chip(
                              label: Text(
                                order.status == 'Rejected' ? 'Rejected' : 
                                order.isApproved ? 'Approved' : 'Pending',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: order.status == 'Rejected' 
                                  ? Colors.red[100] 
                                  : order.isApproved 
                                      ? Colors.green[100] 
                                      : Colors.orange[100],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Icon(icon, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderHistoryTab extends StatelessWidget {
  final List<Order> orders;

  const OrderHistoryTab({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: orders.isEmpty
                ? const Center(
                    child: Text('No order history available'),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(order.itemName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Qty: ${order.quantity}'),
                              Text('Total: PKR ${order.total.toStringAsFixed(2)}'),
                              Text('Date: ${order.date}'),
                              Text('Status: ${order.status}'),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              order.status == 'Rejected' ? 'Rejected' : 
                              order.isApproved ? 'Approved' : 'Pending',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: order.status == 'Rejected' 
                                ? Colors.red[100] 
                                : order.isApproved 
                                    ? Colors.green[100] 
                                    : Colors.orange[100],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}