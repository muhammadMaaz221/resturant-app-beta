import 'package:flutter/material.dart';
import 'SplashScreen.dart';

void main() {
  runApp(const MiniRestoApp());
}

class MiniRestoApp extends StatelessWidget {
  const MiniRestoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniResto',
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
    );
  }
}

// Rest of your existing code remains the same...
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
    MenuItem(name: 'Pizza', price: 500, category: 'Main Course'),
    MenuItem(name: 'Burger', price: 250, category: 'Fast Food'),
    MenuItem(name: 'Biryani', price: 300, category: 'Main Course'),
    MenuItem(name: 'Pasta', price: 350, category: 'Italian'),
    MenuItem(name: 'Salad', price: 200, category: 'Healthy'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void addOrder(Order order) {
    setState(() {
      orders.add(order);
    });
    _tabController.animateTo(1); // Switch to orders tab
  }

  void updateOrderStatus(int index) {
    setState(() {
      orders[index] = orders[index].copyWith(status: 'Completed');
    });
  }

  void addMenuItem(MenuItem item) {
    setState(() {
      menuItems.add(item);
    });
  }

  void updateMenuItem(int index, MenuItem item) {
    setState(() {
      menuItems[index] = item;
    });
  }

  void deleteMenuItem(int index) {
    setState(() {
      menuItems.removeAt(index);
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
            const Text('MiniResto'),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber[300],
          labelColor: Colors.amber[300],
          unselectedLabelColor: Colors.white.withOpacity(0.8),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.list_alt), text: 'Orders'),
            Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DashboardTab(orders: orders, onAddOrder: addOrder, menuItems: menuItems),
          OrdersTab(orders: orders, onApprove: updateOrderStatus),
          MenuManagementTab(
            menuItems: menuItems,
            onAddItem: addMenuItem,
            onUpdateItem: updateMenuItem,
            onDeleteItem: deleteMenuItem,
          ),
        ],
      ),
    );
  }
}

// ------------------ MENU ITEM MODEL ------------------
class MenuItem {
  final String name;
  final double price;
  final String category;

  MenuItem({
    required this.name,
    required this.price,
    required this.category,
  });

  MenuItem copyWith({
    String? name,
    double? price,
    String? category,
  }) {
    return MenuItem(
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
    );
  }
}

// ------------------ MENU MANAGEMENT TAB ------------------
class MenuManagementTab extends StatefulWidget {
  final List<MenuItem> menuItems;
  final Function(MenuItem) onAddItem;
  final Function(int, MenuItem) onUpdateItem;
  final Function(int) onDeleteItem;

  const MenuManagementTab({
    super.key,
    required this.menuItems,
    required this.onAddItem,
    required this.onUpdateItem,
    required this.onDeleteItem,
  });

  @override
  State<MenuManagementTab> createState() => _MenuManagementTabState();
}

class _MenuManagementTabState extends State<MenuManagementTab> {
  final List<String> categories = [
    'Main Course',
    'Fast Food',
    'Italian',
    'Healthy',
    'Dessert',
    'Beverage'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu Items',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddEditMenuItemDialog(context, null);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.menuItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu,
                            size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No menu items yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add your first menu item',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.menuItems[index];
                      return Card(
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.restaurant,
                                color: Colors.green[800]),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Rs ${item.price.toStringAsFixed(0)} • ${item.category}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blue[700]),
                                onPressed: () {
                                  _showAddEditMenuItemDialog(context, index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red[700]),
                                onPressed: () {
                                  _showDeleteDialog(context, index);
                                },
                              ),
                            ],
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

  void _showAddEditMenuItemDialog(BuildContext context, int? index) {
    final isEditing = index != null;
    final item = isEditing ? widget.menuItems[index] : null;

    final nameController =
        TextEditingController(text: isEditing ? item!.name : '');
    final priceController = TextEditingController(
        text: isEditing ? item!.price.toStringAsFixed(0) : '');
    String selectedCategory =
        isEditing ? item!.category : categories.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.restaurant),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixText: 'Rs ',
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final price = double.tryParse(priceController.text) ?? 0;

                if (name.isNotEmpty && price > 0) {
                  final newItem = MenuItem(
                    name: name,
                    price: price,
                    category: selectedCategory,
                  );

                  if (isEditing) {
                    widget.onUpdateItem(index, newItem);
                  } else {
                    widget.onAddItem(newItem);
                  }

                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text(
              'Are you sure you want to delete "${widget.menuItems[index].name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDeleteItem(index);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// ------------------ DASHBOARD ------------------
class DashboardTab extends StatelessWidget {
  final List<Order> orders;
  final Function(Order) onAddOrder;
  final List<MenuItem> menuItems;

  const DashboardTab({
    super.key,
    required this.orders,
    required this.onAddOrder,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    int totalOrders = orders.length;
    int pendingOrders =
        orders.where((order) => order.status == 'Pending').length;
    double earnings = orders
        .where((order) => order.status == 'Completed')
        .fold(0.0, (sum, order) => sum + order.total);

    return Scaffold(
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
                          'Welcome to MiniResto!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Manage your restaurant efficiently',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
                context, '📦 Total Orders', '$totalOrders', Colors.blue),
            const SizedBox(height: 12),
            _buildSummaryCard(context, '💰 Total Earnings',
                'Rs ${earnings.toStringAsFixed(0)}', Colors.green),
            const SizedBox(height: 12),
            _buildSummaryCard(
                context, '⏳ Pending Orders', '$pendingOrders', Colors.orange),
            const SizedBox(height: 24),
            _buildMenuItemsSummary(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewOrderScreen(
                onSave: onAddOrder, menuItems: menuItems),
            ),
          );
        },
        label: const Text('Add Order'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green[800],
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, String title, String value, Color color) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconForTitle(title),
            color: color,
          ),
        ),
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('Orders')) return Icons.shopping_bag;
    if (title.contains('Earnings')) return Icons.attach_money;
    if (title.contains('Pending')) return Icons.hourglass_bottom;
    return Icons.info;
  }

  Widget _buildMenuItemsSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🍽️ Menu Summary',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Items: ${menuItems.length}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...menuItems
                    .map((item) => Chip(
                          label: Text(item.name),
                          backgroundColor: Colors.green[50],
                          labelStyle: TextStyle(color: Colors.green[800]),
                          avatar: Icon(Icons.restaurant,
                              size: 18, color: Colors.green[800]),
                        ))
                    .toList()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ NEW ORDER SCREEN ------------------
class NewOrderScreen extends StatefulWidget {
  final Function(Order) onSave;
  final List<MenuItem> menuItems;

  const NewOrderScreen({
    super.key,
    required this.onSave,
    required this.menuItems,
  });

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  MenuItem? selectedItem;
  int quantity = 1;

  double get total => (selectedItem != null ? selectedItem!.price * quantity : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Order',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select an item from the menu and specify quantity',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MenuItem>(
              decoration: InputDecoration(
                labelText: 'Select Item',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.restaurant_menu),
              ),
              value: selectedItem,
              items: widget.menuItems.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text('${item.name} - Rs ${item.price}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filled(
                          onPressed:
                              quantity > 1 ? () => setState(() => quantity--) : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          quantity.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton.filled(
                          onPressed: () => setState(() => quantity++),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rs ${total.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedItem != null
                    ? () {
                        final newOrder = Order(
                          itemName: selectedItem!.name,
                          quantity: quantity,
                          total: total,
                          status: 'Pending',
                        );
                        widget.onSave(newOrder);
                        Navigator.pop(context);
                      }
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('Confirm Order'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ ORDER MODEL ------------------
class Order {
  final String itemName;
  final int quantity;
  final double total;
  final String status;

  Order({
    required this.itemName,
    required this.quantity,
    required this.total,
    required this.status,
  });

  Order copyWith({String? status}) {
    return Order(
      itemName: itemName,
      quantity: quantity,
      total: total,
      status: status ?? this.status,
    );
  }
}

// ------------------ ORDERS TAB ------------------
class OrdersTab extends StatelessWidget {
  final List<Order> orders;
  final Function(int) onApprove;

  const OrdersTab({super.key, required this.orders, required this.onApprove});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first order from the dashboard',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isPending = order.status == 'Pending';

        return Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.fastfood, color: Colors.green[800]),
            ),
            title: Text(
              '${order.itemName} x${order.quantity}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Total: Rs ${order.total.toStringAsFixed(0)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPending
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: isPending ? Colors.orange[800] : Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isPending) ...[
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.check, size: 18),
                    onPressed: () => onApprove(index),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}