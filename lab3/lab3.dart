import 'dart:async';
import 'dart:convert';

/**
 * EXERCISE 1: Product Model & Repository.
 *
 * 1.	Define Product { id, name, price }.
 * 2.	Implement ProductRepository with:
 * •	Future<List<Product>> getAll()
 * •	Stream<Product> liveAdded() for real-time updates.
 * 3.	Use StreamController.broadcast() to emit new items.
 * 4.	Print results to console.
 */

// Define Product { id, name, price }.
class Product {
  final int id;
  final String name;
  final double price;

  Product(this.id, this.name, this.price);
}

class ProductRepository {
  final List<Product> productList = [Product(1, "Mouse pad", 300)];

  // StreamController.broadcast() to emit new products.
  final StreamController<Product> productController =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    print('Loading data...');

    await Future.delayed(Duration(seconds: 1));

    return productList;
  }

  // Use Stream for real-time updates.
  Stream<Product> liveAdded() {
    return productController.stream;
  }

  // Emit new products to the Stream.
  void addProduct(Product product) {
    productList.add(product);
    productController.add(product);
  }

  // Close the controller.
  Future<void> dispose() async {
    productController.close();
  }
}

Future<void> exercise1() async {
  ProductRepository repository = ProductRepository();

  print('Exercise 1:');

  // get existing products.
  List<Product> products = await repository.getAll();

  print('Existing products:');
  for (Product product in products) {
    print('${product.id}: ${product.name} - ${product.price}');
  }

  print('New product: ');

  // Listen adding new products.
  repository.liveAdded().listen((product) {
    print('${product.id}: ${product.name} - ${product.price}');
  });

  // Add new product real-time.
  repository.addProduct(Product(2, "Keyboard", 2300000));
  repository.addProduct(Product(3, "Mouse", 650));

  // Wait for Stream process.
  await Future.delayed(Duration(seconds: 1));

  // Close controller
  repository.dispose();
}

/**
 * EXERCISE 2: User Repository with JSON.
 * 1.	Create User { name, email } and User.fromJson(Map) constructor.
 * 2.	Simulate JSON list from an API.
 * 3.	Use Future<List<User>> to return parsed data.
 * 4.	Display results with print().
 */

// Create User model.
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  // Create User.fromJson(Map).
  User.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      email = json['email'];
}

class UserRepository {
  Future<List<User>> getUsers() async {
    // API delay
    await Future.delayed(Duration(milliseconds: 500));

    String jsonData = '''
    [
      {
        "name": "Nguyen Tất Hải",
        "email": "hainthe180489@fpt.edu.vn"
      },
      {
        "name": "Nguyen Văn Minh",
        "email": "nguyenminh12@gmail.com"
      }
    ]
    ''';

    List<dynamic> jsonList = jsonDecode(jsonData);

    return jsonList.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> exercise2() async {
  print('\nExercise 2:');

  UserRepository userRepo = UserRepository();

  List<User> users = await userRepo.getUsers();

  print('User parsed from Json:');

  for (User user in users) {
    print(' ${user.name} - ${user.email}');
  }
}

/**
 * EXERCISE 3: Async + Microtask Debugging.
 * 1.	Write a snippet with scheduleMicrotask() and Future(() {…}).
 * 2.	Print execution order.
 * 3.	Explain why microtasks run before event callbacks.
 */

Future<void> exercise3() async {
  // 1. Code đồng bộ xử lý trước -> Microtask Queue -> Event Queue.
  // 2. Microtask Queue được xử lý trước Event Queue.
  print('\nExercise 3:');

  String orderStatus = 'Chưa thanh toán';

  print('1. Xác nhận mua hàng');

  // Callback is placed into Microtask queue.
  scheduleMicrotask(() {
    orderStatus = 'Đã thanh toán';
    print('3. Microtask: \n Cập nhật trạng thái - $orderStatus');
  });

  // Future create Event callback.
  Future(() {
    print('4. Event: \n Trạng thái đơn hàng hiện tại - $orderStatus');
  });

  // Explain why microtasks run before event callbacks.
  Future(() {
    print(
      '5. Giải thích: Microtasks chạy trước Event callbacks'
      ' vì Dart luôn dọn hàng đợi Microtask Queue'
      ' trước khi xử lý sự kiện tiếp theo từ hàng đợi Event Queue',
    );
  });

  print('2. Trạng thái đơn hàng - $orderStatus');

  // Wait callbacks complete.
  await Future.delayed(Duration(milliseconds: 100));
}

/**
 * EXERCISE 4: Stream Transformation.
 * 1.	Create a stream of numbers 1–5.
 * 2.	Transform values to their squares using map().
 * 3.	Filter even numbers with where().
 * 4.	Listen and print each emitted value.
 */

Future<void> exercise4() async {
  print('\nExercise 4:');
  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  // print('Square value:');
  // numbers.map((number) => number * number).listen((number) {
  //   print(number);
  // });
  //
  // await Future.delayed(Duration(milliseconds: 100));
  //
  // print('Even numbers:');
  // numbers.where((evenNumber) => evenNumber % 2 == 0).listen((evenNumber) {
  //   print(evenNumber);
  // });

  // Transform square values using map.
  Stream<int> squareNumbers = numbers.map((number) {
    return number * number;
  });

  // Display square value.
  print('Square value:');
  await for(int valueSquare in squareNumbers) {
    print(valueSquare);
  }

  // Filter even numbers with where().
  print('Even numbers:');
  Stream<int> evenNumbers = numbers.where((number) {
    return number % 2 == 0;
  });

  // Display even numbers.
  await evenNumbers.forEach((evenNumber) {
    print(evenNumber);
  });
}

/**
 * EXERCISE 5: Factory Constructors & Cache.
 * 1.	Create a Settings class with private constructor.
 * 2.	Add a factory Settings() that returns a singleton instance.
 * 3.	Verify two instances refer to the same object (identical(a, b) → true).
 */

class Settings {
  String theme = 'Dark';
  String language = 'English';

  // private constructor.
  Settings._();

  // Singleton instance.
  static final Settings _instance = Settings._();

  // Add a Factory Settings.
  factory Settings() {
    return _instance;
  }
}

Future<void> exercise5() async {
  print('\nExercise 5:');
  Settings settingTheme1 = Settings();
  Settings settingTheme2 = Settings();

  print('Setting theme: $settingTheme1');
  print('Setting theme: $settingTheme2');

  // Verify two instance with identical(a, b).
  print('Are they same object? - ${identical(settingTheme1, settingTheme2)}');
}

Future<void> main() async {
  await exercise1();
  await exercise2();
  await exercise3();
  await exercise4();
  await exercise5();
}
