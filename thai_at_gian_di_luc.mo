
/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : thai_at_gian_di_luc.mo
* Description       : Thái Ất thần số - Tam thức học
*                     - Bậc vua có đất nước thì xem tuế kế (năm)
*                     - Nguyệt kế (tháng) thì xem cho bậc công khanh
*                     - Nhật kế (ngày) thì cho các quan và dân chúng
*                     - Vận trù chiến sự thì bậc tướng soái xem Thời kế (giờ) 
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 26/08/2025		nirvana369 		implement
* 26/08/2025        nirvana369      Tìm Thái Ất, Tuế Kế (360), Tìm kỷ nguyên Giáp Tý (60), tính Cục (72),
*                                   tìm Kế Thần (12), tìm Thiên Mục/Văn Xương (Chủ Mục),
*                                   tìm Thủy Kích (Khách Mục), tìm Chủ/Khách, tìm Chủ/Khách Đại/Tham Tướng.
* 27/08/2025        nirvana369      need implement 72 cục dương độn - Thái ất giản dị lục (page 99 - 111) 
* 27/08/2025        nirvana369      implement tim_chu_khach_1()
* 30/08/2025        nirvana369      Phép Đại Du Thái Ất & Tiểu Du Thái Ất:
*                                   implement : dai_du_thai_at(), tieu_du_thai_at(), phuong_vi_phuc_tinh()
* 30/08/2025        nirvana369      Tính Bát Môn -> implement bat_mon()                                   
******************************************************************/

import Int "mo:base/Int";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Hash "mo:base/Hash";

module {

    // Thứ tự bát quái
    // 1 - Càn ; 2 - Ly ; 3 - Cấn ; 4 - Chấn ; 6 - Đoài ; 7 - Khôn ; 8 - Khảm ; 9 - Tốn
    public let CAN_KIM = ("Càn", 1);
    public let LY_HOA = ("Ly", 2);
    public let CAN_THO = ("Cấn", 3);
    public let CHAN_MOC = ("Chấn", 4);
    public let TRUNG = ("Trung", 5);
    public let DOAI_KIM = ("Đoài", 6);
    public let KHON_THO = ("Khôn", 7);
    public let KHAM_THUY = ("Khảm", 8);
    public let TON_MOC = ("Tốn", 9);
    public let BAT_QUAI = [CAN_KIM,
                    LY_HOA, 
                    CAN_THO, 
                    CHAN_MOC,
                    TRUNG,
                    DOAI_KIM, 
                    KHON_THO, 
                    KHAM_THUY, 
                    TON_MOC];
    
    public let CLOCK_BAT_QUAI = [CAN_KIM, KHAM_THUY, CAN_THO, CHAN_MOC, TON_MOC, LY_HOA, KHON_THO, DOAI_KIM];

    public let CHI = {
        TY = "Tý";
        SUU = "Sửu";
        DAN = "Dần";
        MAO = "Mão";
        THIN = "Thìn";
        TI = "Tị";
        NGO = "Ngọ";
        MUI = "Mùi";
        THAN = "Thân";
        DAU = "Dậu";
        TUAT = "Tuất";
        HOI = "Hợi";
    };

    public let DIA_BAN : [(Text, Nat)] = [
        (CAN_KIM.0, 1), (CHI.HOI, 2), (CHI.TY, 3), (CHI.SUU, 4), (CAN_THO.0, 5), (CHI.DAN, 6), 
        (CHI.MAO, 7), (CHI.THIN, 8), (TON_MOC.0, 9), (CHI.TI, 10), (CHI.NGO, 11), (CHI.MUI, 12),
        (KHON_THO.0, 13), (CHI.THAN, 14), (CHI.DAU, 15), (CHI.TUAT, 16)
    ];

    public let THAP_LUC_THAN : [(Text, Nat)] = [
        ("Âm Đức", 1), ("Đại nghĩa", 2), ("Địa Chu", 3), ("Dương Đức", 4), ("Hòa Đức", 5), ("Lã Thân", 6), 
        ("Cao Tùng", 7), ("Thái Dương", 8), ("Đại Trắc", 9), ("Đại Thần", 10), ("Thiên Uy", 11), ("Thiên Đạo", 12), 
        ("Đại Vũ", 13), ("Vũ Đức", 14), ("Thái Thốc", 15), ("Âm Chủ", 16)
    ];

    public let THIEN_CAN : [(Text, Nat)] = [
        ("Giáp", 1), ("Ất", 2), ("Bính", 3), ("Đinh", 4), ("Mậu", 5), ("Kỷ", 6), 
        ("Canh", 7), ("Tân", 8), ("Nhâm", 9), ("Quý", 10)
    ];

    public let BAT_MON = [("Khai", 1), ("Hưu", 8), ("Sinh", 3), ("Thương", 4), ("Đỗ", 9), ("Cảnh", 2), ("Tử", 7), ("Kinh", 6)];

    public let CUU_TINH = [("Thiên Bồng", 1),  // Lục Mậu tinh - chủ về việc cảm động không yên, việc thay đổi
                    ("Thiên Nhuế", 2), // Lục Kỷ tinh - chủ về can qua, binh giáp, trộm cướp, hưng phế 
                    ("Thiên Xung", 3), // Lục Canh tinh - chủ về binh qua sát phạt
                    ("Thiên Phụ", 4),  // Lục Tân tinh - chủ về kho đụn, ngũ cốc (lành)
                    ("Thiên Cầm", 5), // Lục Nhâm tinh - chủ về giết kẻ có tội (lành)
                    ("Thiên Tâm", 6), // Lục Quý tinh - chủ về đánh dẹp kẻ vô đạo (lành)
                    ("Thiên Trụ", 7), // Lục Đinh tinh - chủ về họa hại hiệu lệnh
                    ("Thiên Nhậm", 8),  // Lục Bính tinh - chủ về âm hình của bậc nữ chúa
                    ("Thiên Anh", 9)]; // Lục Ất tinh - chủ về dương đức của bậc quân nhân

    public let DIA_CHI : [(Text, Nat)] = [
        (CHI.TY, 1), (CHI.SUU, 2), (CHI.DAN, 3), (CHI.MAO, 4), (CHI.THIN, 5), (CHI.TI, 6), 
        (CHI.NGO, 7), (CHI.MUI, 8), (CHI.THAN, 9), (CHI.DAU, 10), (CHI.TUAT, 11), (CHI.HOI, 12)
    ];

    private func move(max : Nat, s : Nat, step : Int) : Nat {
        var ret = s;
        var count = step;
        let flag = if (step < 0) (1) else (-1);
        let m = if (step < 0) dec else inc;
        while (count != 0) {
            ret := m(max, ret);
            count += flag;
        };
        return ret;
    };

    private func inc(max : Nat, i : Nat) : Nat {
        if (i >= max) return 0;
        return i + 1;
    };

    private func dec(max : Nat, i : Nat) : Nat {
        if (i == 0) return max;
        return i - 1;
    };

    private func _move_luc_thap_hoa_giap(_can : ?Nat, _chi : ?Nat, _stop : ?Nat, callback : (Nat, Text, Text) -> ()) : () {
        var can = switch (_can) {
            case (?v) v;
            case null 1;
        };
        var chi = switch (_chi) {
            case (?v) v;
            case null 1;
        };
        let stop = switch (_stop) {
            case (?v) v;
            case null 60;
        };
        var index = 0;
        while (index < stop) {
            index := index + 1;
            callback(index, THIEN_CAN[can - 1].0, DIA_CHI[chi - 1].0);
            can := if (can == 10) 1 else (can + 1);
            chi := if (chi == 12) 1 else (chi + 1);
        };
    };

    public func thai_at_vuong_tuong_huu_tu() : (Text) {
        let _8_tiet = ["Đông Chí", "Lập Xuân", "Xuân Phân", "Lập Hạ", "Hạ Chí", "Lập Thu", "Thu Phân", "Lập Đông"];
        let state_titles = [("Vượng", 0), ("Tướng", 1), ("Thai", 2), ("Một", 3), ("Tù", 4), ("Tử", 5), ("Hưu", 6), ("Phế", 7)];
        let _dong_chi_state = [1, 8, 3, 4, 9, 2, 7, 6];
        let state = Buffer.Buffer<[Nat]>(0);
        state.add(_dong_chi_state);
        for (i in Iter.range(1, 7)) {
            var index = i;
            var s = Array.tabulate<Nat>(8, func (j : Nat) : Nat {
                let x = _dong_chi_state[index];
                index := move(7, index, 1);
                (x);
            });
            state.add(s);
        };
        var output = "";
        for (i in Iter.range(0, _8_tiet.size() - 1)) {
            let s = state.get(i);
            output #= "\n" # _8_tiet[i];
            for (j in Iter.range(0, state_titles.size() - 1)) {
                output #= " " # Nat.toText(s[j]);
            };
        };
        return output;
    };

    let find_bat_mon = func (bat_mon : [(Text, (Text, Nat))], cung : (Text, Nat)) : Text {
        switch (Array.find<(Text, (Text, Nat))>(bat_mon, func (x : (Text, (Text, Nat))) : Bool = (x.1.0 == cung.0 and x.1.1 == cung.1))) {
            case (?(mon, _)) return mon;
            case null return "";
        };
        "";
    };
    
    public func thai_at(year : Int) : async (Text) {
        let buf = Buffer.Buffer<Text>(0);
        let t = ThaiAt(year);
        let thai_at = t.tim_thai_at();
        let (truc_su, bat_mon) = t.bat_mon();
        buf.add("Số năm từ Thượng cổ Giáp Tý đến " #debug_show(year) # ": " # debug_show(t.tich_nien()));
        buf.add("Tuế Kế: " # debug_show(t.tue_ke()));
        buf.add("Vị trí Thái Ất: " # debug_show() # " -> Môn: " # (find_bat_mon(bat_mon, thai_at.cung)));
        buf.add("Kỷ nguyên Giáp Tý: " # debug_show(t.tim_ky_nguyen_giap_ty()));
        buf.add("Cục : " # debug_show(t.tinh_cuc()));
        buf.add("Vị trí Kế Thần: " # debug_show(t.tim_ke_than()));
        buf.add("Vị trí Thiên Mục/Văn Xương: " # debug_show(t.tim_thien_muc_van_xuong()));
        buf.add("Vị trí Khách Mục Thủy Kích: " # debug_show(t.tim_khach_muc_thuy_kich()));
        buf.add("Bát Môn: " # debug_show(bat_mon));
        let (info, chu_khach) = t.tim_chu_khach();
        buf.add("Tìm Chủ - Khách: " # debug_show(chu_khach));
        buf.add("Tìm Chủ - Khách Info: " # debug_show(info));
        let dai_tuong = t.tim_dai_tuong();
        buf.add("Tìm Đại Tướng: " # debug_show(dai_tuong));
        for (dt in dai_tuong.vals()) {
            buf.add("\n  - " # debug_show(dt) # " -> Môn: " # (find_bat_mon(bat_mon, dt.1)));
        };
        buf.add("Đại du Thái Ất: " # debug_show(t.dai_du_thai_at()));
        buf.add("Tiểu du Thái Ất: " # debug_show(t.tieu_du_thai_at()));
        buf.add("Tìm Chủ - Khách: " # debug_show(t.tim_chu_khach_1()));
        Text.join("\n----------------------------\n", buf.vals())
    };

    public func from_to(year_from : Int, year_to : Int) : async (Text) {
        let buf = Buffer.Buffer<Text>(0);
        var i = year_from;
        while (i <= year_to) {
            let info = Buffer.Buffer<Text>(0);
            let t = ThaiAt(i);
            let thai_at = t.tim_thai_at();
            let thai_at_cung = thai_at.cung;
            let (_, ke_than) = t.tim_ke_than();
            let (cuc, _, _) = t.tinh_cuc();
            let van_xuong = t.tim_thien_muc_van_xuong();
            let (_, thuy_kich) = t.tim_khach_muc_thuy_kich();
            let (_, chu_khach) = t.tim_chu_khach();
            let (truc_su, bat_mon) = t.bat_mon();
            info.add("Số năm từ Thượng cổ Giáp Tý đến " #debug_show(i) # ": " # debug_show(t.tich_nien()));
            info.add("Vị trí Thái Ất: " # debug_show(thai_at_cung) # " -> Môn: " # (find_bat_mon(bat_mon, thai_at.cung)));
            info.add("Kỷ nguyên Giáp Tý: " # debug_show(t.tim_ky_nguyen_giap_ty()));
            info.add("Cục : " # debug_show(cuc));
            info.add("Vị trí Kế Thần: " # debug_show(ke_than));
            info.add("Vị trí Thiên Mục/Văn Xương: " # debug_show(van_xuong));
            info.add("Vị trí Khách Mục/Thủy Kích: " # debug_show(thuy_kich));
            info.add("Bát Môn: " # debug_show(bat_mon));
            info.add("Tìm Chủ - Khách: " # debug_show(chu_khach));
            let dai_tuong = t.tim_dai_tuong();
            info.add("Tìm Đại Tướng: " # debug_show(dai_tuong));
            for (dt in dai_tuong.vals()) {
                info.add("\n  - " # debug_show(dt) # " -> Môn: " # (find_bat_mon(bat_mon, dt.1)));
            };
            info.add("Đại du Thái Ất: " # debug_show(t.dai_du_thai_at()));
            info.add("Tiểu du Thái Ất: " # debug_show(t.tieu_du_thai_at()));
            info.add("Tìm Chủ - Khách: " # debug_show(t.tim_chu_khach_1()));
            
            buf.add(Text.join("\n", info.vals()));
            i += 1;
        };
        Text.join("\n----------------------------\n", buf.vals())
    };

    public class ThaiAt(year : Int) {
        // Thái ất du hành qua 8 cung (không vào 5) khởi từ Càn (1) tới Tốn (9) mỗi cung ở lại 3 năm
        // Lẻ 1 là Lý Thiên
        // Lẻ 2 là Lý Địa
        // Lẻ 3 là Lý Nhân
        let NAM_NGUYEN_2821 : Int = 1683;
        let tich_nien_GIAP_TI_THUONG_CO_to_1683 = 2821 * 3600; // 10.155.600

        // 72 / 6 = 12 (chi)
        // 360 / 72 = 5 (5 tí) | 360 / 60 = 6

        // public func get() : Text {
        //     let thaiAt = {
        //         tich_nien = tich_nien();
        //         tue_ke = tue_ke();
        //         thai_at = tim_thai_at();
        //         ky_nguyen_giap_ty = tim_ky_nguyen_giap_ty();
        //     };
        //     return (debug_show(thaiAt))
        // };

        public func tich_nien() : Nat {
            // T(1683) = (3600 * 2821)
            //
            //Để tính từ Giáp Tý thượng cổ đến năm hiện tại : 
            // T(Y) = T(1683) + (Y - 1683)

            //  Xem ngược về những năm đã qua -> Giảm 1 số
            //  Xem xuôi về những năm sắp tới -> Tăng 1 số

            let t = tich_nien_GIAP_TI_THUONG_CO_to_1683 + (year - NAM_NGUYEN_2821);
            if (year < 0) return Int.abs(t + 1);
            return Int.abs(t);
        };

        public func tue_ke() : Nat {
            // Phép Tuế Kế lấy TK(Y) = T(Y) % 360
            var t = tich_nien() % 3600;
            if (t > 360) {
                t := t % 360;
            };
            return t;
        };

        public func tim_thai_at() : {cung : (Text, Nat); stayed_year : Nat} {
            /***
            * Tìm Thái Ất
            *   Do Thái ất du hành qua 8 cung (không vào 5) 
            *   khởi từ Càn (1) tới Tốn (9) mỗi cung ở lại 3 năm nên chia cho 24 (8 * 3) để tìm vị trí.
            ***/
            var tk = tue_ke() % 24;
            if (tk == 0) tk := 24; // tròn 24 năm

            var cung_index = 0; // Khởi Càn
            var nam = tk;
            while (nam > 3) {
                cung_index := move(8, cung_index, 1);
                if (cung_index != 4) nam -= 3; // không phải trung cung
            };
            let stayed = if (nam % 3 == 0) (3) else (nam % 3);
            return {
                cung = BAT_QUAI[cung_index];
                stayed_year = stayed;
            };
        };

        private func _dai_du_thai_at(n : Nat) : Text {
            let result = Nat.toText(n) # (if (n == 1 or n == 11 or n == 21) {
                                " -> Bất lợi cho vua";
                            } else if (n == 2 or n == 12 or n == 22 or n == 32) {
                                " -> bất lợi cho vương hầu, các bề tôi tướng tể";
                            } else if (n == 3 or n == 13 or n == 23 or n == 33) {
                                " -> bất lợi cho hậu phi";
                            } else if (n == 4 or n == 14 or n == 34) {
                                " -> bất lợi cho thái tử";
                            } else if (n == 5 or n == 15 or n == 25) {
                                " -> bất lợi cho dân";
                            } else if (n == 6 or n == 16 or n == 26 or n == 36) {
                                " -> bất lợi cho tướng soái";
                            } else if (n == 7 or n == 17 or n == 27 or n == 37) {
                                " -> Bất lợi cho thượng tướng";
                            } else if (n == 8 or n == 18 or n == 28 or n == 38) {
                                " -> Bất lợi cho trung tướng";
                            } else if (n == 9 or n == 19 or n == 29 or n == 39) {
                                " -> Bất lợi cho hạ tướng";
                            } else if (n == 10 or n == 20 or n == 30) {
                                " -> Bất lợi cho quân lính";
                            } else {
                                let ngu_phuc = "Đại Du gặp Ngũ Phúc thì tai họa binh đao giáng vào địa phận đối xung";
                                let thai_at = "Đại Du cùng Thái Ất thì địa phận năm đó có binh đao lớn, trời biến động nhiều sự quái dị";
                                let dia_at = "Đại Du cùng Địa Ất thì giặc dã, trộm cướp, sâu bệnh";
                                let truc_phu = "Đại Du cùng Trực Phù thì đao binh, hỏa hoạn, hạn hán";
                                let tu_than = "Đại Du cùng Tứ Thần thì hạn lụt, đối rét";
                                let tieu_du = "Đại Du cũng Tiểu Du thì binh đao, lụt, hạn, tai họa lớn lao";
                                ("");
                            });
            return result;
        };

        public func dai_du_thai_at() : ((Nat, Nat), (Text, Nat), Text) {
            // Tính Đại Du Thái Ất - ở 1 cung 36 năm (12 năm lý thiên, 12 năm lý địa, 12 năm lý nhân)
            // từ thượng nguyên đưa vào sai số cung 34 (tức thêm vào 34)
            var cung_chu = (tich_nien() + 34) % 2880; // 288 = 36 (nam) * 8 (cung)
            cung_chu %= 288;

            var cung_index = 6; // Khởi Khôn - cung 7
            var dai_du = cung_chu;
            while (dai_du > 36) {
                cung_index := move(8, cung_index, 1);
                if (cung_index != 4) dai_du -= 36; // không phải trung cung
            };
            ((cung_chu, dai_du), BAT_QUAI[cung_index], _dai_du_thai_at(dai_du));
        };

        public func tieu_du_thai_at() : (Text, Nat) {
            // Tính Tiểu Du Thái Ất 
            // Mốc 714 - Tiểu Du ở Càn (1) - 36 năm đi qua 1 cung
            // Mốc 930 - Tiểu Du ở Khôn (7)...
            let direction = if (year < 714) -1 else 1;
            var tieu_du = (year - 714) * direction;
            var cung_index = 0;
            while (tieu_du > 36) {
                cung_index := move(8, cung_index, direction);
                if (cung_index != 4) tieu_du -= 36; // không phải trung cung
            };
            return (BAT_QUAI[cung_index]);
        };

        public func tim_ky_nguyen_giap_ty() : (Text, Nat, Text) {
            let tueKe = tue_ke();
            var ky_nguyen = tueKe / 60;
            if (tueKe % 60 != 0) {
                // chưa đủ 60 năm
                ky_nguyen := ky_nguyen + 1;
            };
            let ky_nguyen_name = if (ky_nguyen % 3 == 0) {
                                        "Hạ nguyên";
                                    } else if (ky_nguyen % 3 == 1) {
                                        "Thượng nguyên";
                                    } else {
                                        "Trung nguyên";
                                    };
            var current_year = "";
            _move_luc_thap_hoa_giap(null, null, null, func (index : Nat, can : Text, chi : Text) : () {
                if (index == (tueKe % 60)) {
                    current_year := can # " " # chi;
                };
            });
            return (ky_nguyen_name, tueKe % 60, current_year)
        };

        public func bat_mon() : (Text, [(Text, (Text, Nat))]) {
            /*
            *   Lấy tích niên, dùng phép đại tiểu chu % 2400, lớn hơn 240 thì dùng phép tiểu chu % 240,
            *   số dư nhỏ hơn 240 thì trừ dần đi 30 đồng thời đếm từ Khai môn, đến khi < 30, dừng ở Môn
            *   nào thì lấy môn đó làm Trực Sử, đưa về vị trí (gia) Thái Ất, rồi đếm thuận an các cung còn lại
            *   theo chiều kim đồng hồ.
            */
            var du = tich_nien() % 2400;
            if (du > 240) du %= 240;
            var mon_index = 0; // Khai môn
            while (du > 30) {
                mon_index := move(7, mon_index, 1);
                du -= 30;
            };
            let truc_su = BAT_MON[mon_index];
            let bat_mon = Buffer.Buffer<(Text, (Text, Nat))>(0);
            let thai_at = tim_thai_at();
            var thai_at_index = switch (Array.indexOf(thai_at.cung, CLOCK_BAT_QUAI, func (x : (Text, Nat), y : (Text, Nat)) : Bool {
                return x.0 == y.0 and x.1 == y.1;
            })) {
                case (?p) p;
                case null Debug.trap("Không tìm thấy vị trí Thái Ất: Kiểm tra lại mapping giữa BAT_QUAI[] và CLOCK_BAT_QUAI[]");
            };
            for (i in Iter.range(0, 7)) {
                bat_mon.add((BAT_MON[mon_index].0, CLOCK_BAT_QUAI[thai_at_index]));
                mon_index := move(7, mon_index, 1);
                thai_at_index := move(7, thai_at_index, 1);
            };
            (truc_su.0, Buffer.toArray(bat_mon));
        };

        public func phuong_vi_phuc_tinh() : (Text) {
            let tueKe = tue_ke();
            var phuc_tinh = "";
            _move_luc_thap_hoa_giap(null, null, null, func (index : Nat, can : Text, chi : Text) : () {
                if (index == (tueKe % 60)) {
                    phuc_tinh := (if (can == "Giáp") {
                        CHI.DAN
                    } else if (can == "Ất") {
                        CHI.SUU
                    } else if (can == "Bính") {
                        // Bính ở Tý
                        CHI.TY
                    } else if (can == "Đinh") {
                        CHI.HOI
                    } else if (can == "Mậu") {
                        CHI.THAN
                    } else if (can == "Kỷ") {
                        CHI.MUI
                    } else if (can == "Canh") {
                        CHI.NGO
                    } else if (can == "Tân") {
                        //  Tân ở Tị
                        CHI.TI
                    } else if (can == "Nhâm") {
                        CHI.THIN
                    } else if (can == "Quý") {
                        CHI.MAO
                    } else (""));
                };
            });
            return phuc_tinh;
        };

        public func tinh_cuc() : (Nat, Text, Text) {
            /*
            Cục năm 2026:
            Lấy TK(2026) chia dư 72 = 343 % 72 = 4 * 72 + 55 dùng phép 5 Tí (Giáp(1) - Bính(2) - Mậu(3) - Canh(4) - Nhâm(5)) 
            => Bắt đầu ở nguyên Nhâm Tí đi đến Bính Ngọ là 55 (12 * 4 (Nhâm(1) + Giáp(2) + Bính(3) + Mậu(4) + Canh(5)) + 7)
            tức là Thái Ất đi vào Nguyên Nhâm Tí cục 55
            */
            let tueKe = tue_ke();
            let phep_5_ti = (tueKe / 72);
            // 5 tí = giáp tý - bính tý - mậu tý - canh tý - nhâm tý, mỗi tý cách nhau 12 năm
            let can_index = phep_5_ti * 2;
            let chi_index = 0; // tý
            let nguyen = THIEN_CAN[can_index].0 # " " # DIA_CHI[chi_index].0;
            var current_year = "";
            _move_luc_thap_hoa_giap(?THIEN_CAN[can_index].1, ?1, ?72, func (index : Nat, can : Text, chi : Text) : () {
                if (index == (tueKe % 72)) {
                    // found
                    current_year := can # " " # chi;
                };
            });
            let cuc = if (tueKe % 72 == 0) (72) else (tueKe % 72); 
            return (cuc, nguyen, current_year);
        };

        type CACH_TINH = {
            #nien_ke;
            #nguyet_ke;
            #nhat_ke;
            #thoi_ke;
        };
        let tiet_khi = "Đông Chí"; //"Hạ Chí";
        let is_thoi_ke = false; 
        
        public func tim_ke_than() : (Int, (Text, Nat)) {
            let nMove : Int = tich_nien() % 12;
            // Khởi từ Dần là Giáp Tý đếm ngược n cung dừng ở đâu Kế Thần ở đó
            // Duy chỉ có Thời kế - từ Hạ chí dùng cục âm : Khởi từ Thân là Giáp Tý đếm ngược lại.
            let start_cung_index = if (is_thoi_ke and tiet_khi == "Hạ Chí") (8) else (2); // Dần
            let direction = -1;
            // Tính từ cung hiện tại là 1 nên nMove giảm 1
            let step = (nMove - 1) * direction;
            let cung_ke_than_index = move(11, start_cung_index, step);
            return (nMove, DIA_CHI[cung_ke_than_index]);
        };

        public func tim_thien_muc_van_xuong() : (Text, Nat) { 
            /*
                Tìm Thiên Mục (Văn Xương / Chủ mục)

                Khởi từ cung Thân, trong khoảng 16 cung tính thuận, đến cung Càn, 
                cung Khôn thì lưu lại 2 số. Âm cục khởi từ cung Dần, tính đến cung Cấn, cung Tốn, cũng lưu lại 2 số. 
                Tích số của năm chia cho 18; số dư đếm đến cung nào Văn xương ở cung ấy.

                Năm tháng ngày giờ đều như vậy, duy chỉ có tìm cho giờ sau Hạ chí dùng cục Âm, 
                khởi từ Dần, cũng tính thuận, theo mười sáu Thần; gặp cung Cấn, cung Tốn đếm 2 lần. 
            */
            var tm = tich_nien() % 18;
            if (tm == 0) tm := 18; // tròn 18

            let start = if (is_thoi_ke and tiet_khi == "Hạ Chí") (6) else (14); // DIA_BAN 6 = dần; DIA_BAN 14 = thân 
            var count = 1;
            var dia_ban_index = start - 1;
            while (count < tm) {
                dia_ban_index := move(15, dia_ban_index, 1);
                if (start == DIA_BAN[14 - 1].1) {
                    // khởi Thân gặp Càn(1) - Khôn(13) thì +2
                    if (dia_ban_index == 0 or dia_ban_index == 12) {
                        count := count + 1;
                    };
                } else if (start == DIA_BAN[6 - 1].1) {
                    // Khởi Dần gặp Cấn(5) - Tốn(9) thì +2
                    if (dia_ban_index == 4 or dia_ban_index == 9) {
                        count := count + 1;
                    };
                };
                count := count + 1;
            };
            return DIA_BAN[dia_ban_index];
        };

        public func tim_khach_muc_thuy_kich() : ([(Text, Text)], (Text, Nat)) {
            /*
                Tìm Thủy Kích (Khách mục)
                Giống phép Thời Kế, dùng cách này để an vị Khách là kỳ binh và nghe ngóng (tình hình) quân giặc, 
                để chuẩn bị nơi sở tại. Thủy Kích còn có tên là Địa Mục.

                Kế Thần ở đâu đưa Cấn - Hòa Đức về đó, đếm thuận đến nơi Văn Xương ở, tức Thủy Kích ở đó.

                Thủy kích năm Canh Ngọ - 1570 : 
                Kế Thần ở Thân, đưa Cấn - Hòa Đức về Thân, đếm thuận Dậu là Dần, Tuất là Mão, Càn là Thìn, 
                Hợi là Tốn, Tí là Tỵ, Sửu là Ngọ, Cấn là Mùi, Dần là Khôn, Mão là Thân, Thìn là Dậu, Tốn là Tuất. 
                Văn Xương năm ấy ở Tốn, lâm vào Âm chủ, tức năm Canh Ngọ Thủy Kích ở Tuất, âm chủ.
            */
            let (_, (index, diaChi)) = tim_ke_than();
            let vitriKeThan = Array.indexOf((index, diaChi), DIA_BAN, func (a : (Text, Nat), b : (Text, Nat)) : Bool {
                return a.0 == b.0;
            });
            let ke_than_index = switch (vitriKeThan) {
                case null Debug.trap("Cannot find vị trí Kế Thần");
                case (?v) v;
            };
            let vanXuong = tim_thien_muc_van_xuong();
            var can_hoa_duc_index = ke_than_index;
            var thuy_kich_index = 4;
            let buf = Buffer.Buffer<(Text, Text)>(0);
            // let map = HashMap.HashMap<Nat, (Text, Nat)>(0, Nat.equal, Hash.hash);
            while (can_hoa_duc_index != vanXuong.1 - 1) {
                buf.add((DIA_BAN[can_hoa_duc_index].0, DIA_BAN[thuy_kich_index].0));
                
                // map.put(can_hoa_duc_index, THAP_LUC_THAN[thuy_kich_index]);

                can_hoa_duc_index := move(15, can_hoa_duc_index, 1);
                thuy_kich_index := move(15, thuy_kich_index, 1);
            };
            return ([], DIA_BAN[thuy_kich_index]);
        };

        public func tim_chu_khach() : ([(((Text, Text), Nat), (Nat))], (Nat, Nat)) {
            let DIA_BAN_BAT_QUAI_INDEX = [  // map DIA_BAN 16 vi trí sang địa bàn 12 cung
                ((CAN_KIM.0, CHI.HOI), 1),      // index: 0
                ((KHAM_THUY.0, CHI.TY), 8),
                ((CHI.SUU, CHI.SUU), 0),
                ((CAN_THO.0, CHI.DAN), 3),      // index: 3
                ((CHAN_MOC.0, CHI.MAO), 4),
                ((CHI.THIN, CHI.THIN), 0),
                ((TON_MOC.0, CHI.TI), 9),       // index: 6
                ((LY_HOA.0, CHI.NGO), 2),
                ((CHI.MUI, CHI.MUI), 0),
                ((KHON_THO.0, CHI.THAN), 7),    // index: 9
                ((DOAI_KIM.0, CHI.DAU), 6),
                ((CHI.TUAT, CHI.TUAT), 0),
            ];

            let vanXuong = tim_thien_muc_van_xuong();
            let (_, thuyKich) = tim_khach_muc_thuy_kich();
            let thaiAt = tim_thai_at();

            let batquaiValue = HashMap.fromIter<Text, Nat>(BAT_QUAI.vals(), BAT_QUAI.size(), Text.equal, Text.hash);
            let diachiValue = HashMap.fromIter<Text, Nat>(BAT_QUAI.vals(), BAT_QUAI.size(), Text.equal, Text.hash);
            for ((item, _) in DIA_BAN_BAT_QUAI_INDEX.vals()) {
                let val = Option.get(batquaiValue.get(item.0), 0);
                diachiValue.put(item.1, val);
            };

            let getCungValue = func (name : Text) : (Nat) {
                switch (batquaiValue.get(name)) {
                    case (?value) {
                        return value;
                    };
                    case (null) {
                        switch (diachiValue.get(name)) {
                            case (?value) {
                                // Gián thần: Dần, Thân, Tị, Hợi, Thìn, Tuất, Sửu, Mùi
                                if (name == CHI.DAN or 
                                    name == CHI.THAN or 
                                    name == CHI.TI or 
                                    name == CHI.HOI or
                                    name == CHI.THIN or 
                                    name == CHI.TUAT or 
                                    name == CHI.SUU or 
                                    name == CHI.MUI) return 1;
                                return value;
                            };
                            case null Debug.trap("Cung name is not exist! => " # name);
                        };
                    };
                };
            };

            let findCungIndex = func (cung_name : Text) : (Text, Nat, Nat) {
                let value = getCungValue(cung_name);
                for (i in Iter.range(0, DIA_BAN_BAT_QUAI_INDEX.size() - 1)) {
                    let ((name, chi_name), _) = DIA_BAN_BAT_QUAI_INDEX[i];
                    if (cung_name == name or cung_name == chi_name) return (cung_name, i, value);
                };
                (cung_name, 0, value);
            };

            let (thai_at_cung_name, thai_at_cung_vitri, _) = findCungIndex(thaiAt.cung.0);
            let cung_before_thai_at = move(11, thai_at_cung_vitri, -1);
            
            let buf = Buffer.Buffer<(((Text, Text), Nat), (Nat))>(0);
            // chủ đếm từ văn xương đến cung trước thái ất

            buf.add((("Tìm Chủ - Khởi Văn Xương", ""), 0), (0));
            
            var cungIndex = findCungIndex(vanXuong.0);
            var chu = cungIndex.2;
            buf.add(DIA_BAN_BAT_QUAI_INDEX[cungIndex.1], cungIndex.2);
            if (_check_thai_at(thai_at_cung_name, thai_at_cung_vitri, cungIndex.0, cungIndex.1) or cungIndex.1 == cung_before_thai_at) {
                ();
            } else {
                var p = cungIndex.1;
                while (p != cung_before_thai_at) {
                    p := move(11, p, 1);
                    let val = DIA_BAN_BAT_QUAI_INDEX[p].1;
                    chu += val;
                    buf.add(DIA_BAN_BAT_QUAI_INDEX[p], val);
                };
            };
            // tính đến cung trước thái ất
            
            buf.add((("----------------------------------------", ""), 0), (0));
            // khách đếm từ thủy kích đến trước cung thái ất
            buf.add((("Tìm Khách - Khởi Thủy Kích", ""), 0), (0));

            cungIndex := findCungIndex(thuyKich.0);
            var khach = cungIndex.2;
            buf.add(DIA_BAN_BAT_QUAI_INDEX[cungIndex.1], cungIndex.2);
            if (_check_thai_at(thai_at_cung_name, thai_at_cung_vitri, cungIndex.0, cungIndex.1) or cungIndex.1 == cung_before_thai_at) {
                ();
            } else {
                var p = cungIndex.1;
                while (p != cung_before_thai_at) {
                    p := move(11, p, 1);
                    let val = DIA_BAN_BAT_QUAI_INDEX[p].1;
                    khach += val;
                    buf.add(DIA_BAN_BAT_QUAI_INDEX[p], val);
                };
            };

            return (Buffer.toArray<(((Text, Text), Nat), (Nat))>(buf), (chu, khach));
        };

        private func _check_thai_at(thai_at_cung_name : Text, 
                                    thai_at_cung_vitri : Nat, 
                                    chu_khach_muc_cung_name : Text, 
                                    chu_khach_muc_cung_vitri : Nat) : Bool {
            if (thai_at_cung_vitri == chu_khach_muc_cung_vitri){
                if (thai_at_cung_name == chu_khach_muc_cung_name) {
                    // trường hợp vào bát quái
                    return true;
                } else if (chu_khach_muc_cung_name != CHI.HOI and 
                    chu_khach_muc_cung_name != CHI.DAN and 
                    chu_khach_muc_cung_name != CHI.THAN and 
                    chu_khach_muc_cung_name != CHI.TI) {
                    // trường hợp cùng cung nhưng là địa chi

                    // Nếu Thiên Mục/ Văn Xương hoặc Thủy Kích/ Khách mục cùng vị trí với Thái Ất nhưng rơi vào chi
                    // trường hợp là Đoài/Dậu - Khảm/Tý - Ly/Ngọ - Mão/Chấn -> cùng cung với thái ất
                    return true;
                };
            };
            return false;
        };

        public func tim_dai_tuong() : ([(Text, (Text, Nat))]) {
            /*
                ĐT(Y) = (Chủ || Khách) % 10
                Tính Đại Tướng dùng Chủ/ Khách % 10, số lẻ là cung an. 
                Nếu Chủ/ Khách là 10 thì lấy 10 - 9 = 1 (bỏ 10 lấy 1), an tại cung số 1.
                Tính Tham Tướng thì dùng kết quả tính Đại Tướng nhân 3, lấy số lẻ. Tính Phát, Bách, Tù, Quan để xem tốt xấu.

                VD : Tìm Đại Tướng - Tham Tướng năm Canh Ngọ - 1570 => Chủ = 33 - Khách = 10
                - Chủ Đại Tướng = 33 % 10 = 3 cung Cấn cùng cung với Thái Ất => Tù, có tang vong, điều xấu.
                - Chủ Tham Tướng = 3 * 3 = 9 cung Tốn cùng cung với Văn Xương => Tù, xấu.

                - Khách Đại Tướng = 10 - 9 = 1 cung Càn => Lành, tướng phát vì không gặp Tù, Bách, Yểm, Kích..
                - Khách Tham Tướng  = 1 * 3 = 3 cung Cấn cùng cung với Thái Ất => Tù, tiểu tướng bất lợi.

                Cục này Thái Ất trợ Chủ, nhưng chủ bất hòa, 2 tướng gặp Tù, nên không thể hành động. Khách hòa, tướng phát => Lợi về Khách. Chủ nên an cư, hành động sau.

                Từ Càn đến Thìn là Trong. Từ Tốn đến Tuất là Ngoài
                Thái Ất ở cung 1, 8, 3, 4 là Thiên Nội là trợ Chủ, không thể đem quân công phạt, muốn đánh địch không nên khởi động trước.
                Thái Ất ở cung 9, 2, 7, 6 là Thiên Ngoại là trợ Khách, lợi cho việc lấy binh đánh dẹp, muốn đánh địch, không nên tiến sau mà phải đánh trước.

            */

            let (_, (chu, khach)) = tim_chu_khach();
            ignore if (chu == 0) ("Vô địa");
            ignore if (khach == 0) ("Vô địa");
            var chu_dai_tuong = if (chu % 10 == 0) (chu / 10) else (chu % 10);
            // if (chu_dai_tuong == 0) chu_dai_tuong += 1;
            var chu_tham_tuong = if ((chu_dai_tuong * 3) % 10 == 0) 1 else ((chu_dai_tuong * 3) % 10);

            var khach_dai_tuong = if (khach % 10 == 0) (khach / 10) else (khach % 10); 
            // if (khach_dai_tuong == 0) khach_dai_tuong += 1;
            var khach_tham_tuong = if ((khach_dai_tuong * 3) % 10 == 0) 1 else ((khach_dai_tuong * 3) % 10);
            return [
                ("Chủ Đại Tướng", BAT_QUAI[chu_dai_tuong - 1]),
                ("Chủ Tham Tướng", BAT_QUAI[chu_tham_tuong - 1]),
                ("Khách Đại Tướng", BAT_QUAI[khach_dai_tuong - 1]),
                ("Khách Tham Tướng", BAT_QUAI[khach_tham_tuong - 1])
            ];
        };

        public func tim_chu_khach_1() : (Nat, Nat) {

            let vanXuong = tim_thien_muc_van_xuong();
            let (_, thuyKich) = tim_khach_muc_thuy_kich();
            let thaiAt = (tim_thai_at()).cung;
            let cungThaiAt = Option.get(Array.indexOf(thaiAt, CLOCK_BAT_QUAI, func (x : (Text, Nat), y : (Text, Nat)) : Bool = (x.0 == y.0 and x.1 == y.1)), thaiAt.1 - 1);
            let cungTruocThaiAt = move(7, cungThaiAt, -1);

            let findCungIndex = func (cung_dia_ban : (Text, Nat)) : (Nat, Nat) {
                                    let name = cung_dia_ban.0; // DIA_BAN
                                    switch(Array.indexOf(cung_dia_ban, CLOCK_BAT_QUAI, func (x : (Text, Nat), y : (Text, Nat)) : Bool = (x.0 == y.0))) {
                                        case (?vitri) (vitri, CLOCK_BAT_QUAI[vitri].1);
                                        case null {
                                            let cung = if (name == CHI.MUI or name == CHI.THAN) {KHON_THO} 
                                                        else if (name == CHI.TI or name == CHI.THIN) {TON_MOC}
                                                        else if (name == CHI.HOI or name == CHI.TUAT) {CAN_KIM}
                                                        else if (name == CHI.SUU or name == CHI.DAN) {CAN_THO}
                                                        else if (name == CHI.MAO) {CHAN_MOC}
                                                        else if (name == CHI.NGO) {LY_HOA}
                                                        else if (name == CHI.DAU) {DOAI_KIM}
                                                        else {KHAM_THUY};

                                            let cungIndex = Option.get(Array.indexOf(cung, 
                                                                                     CLOCK_BAT_QUAI, 
                                                                                     func (x : (Text, Nat), y : (Text, Nat)) : Bool = (x.0 == y.0)), 0);

                                            let cungValue = if (name == CHI.DAN or name == CHI.THAN or 
                                                                name == CHI.TI or name == CHI.HOI or
                                                                name == CHI.THIN or name == CHI.TUAT or 
                                                                name == CHI.SUU or name == CHI.MUI) {
                                                                // Gián thần: Dần, Thân, Tị, Hợi, Thìn, Tuất, Sửu, Mùi
                                                                (1)
                                                            } else {
                                                                (cung.1)
                                                            };
                                            (cungIndex, cungValue);
                                        };
                                    };
                                };

            let cungVanXuong = findCungIndex(vanXuong);

            let cungThuyKich = findCungIndex(thuyKich);

            let chu = if (cungVanXuong.0 == cungThaiAt) {
                cungVanXuong.1;
            } else {
                var vitri = cungVanXuong.0;
                var c = cungVanXuong.1;
                while (vitri != cungTruocThaiAt) {
                    vitri := move(7, vitri, 1);
                    c += CLOCK_BAT_QUAI[vitri].1;
                };
                c;
            };

            let khach = if (cungThuyKich.0 == cungThaiAt) {
                cungThuyKich.1;
            } else {
                var vitri = cungThuyKich.0;
                var c = cungThuyKich.1;
                while (vitri != cungTruocThaiAt) {
                    vitri := move(7, vitri, 1);
                    c += CLOCK_BAT_QUAI[vitri].1;
                };
                c;
            };
            (chu, khach);
        };
    };
};
