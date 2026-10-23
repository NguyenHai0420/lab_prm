# PRM393 - LAB 9: Working With Local JSON Storage (Flutter + File Persistence)

Ứng dụng Flutter hoàn chỉnh thực hiện 3 bài lab chính về lưu trữ dữ liệu JSON cục bộ và tính bền vững (Persistence) theo yêu cầu của **LAB 9_Working With Local JSON Storage.docx**.

---

## 1. Mục tiêu bài Lab (Objectives)
- **Lab 9.1 – Read JSON From Assets**: Đọc dữ liệu JSON từ file nhúng cục bộ trong assets (`assets/data/products.json`) qua `rootBundle.loadString()`, giải mã bằng `jsonDecode`, và hiển thị bằng `ListView`.
- **Lab 9.2 – Save & Load JSON From Device Storage**: Ghi và đọc dữ liệu ghi chú (`notes_storage.json`) trực tiếp vào bộ nhớ thiết bị qua `path_provider` (`getApplicationDocumentsDirectory()`), duy trì dữ liệu bền vững khi tắt/khởi động lại ứng dụng.
- **Lab 9.3 – JSON CRUD Mini Database (Search + Edit + Delete)**: Xây dựng mini-database sinh viên (`students_database.json`) hỗ trợ đầy đủ CRUD: Thêm sinh viên với ID tăng dần, sửa thông tin, xóa có dialog xác nhận, tìm kiếm theo từ khóa theo thời gian thực và tự động lưu (auto-save).

---

## 2. Cấu trúc thư mục dự án (Project Structure)

```text
lab9/
├── assets/
│   └── data/
│       └── products.json                 # File JSON asset cho Lab 9.1
├── lib/
│   ├── models/
│   │   ├── product.dart                  # Model dữ liệu sản phẩm (Lab 9.1)
│   │   ├── note_item.dart                # Model dữ liệu ghi chú (Lab 9.2)
│   │   └── student_record.dart           # Model dữ liệu sinh viên CRUD (Lab 9.3)
│   ├── services/
│   │   ├── asset_service.dart            # Service tải JSON qua rootBundle (9.1)
│   │   ├── storage_service_9_2.dart      # Service đọc/ghi File cục bộ (9.2)
│   │   └── storage_service_9_3.dart      # Service CRUD database & auto-save (9.3)
│   ├── screens/
│   │   ├── home_screen.dart              # Màn hình chính điều hướng 3 tab Lab
│   │   ├── lab9_1_assets_screen.dart     # UI hiển thị danh sách sản phẩm từ Assets
│   │   ├── lab9_2_storage_screen.dart    # UI thêm & lưu ghi chú vào bộ nhớ máy
│   │   └── lab9_3_crud_screen.dart       # UI CRUD mini database + tìm kiếm + xem Raw JSON
│   └── main.dart                         # Entry point ứng dụng (Material 3 Theme)
├── test/
│   └── widget_test.dart                  # Bộ kiểm thử tự động (Unit test + Widget test)
├── screenshots/                          # Ảnh chụp màn hình nghiệm thu các chức năng
│   ├── lab9_1_assets_loaded.png
│   ├── lab9_1_product_detail.png
│   ├── lab9_2_storage_saved.png
│   ├── lab9_2_storage_reloaded.png
│   ├── lab9_3_crud_database.png
│   ├── lab9_3_search_filter.png
│   ├── lab9_3_raw_json_dialog.png
│   └── lab9_3_student_added.png
├── lab9_submission.zip                   # File nén nộp bài
└── pubspec.yaml                          # Khai báo path_provider & assets/data/
```

---

## 3. Chi tiết triển khai theo từng bài Lab

### Lab 9.1 – Đọc JSON từ Assets (Local Embedded File)
- **Tệp JSON**: `assets/data/products.json` chứa danh sách 8 sản phẩm công nghệ đa dạng trường (`id`, `name`, `category`, `price`, `rating`, `description`, `stock`).
- **Cơ chế**:
  - Đăng ký asset trong `pubspec.yaml` dưới mục `flutter: assets: - assets/data/`.
  - Sử dụng `rootBundle.loadString('assets/data/products.json')` để nạp chuỗi JSON bất đồng bộ.
  - Sử dụng `jsonDecode` từ thư viện `dart:convert` để chuyển chuỗi thành danh sách `List<Product>`.
- **Giao diện**:
  - `ListView.builder` hiển thị thẻ sản phẩm (Tên, Danh mục, Đánh giá sao, Giá, Tồn kho).
  - Thanh chọn danh mục (Filter Chips) để lọc nhanh theo loại hàng.
  - Hỗ trợ vuốt làm mới (`RefreshIndicator`).
  - Chạm vào thẻ sản phẩm để mở `showModalBottomSheet` xem chi tiết mô tả đầy đủ.

### Lab 9.2 – Lưu & Đọc JSON từ bộ nhớ thiết bị (Device Storage)
- **Tệp lưu trữ**: `notes_storage.json` trong thư mục tài liệu của ứng dụng (`getApplicationDocumentsDirectory()`).
- **Cơ chế**:
  - Sử dụng package `path_provider` để xác định đường dẫn thư mục tài liệu máy.
  - Đọc file JSON nếu đã tồn tại, tự động tạo file mẫu nếu ứng dụng mới chạy lần đầu.
  - Ghi cập nhật trở lại đĩa bằng `File.writeAsString(jsonEncode(...))`.
  - Hỗ trợ cả fallback bộ nhớ cho Web / DartPad nhằm ngăn lỗi nền tảng.
- **Giao diện**:
  - Form nhập Tiêu đề và Nội dung ghi chú.
  - Nút **"Add Item to List"**: Đưa ghi chú mới vào danh sách bộ nhớ.
  - Nút **"Save to File"**: Ghi danh sách vào tệp JSON trên đĩa + hiển thị SnackBar thông báo thành công.
  - Nút **"Reload from File"**: Đọc trực tiếp từ file đĩa để chứng minh tính lưu trữ bền vững (Persistence).
  - Hiển thị trực tiếp đường dẫn file lưu trữ trên giao diện để người chấm bài dễ dàng kiểm chứng.

### Lab 9.3 – JSON CRUD Mini Database (Search + Edit + Delete)
- **Tệp cơ sở dữ liệu**: `students_database.json`.
- **Chức năng CRUD**:
  - **Create (Thêm mới)**: Nút FloatingActionButton mở dialog nhập thông tin (Mã sinh viên, Họ tên, Email, Chuyên ngành, Điểm GPA). ID được tự động tăng dần.
  - **Read (Đọc & Tìm kiếm)**: Thanh tìm kiếm động lọc theo thời gian thực theo Tên, Mã SV, Chuyên ngành hoặc Email. Hiển thị số lượng kết quả trùng khớp.
  - **Update (Sửa)**: Nút chỉnh sửa trên từng thẻ sinh viên, mở dialog điền sẵn dữ liệu, lưu lại và tự động ghi vào tệp JSON.
  - **Delete (Xóa)**: Nút xóa hiển thị hộp thoại xác nhận ("Confirm Deletion"), sau khi xác nhận sẽ xóa khỏi danh sách và cập nhật tệp JSON.
  - **Auto-Save**: Tự động ghi lại file JSON ngay lập tức sau mỗi thao tác Thêm, Sửa hoặc Xóa.
- **Tính năng mở rộng (Bonus)**:
  - Hộp thoại **"View Raw JSON in Storage"**: Cho phép xem trực tiếp chuỗi JSON định dạng chuẩn được lưu trong file.
  - Nút **"Reset Samples"**: Khôi phục lại dữ liệu sinh viên mẫu ban đầu nếu cần thiết.
  - Huy hiệu xếp loại điểm GPA trực quan theo màu sắc.

---

## 4. Hướng dẫn chạy ứng dụng (How to Run)

### Chạy trên máy ảo Android hoặc thiết bị thật:
```bash
flutter run
```

### Chạy trên trình duyệt Web (Chrome / Edge):
```bash
flutter run -d chrome
```

### Chạy trên Windows Desktop:
```bash
flutter run -d windows
```

### Chạy kiểm thử tự động (Unit & Widget Tests):
```bash
flutter test
```

---

## 5. Kết quả nghiệm thu (Screenshots)
Toàn bộ ảnh chụp màn hình nghiệm thu được lưu tại thư mục `screenshots/`:
1. `lab9_1_assets_loaded.png`: Danh sách sản phẩm được đọc và hiển thị từ file assets JSON.
2. `lab9_1_product_detail.png`: BottomSheet chi tiết sản phẩm.
3. `lab9_2_storage_saved.png`: Thêm ghi chú mới và lưu thành công vào file `notes_storage.json`.
4. `lab9_2_storage_reloaded.png`: Tải lại ghi chú trực tiếp từ file đĩa để kiểm chứng tính bền vững.
5. `lab9_3_crud_database.png`: Giao diện mini database sinh viên với các trường dữ liệu đầy đủ.
6. `lab9_3_search_filter.png`: Tìm kiếm động lọc sinh viên theo từ khóa.
7. `lab9_3_raw_json_dialog.png`: Hộp thoại xem dữ liệu Raw JSON lưu trong máy.
8. `lab9_3_student_added.png`: Thêm thành công sinh viên mới và tự động lưu.
