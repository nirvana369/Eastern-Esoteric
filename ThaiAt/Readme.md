# Thái Ất Web Prototype

Prototype refactor Motoko → HTML + JavaScript.

## Kiến trúc

```text
index.html
  └─ app.js
      └─ ThaiAt
          ├─ types.js
          ├─ solar24.js              # port logic thiên văn/Bát Quái từ solar24.mo
          └─ calendar-adapter.js     # adapter cho @lichta/core
                  └─ @lichta/core
      └─ BatQuaiDrawer               # Canvas
```

`@lichta/core` chỉ đảm nhiệm lớp lịch nền: Solar → Lunar và Can Chi. Công thức Julian Day, solar longitude, 24 tiết khí và logic Bát Quái Vượng/Tướng/Thai... trong `solar24.mo` được giữ thành module `Solar24` riêng.

## Chạy

```bash
python -m http.server 8000
```

Mở `http://localhost:8000`.

## Lưu ý

- Đây là prototype kiến trúc, chưa tuyên bố kết quả JS tương đương 100% Motoko.
- `@lichta/core` hiện công bố hỗ trợ lịch Việt Nam và Can Chi; năm Solar → Lunar được giới hạn 1800–2199.
- Các phần `TA.mo` chưa hoàn thiện vẫn giữ skeleton.
- Bước kiểm chứng tiếp theo là chạy một bộ ngày chuẩn trên Motoko và JS rồi so sánh từng node.
