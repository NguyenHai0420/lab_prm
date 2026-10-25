# LAB 11 — Testing & Debugging In Flutter (Taskly App)

## 1. Giới thiệu dự án
Dự án **Taskly** là ứng dụng quản lý công việc (To-Do / Task Manager) được xây dựng theo chuẩn kiến trúc Flutter, phục vụ toàn bộ các nội dung kiểm thử (Unit Test, Widget Test, Navigation Test, Integration Test) và gỡ lỗi bằng Flutter DevTools theo yêu cầu của bài Lab 11 (PRM393).

## 2. Cấu trúc thư mục
```text
lab11/
├── lib/
│   ├── models/
│   │   └── task.dart                  # Model Task với thuộc tính completed mặc định false, hàm toggle(), copyWith(), JSON serialization
│   ├── repositories/
│   │   └── task_repository.dart       # Quản lý danh sách tác vụ (addTask, deleteTask, updateTask, toggleTask, clear, ChangeNotifier)
│   ├── screens/
│   │   ├── task_list_screen.dart      # Màn hình danh sách tác vụ, Empty state "No tasks yet. Add one!", TextField & Add button
│   │   └── task_detail_screen.dart    # Màn hình chi tiết: AppBar "Task Detail", TextField key "detailTitleField", nút lưu
│   └── main.dart                      # Điểm khởi chạy TasklyApp (hỗ trợ dependency injection cho repository)
├── test/
│   ├── unit/
│   │   ├── task_model_test.dart       # Kiểm thử Task model (default completed, toggle true/false, copyWith, serialization)
│   │   └── task_repository_test.dart  # Kiểm thử TaskRepository (addTask, deleteTask, updateTask, edge cases theo AAA)
│   ├── widget/
│   │   ├── task_list_widget_test.dart # Kiểm thử TaskListScreen (Empty state, Add 1 task, Add multiple tasks)
│   │   ├── task_navigation_test.dart  # Kiểm thử điều hướng TaskListScreen -> TaskDetailScreen (Appbar & detailTitleField)
│   │   └── task_integration_test.dart # Kiểm thử luồng tích hợp đầy đủ End-to-End
│   └── integration/
│       └── task_integration_test.dart # Test tích hợp tổ chức theo Lab 11.5
├── devtools_screenshots/
│   ├── widget_inspector.png           # Ảnh chụp màn hình Widget Inspector từ Flutter DevTools
│   └── performance_timeline.png       # Ảnh chụp màn hình Performance Timeline từ Flutter DevTools
├── reports/
│   ├── Debugging_Report_Lab11_4.docx  # Báo cáo gỡ lỗi DevTools (Word DOCX)
│   ├── Debugging_Report_Lab11_4.md    # Báo cáo gỡ lỗi DevTools (Markdown)
│   ├── Test_Suite_Summary_Lab11_5.docx# Báo cáo tổng kết kiểm thử (Word DOCX)
│   └── Test_Suite_Summary_Lab11_5.md  # Báo cáo tổng kết kiểm thử (Markdown)
└── pubspec.yaml
```

## 3. Hướng dẫn chạy kiểm thử (Testing Commands)

### Chạy toàn bộ test suite:
```bash
flutter test
```

### Chạy từng loại test cụ thể:
1. **Unit Tests (Lab 11.1):**
```bash
flutter test test/unit/
```
2. **Widget Tests (Lab 11.2):**
```bash
flutter test test/widget/task_list_widget_test.dart
```
3. **Navigation Tests (Lab 11.3):**
```bash
flutter test test/widget/task_navigation_test.dart
```
4. **Integration Tests (Lab 11.4):**
```bash
flutter test test/integration/task_integration_test.dart
```

### Kiểm tra cú pháp và chất lượng mã nguồn:
```bash
flutter analyze
```

## 4. Chạy ứng dụng thực tế:
```bash
flutter run
```
