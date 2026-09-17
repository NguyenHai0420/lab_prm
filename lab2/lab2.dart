void exercise1() {
  /**
   * EXERCISE 1 - Basic Syntax & Data Types
   * 1. Create a main function.
   * 2. Declare variables using: String, int, double, bool.
   * 3. Use print() and interpolation ($var, ${exper}) to show values.
   */
  print('EXERCISE 1:');

  // Declare variables using: String, int, double, bool.
  String name = 'Nguyen Tat Hai';
  int age = 22;
  double height = 1.63;
  bool isStudent = true;

  // Use print() and interpolation ($var, ${exper}) to show values.
  print('Name: $name');
  print('Age: $age');
  print('Height: $height');
  print('Student: $isStudent');
  print('My age in next year: ${age + 1}');
  print('');
}

void exercise2() {
  /**
   * EXERCISE 2 - Collections & Operators
   * 1. Create a líst of integers.
   * 2. Use arithmetic & comparison operators.
   * 3. Create a Set (unique values) and a Map (key-value).
   * 4. Use indexing, add(), remove(), and map access.
   */
  print('EXERCISE 2:');

  // Create List of integer numbers.
  List<int> integerNumberList = [14, 4, 20, 24, 40];

  print('List of integer numbers: $integerNumberList \n');

  // Use arithmetic.
  int sum = integerNumberList[0] + integerNumberList[1];
  int subtraction = integerNumberList[4] - integerNumberList[2];

  print('Sum of first and second number in list: $sum');
  print('Subtraction of second and fourth number in list: $subtraction \n');

  // Use comparison operators.
  bool isEqual = integerNumberList[0] == 14;
  if (isEqual == true) {
    print('My birthday is: 14-04');
  }

  bool isValid = integerNumberList.length > 3 && integerNumberList.contains(24);
  print('List is valid: $isValid \n');

  // Create a Set (Unique values).
  Set<int> uniqueNumber = {52, 57, 61, 70, 95};
  print('Set(unique values): $uniqueNumber');

  // Use add().
  uniqueNumber.add(101);
  print('Set after add: $uniqueNumber');

  // Use remove().
  uniqueNumber.remove(57);
  print('Set after remove: $uniqueNumber\n');

  // Create a Map (key-value).
  Map<String, dynamic> myInformation = {
    'name': 'Nguyen Tat Hai',
    'age': 22,
    'university': 'FPT University',
    'major': 'SE',
  };

  // Use map access.
  print('Name: ${myInformation['name']}');
  print('Age: ${myInformation['age']}');
  print('University: ${myInformation['university']}');
  print('Major: ${myInformation['major']}');

  // Update Map value.
  myInformation['major'] = 'GD';
  print('Updated major: ${myInformation['major']}');
  print('');
}

void exercise3() {
  /**
   * EXERCISE 3 - Control Flow & Functions
   * 1. Write an if/else block to check score.
   * 2. Write a switch case for day of week.
   * 3. Loop through a collection using for, for-in, and forEach().
   * 4. Create a function using normal and arrow syntax.
   */
  print('EXERCISE 3:');

  // Use if/else to check score.
  int score = 75;

  if (score >= 90) {
    print('Excellent with score is $score');
  } else if (score >= 70) {
    print('Good with score is $score');
  } else if (score >= 50) {
    print('Pass with score is $score');
  } else {
    print('Failed');
  }

  // Use switch case for day of week.
  int day = 7;

  switch (day) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    case 3:
      print('Wednesday');
      break;
    case 4:
      print('Thursday');
      break;
    case 5:
      print('Friday');
      break;
    case 6:
      print('Saturday');
      break;
    case 7:
      print('Sunday');
      break;
    default:
      print('Invalid day');
  }
  print('');

  // Create a collection.
  List<String> brands = ['Honda', 'Ford', 'BMW', 'Toyota'];

  // For loop.
  print('For loop:');
  for (int i = 0; i < brands.length; i++) {
    print('${i + 1}. ${brands[i]}');
  }

  // For in loop.
  print('\nFor-in loop:');

  for (String brand in brands) {
    print(brand);
  }

  // forEach() loop.
  print('\nforEach loop:');

  brands.forEach((brand) {
    print(brand);
  });
  print('');

  // Call normal function.
  print('Normal function check score: ${checkScore(90)}');

  // Call arrow function.
  print('Arrow function: ${square(9)}');
  print('');
}

// Normal function.
String checkScore(int score) {
  if (score >= 90) {
    return ('Excellent with score is $score');
  } else if (score >= 70) {
    return ('Good with score is $score');
  } else if (score >= 50) {
    return ('Pass with score is $score');
  } else {
    return ('Failed');
  }
}

// Arrow function.
int square(int number) => number * number;

void exercise4() {
  /**
   * EXERCISE 4 - Intro to OOP
   * 1.	Create a class Car with one property and a method.
   * 2.	Create a named constructor.
   * 3.	Create a subclass ElectricCar that overrides a method.
   * 4.	Instantiate objects and print results.
   */
  print('EXERCISE 4:');

  // Create object using the default constructor.
  Car car1 = Car('Honda');

  // Create object using the named constructor.
  Car car2 = Car.defaultCar();

  // Create object of subclass.
  ElectricCar electricCar = ElectricCar('Tesla');

  // Call methods.
  car1.drive();
  car2.drive();
  electricCar.drive();
  print('');
}

class Car {
  // Property
  String brand;

  // Default constructor
  Car(this.brand);

  // Named constructor
  Car.defaultCar() : brand = "BMW";

  // Method
  void drive() {
    print('$brand car is driving');
  }
}

// Child class inherits from Car
class ElectricCar extends Car {
  // Constructor calls the parent constructor
  ElectricCar(String brand) : super(brand);

  // Override the parent method
  @override
  void drive() {
    print('$brand electric car is driving silently');
  }
}

Future<void> exercise5() async {
  /**
   * EXERCISE 5: Async, Future, Null Safety & Streams
   * 1.	Create an async function using Future + await.
   * 2.	Use Future.delayed() to simulate loading.
   * 3.	Practice null-safety operators (?, ??, !).
   * 4.	Create a simple Stream of integers and listen to values.
   */
  print('EXERCISE 5:');
  // Null safety: nullable variable
  String? nullableName;

  print('Nullable name: $nullableName');

  // Null-aware operator
  String displayName = nullableName ?? 'Guest';

  print('Display name: $displayName');

  // Assign a non-null value
  nullableName = 'Nguyen Tat Hai';

  // Null-aware access operator ?
  print('Name length: ${nullableName?.length}');

  // Null assertion operator !
  // The programmer guarantees that nullableName is not null
  print('Name using !: ${nullableName!.toUpperCase()}');

  // Async/await with Future
  print('\nFuture example:');

  String data = await loadData();

  print(data);

  // Listen to Stream values
  print('\nStream example:');

  await for (int value in numberStream()) {
    print('Stream value: $value');
  }

  print('Stream completed.');
}

// Async function using Future + await
Future<String> loadData() async {
  print('Loading data...');

  // Simulate loading for 2 seconds
  await Future.delayed(Duration(seconds: 2));

  return 'Data loaded successfully!';
}

// Stream function generates integers
Stream<int> numberStream() async* {
  for (int i = 1; i <= 5; i++) {
    // Wait 500 milliseconds before each value
    await Future.delayed(Duration(milliseconds: 500));

    yield i;
  }
}

Future<void> main() async {
  exercise1();
  exercise2();
  exercise3();
  exercise4();
  await exercise5();
}
