# LichTa 🌙

[![@lichta/core](https://img.shields.io/npm/v/@lichta/core.svg?label=%40lichta%2Fcore)](https://www.npmjs.com/package/@lichta/core)
[![license](https://img.shields.io/npm/l/@lichta/core.svg)](./LICENSE)

**Thư viện chuyển đổi Dương lịch ↔ Âm lịch Việt Nam cho JavaScript/TypeScript.**

Thuần TypeScript, **0 dependency** ở phần lõi, strongly-typed đầy đủ, hỗ trợ sẵn component cho React/Vue/Svelte 5 và adapter tiêm ngày âm lịch vào FullCalendar/EventCalendar/React Big Calendar.

🚀 **[Live Demo & Tài liệu](https://lichta.zeneo.app/)**

---

## ✨ Tính năng

- 🔄 **Chuyển đổi Solar ↔ Lunar** chính xác — thuật toán Hồ Ngọc Đức (phạm vi năm 1800–2199)
- 🐉 **Can Chi** — tính Can Chi cho năm, tháng, ngày, giờ
- 🔮 **Ngũ Hành đầy đủ** — Mệnh Nạp Âm cho năm/tháng/ngày/giờ (bảng chuẩn 60 Hoa Giáp) + quan hệ Tương Sinh/Tương Khắc
- 🌞 **Tiết Khí** — 24 điểm chia quỹ đạo Mặt Trời, tra theo ngày hoặc liệt kê cả năm
- 🀄 **Trực (12 Kiến Trừ)** — neo theo Tiết (đúng cả trong tháng nhuận), kèm mức tốt/xấu tổng quát
- ⏰ **Giờ Hoàng Đạo / Hắc Đạo** — 6 giờ tốt và 6 giờ xấu trong ngày
- ⚔️ **Tuổi xung khắc** — Lục Xung, Lục Hại, Tứ Hành Xung
- 🗓️ **Số tuần ISO-8601** — `getCalendarGrid()` kèm sẵn `weekNumber`, tuần bắt đầu Chủ Nhật hoặc Thứ Hai tùy chọn
- 🎨 **Format linh hoạt** — hiển thị ngày âm lịch truyền thống hoặc theo pattern tùy chỉnh
- 🌐 **i18n** — hỗ trợ Việt–Anh–Nhật–Hàn (vi, en, ja, ko)
- 📅 **Component sẵn dùng** — `Calendar`/`DatePicker`/`Formatter` cho React, Vue, Svelte 5
- 🔌 **Plugin tích hợp** — FullCalendar, EventCalendar, React Big Calendar
- 📦 **Modular** — cài đúng phần cần dùng, `@lichta/core` không phụ thuộc framework nào

## 📦 Packages

| Package | Mô tả |
|---|---|
| [`@lichta/core`](https://www.npmjs.com/package/@lichta/core) | Thuật toán lõi Solar↔Lunar, Can Chi, Ngũ Hành, format — thuần TypeScript, 0 dependency |
| [`@lichta/react`](https://www.npmjs.com/package/@lichta/react) | Component `Calendar` cho React |
| [`@lichta/vue`](https://www.npmjs.com/package/@lichta/vue) | Component `Calendar` cho Vue 3 |
| [`@lichta/svelte`](https://www.npmjs.com/package/@lichta/svelte) | Component `Calendar`/`Formatter` cho Svelte 5 (re-export toàn bộ `@lichta/core`) |
| [`@lichta/full-calendar`](https://www.npmjs.com/package/@lichta/full-calendar) | Adapter tiêm ngày âm lịch vào [FullCalendar](https://fullcalendar.io/) |
| [`@lichta/event-calendar`](https://www.npmjs.com/package/@lichta/event-calendar) | Adapter tiêm ngày âm lịch vào [EventCalendar](https://github.com/vkurko/calendar) |
| [`@lichta/react-big-calendar`](https://www.npmjs.com/package/@lichta/react-big-calendar) | Adapter tiêm ngày âm lịch vào [React Big Calendar](https://github.com/jquense/react-big-calendar) |

`@lichta/core` được cài kèm tự động khi bạn cài bất kỳ package nào ở trên — không cần cài riêng.

## Cài đặt nhanh

```bash
pnpm add @lichta/core
# hoặc: npm install @lichta/core / yarn add @lichta/core / bun add @lichta/core
```

Dùng React/Vue/Svelte? Cài thêm package binding tương ứng (`@lichta/react`, `@lichta/vue`, `@lichta/svelte`) — xem bảng packages ở trên.

## Sử dụng cơ bản

```typescript
import { LichTa } from '@lichta/core';

// Dương lịch → Âm lịch
const lunar = LichTa.toLunar(10, 2, 2024);
// → { day: 1, month: 1, year: 2024, isLeap: false, jd: 2460351,
//     dayCanChi: 'Giáp Thìn', monthCanChi: 'Bính Dần', yearCanChi: 'Giáp Thìn' }

// Âm lịch → Dương lịch (isLeap bắt buộc truyền đúng nếu là tháng nhuận)
const solar = LichTa.toSolar(1, 1, 2024, false);
// → { day: 10, month: 2, year: 2024 }

// Múi giờ tùy chỉnh (mặc định GMT+7 Việt Nam)
const lunarGmt8 = LichTa.toLunar(10, 2, 2024, 8);
```

`toLunar`/`toSolar` throw `RangeError` nếu ngày/tháng/năm ngoài phạm vi hợp lệ (năm **1800–2199**) — nên bọc trong `try/catch` khi nhận input từ người dùng.

## Can Chi & Phong Thủy

```typescript
import { LichTa, getYearDetails, getDayCanChi, getMonthCanChi, getHourCanChi, getAuspiciousHours, getInauspiciousHours } from '@lichta/core';

getYearDetails(2024);
// → { can: 'Giáp', chi: 'Thìn', menh: 'Hỏa', menhIndex: 3, fullString: 'Giáp Thìn - Mệnh Hỏa' }

const lunar = LichTa.toLunar(10, 2, 2024);
getDayCanChi(lunar.jd);                    // 'Giáp Thìn'
getMonthCanChi(lunar.month, lunar.year);   // 'Bính Dần'
getHourCanChi(8, lunar.jd);                // giờ Thìn (7h-9h)
getAuspiciousHours(lunar.jd);              // 6 giờ Hoàng Đạo (tốt) trong ngày
getInauspiciousHours(lunar.jd);            // 6 giờ Hắc Đạo (xấu) — phần bù của Hoàng Đạo
```

## Ngũ Hành, Tiết Khí, Trực & Tuổi Xung Khắc

```typescript
import { getDayElement, getElementRelation, getSolarTerm, getTruc, getTrucQuality, getTrucIndex, getZodiacConflicts } from '@lichta/core';

getDayElement(lunar.jd);                   // 'Hỏa' — Mệnh Nạp Âm của ngày (bảng chuẩn 60 Hoa Giáp)
getElementRelation(1, 3);                  // 'Tương sinh' — Mộc (1) sinh Hỏa (3)

getSolarTerm(21, 6, 2024);
// → { index: 6, name: 'Hạ Chí', date: { day: 21, month: 6, year: 2024 }, jd: 2460483 }

getTruc(lunar.jd);                         // 'Phá' — 1 trong 12 Trực (Kiến, Trừ, Mãn, ...), neo theo Tiết
getTrucQuality(getTrucIndex(lunar.jd));    // 'Xấu'

getZodiacConflicts(0, 6);                  // Tý (0) và Ngọ (6)
// → { xung: true, hai: false, tuHanhXung: true }
```

Chi tiết đầy đủ (Mệnh cho tháng/giờ, Lục Xung/Lục Hại/Tứ Hành Xung, 24 Tiết Khí/năm...): xem [README của `@lichta/core`](https://www.npmjs.com/package/@lichta/core) hoặc [API Reference](https://lichta.zeneo.app/api).

## Format & Hiển thị

```typescript
import { formatTraditional, formatLunarDate, getMonthName, getDayName } from '@lichta/core';

formatTraditional(lunar);                        // 'Mùng Một tháng Giêng năm Giáp Thìn'
formatLunarDate(lunar, 'dd/MM/yyyy');             // '01/01/2024'
formatLunarDate(lunar, 'Ngày d tháng M năm CC');  // 'Ngày 1 tháng 1 năm Giáp Thìn'

getMonthName(1);   // 'Giêng'
getDayName(15);    // 'Rằm'
```

**Format tokens:** `dd`/`d` (ngày), `MM`/`M` (tháng), `yyyy`/`yy` (năm), `CC`/`MC`/`DC` (Can Chi năm/tháng/ngày), `L` ("Nhuận" nếu là tháng nhuận).

## Lưới lịch tháng (dựng UI Calendar riêng)

Nếu bạn muốn tự dựng UI lịch tháng thay vì dùng component `Calendar` có sẵn, `getCalendarGrid()` dựng sẵn lưới 42 ô (6 tuần) cho 1 tháng, gồm cả ngày tràn từ tháng trước/sau, ngày âm lịch tương ứng, và số tuần ISO-8601 cho mỗi ô — đây cũng chính là hàm mà component `Calendar`/`DatePicker` dùng nội bộ.

```typescript
import { getCalendarGrid, getISOWeekNumber } from '@lichta/core';

// tháng, năm, ngày đang chọn (hoặc null), ngày bắt đầu tuần (0 = CN mặc định, 1 = Thứ Hai)
const grid = getCalendarGrid(2, 2024, null, 1);
// → CalendarDayCell[42], mỗi ô: { solar: Date, lunar: LunarDate, isToday, isSelected, isCurrentMonth, weekNumber: number }

getISOWeekNumber(new Date(2024, 0, 1)); // → 1
```

## i18n

Hỗ trợ 4 ngôn ngữ cho tên Can Chi, Ngũ Hành, con giáp, tên tháng, thứ trong tuần: `vi`, `en`, `ja`, `ko`.

```typescript
import { t, getZodiacAnimal } from '@lichta/core';

t('en').fiveElements;       // ['Metal', 'Wood', 'Water', 'Fire', 'Earth']
t('ja').weekDays;           // ['日', '月', '火', '水', '木', '金', '土']
getZodiacAnimal(0, 'vi');   // 'Chuột'
```

## Component cho framework UI

Mỗi package binding export component `Calendar` (lịch tháng có ngày âm lịch) và `DatePicker` (input + popover chọn ngày, dựng trên `Calendar`) đóng gói trên `@lichta/core`.

**React**

```tsx
import { Calendar, DatePicker } from '@lichta/react';
import '@lichta/core/styles/calendar-base.css';
import '@lichta/core/styles/datepicker-base.css'; // chỉ cần nếu dùng DatePicker

<Calendar theme="glass" locale="vi" onSelect={(date, lunar) => console.log(date, lunar)} />
<DatePicker theme="glass" locale="vi" onSelect={(date, lunar) => console.log(date, lunar)} />
```

**Vue**

```vue
<Calendar theme="glass" locale="vi" @select="onSelect" />
<DatePicker theme="glass" locale="vi" @select="onSelect" />
```

**Svelte 5**

```svelte
<Calendar theme="glass" locale="vi" onSelect={(date, lunar) => console.log(date, lunar)} />
<DatePicker theme="glass" locale="vi" onSelect={(date, lunar) => console.log(date, lunar)} />
```

`Calendar` (cả 3 framework) cũng có prop `firstDayOfWeek` (`0` = Chủ Nhật mặc định, `1` = Thứ Hai) và `showWeekNumber` (`boolean`, mặc định `false`) để hiện số tuần ISO-8601 ở đầu mỗi hàng.

Chi tiết props, custom render, theming: xem README của từng package ([`@lichta/react`](https://www.npmjs.com/package/@lichta/react), [`@lichta/vue`](https://www.npmjs.com/package/@lichta/vue), [`@lichta/svelte`](https://www.npmjs.com/package/@lichta/svelte)).

## Tích hợp Calendar bên thứ 3

`@lichta/full-calendar`, `@lichta/event-calendar`, `@lichta/react-big-calendar` export một hàm duy nhất `injectLunarDates(options, pluginOptions?)` — bọc cấu hình gốc của calendar library và tiêm ngày âm lịch vào từng ô ngày.

```typescript
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import { injectLunarDates } from '@lichta/full-calendar';

const calendar = new Calendar(el, injectLunarDates({
  plugins: [dayGridPlugin],
  initialView: 'dayGridMonth'
}, { showLeapMonth: true, color: '#81b29a' }));
```

Chi tiết từng adapter: xem README của [`@lichta/full-calendar`](https://www.npmjs.com/package/@lichta/full-calendar), [`@lichta/event-calendar`](https://www.npmjs.com/package/@lichta/event-calendar), [`@lichta/react-big-calendar`](https://www.npmjs.com/package/@lichta/react-big-calendar).

## 📚 Tài liệu

- [Tài liệu đầy đủ](https://lichta.zeneo.app/docs) — cài đặt, sử dụng, components, tích hợp
- [API Reference](https://lichta.zeneo.app/api) — chữ ký hàm, kiểu dữ liệu, ví dụ đã chạy thật
- [Về LichTa](https://lichta.zeneo.app/about) — nguồn gốc thuật toán, hệ sinh thái package
- [Demo trực tiếp](https://lichta.zeneo.app/) — thử tương tác từng framework/integration

## Thuật toán

LichTa sử dụng thuật toán chuyển đổi âm lịch của **Hồ Ngọc Đức** (Đại học Leipzig), dựa trên các công thức thiên văn trong *"Astronomical Algorithms"* của **Jean Meeus** (1998) — chuẩn de facto cho lịch âm Việt Nam trong lập trình.

- **Julian Day Number** — hệ tọa độ ngày liên tục cho tính toán thiên văn
- **Điểm Sóc (New Moon)** — xác định mùng 1 âm lịch
- **Trung Khí (Solar Terms)** — xác định tháng và tháng nhuận

**Phạm vi hỗ trợ**: 1800 – 2199 | **Múi giờ mặc định**: GMT+7 (Việt Nam)

## Đóng góp

Repo này chỉ chứa bản build công khai (`dist/`) và đóng vai trò issue tracker — mã nguồn được giữ private nên không nhận PR sửa code trực tiếp tại đây. Bạn có thể [báo lỗi, đề xuất tính năng, hoặc tham gia thảo luận](./CONTRIBUTING.md).

## License

[MIT](./LICENSE)

## 🙏 Credits

- **Hồ Ngọc Đức** — thuật toán gốc ([informatik.uni-leipzig.de](http://www.informatik.uni-leipzig.de/~duc/amlich/))
- **Jean Meeus** — *Astronomical Algorithms* (1998)
- **Zeforc Labs** — phát triển và duy trì
