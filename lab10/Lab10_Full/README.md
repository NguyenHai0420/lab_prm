# Lab 10 Full – Integrated Application

## 1. Tổng quan
Dự án tích hợp toàn bộ các tính năng từ Lab 10.1 đến Lab 10.5:
- **SplashScreen Routing**: Kiểm tra session `SharedPreferences` để tự động điều hướng.
- **REST API Login (DummyJSON)**: Xác thực người dùng thực tế với kiểm tra lỗi & loading state.
- **Google Sign-In / Firebase Auth**: Hỗ trợ đăng nhập bằng tài khoản Google.
- **Auto-Login & Logout**: Duy trì phiên đăng nhập sau khi tắt app, xóa phiên khi đăng xuất.
- **Local Notifications (LO7)**: Kích hoạt thông báo tự động khi đăng nhập/đăng xuất thành công và nút gửi thông báo kiểm thử thủ công.

## 2. Tài khoản thử nghiệm
| Phương thức | Tài khoản / Username | Mật khẩu |
| :--- | :--- | :--- |
| **REST API** | `emilys` | `emilyspassword` |
| **REST API** | `michaelw` | `michaelwpassword` |
| **Google** | 1-Click Sign-In | Tự động |

## 3. Cách chạy ứng dụng
```bash
flutter pub get
flutter run
```
