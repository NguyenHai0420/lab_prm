abstract class Employee {
  String name;
  Employee(this.name);
  void work(){
  }
}

mixin checkInAbility on Employee {
  void checkIn() {
    print('$name đã điểm danh');
  }
}

class Developer extends Employee with checkInAbility {
  Developer(String name) : super(name);

  @override
  void work() => print('$name đang viết code');
}

void main () {
  List<Developer> teamA = [Developer("Hải"), Developer("Đức Anh")];
  List<Developer> teamB = [Developer("Minh")];

  List<Developer> allStaff = [...teamA, ...teamB];

  for (Developer employee in allStaff) {
    employee.checkIn();
  }
}