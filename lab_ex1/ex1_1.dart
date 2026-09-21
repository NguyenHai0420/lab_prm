class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void startEngine () {
    print('Khởi động phương tiện...');
  }
}

class Car extends Vehicle {

  bool isElectric;

  Car(String brand, int year, this.isElectric) : super(brand, year);

  Car.tesla(String brand, int year) : isElectric = true, super('Tesla', year);

  @override
  void startEngine() {
    if (isElectric) {
      print('$brand - $year: Xe điện Êm ruuuuu');
    } else {
      print('$brand - $year: Honda VTEC');
    }
  }
}

void main() {
  Car myCar = Car("Honda", 2022, false);
  myCar.startEngine();

  Car.tesla("Teala", 2025).startEngine();
}