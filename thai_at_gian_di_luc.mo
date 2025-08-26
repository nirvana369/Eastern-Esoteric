
/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : thai_at_gian_di_luc.mo
* Description       : Thái Ất thần số - Tam thức học
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 26/08/2025		nirvana369 		implement
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
    let CAN_KIM = (1, "Càn");
    let LY_HOA = (2, "Ly");
    let CAN_THO = (3, "Cấn");
    let CHAN_MOC = (4, "Chấn");
    let TRUNG = (5, "Trung");
    let DOAI_KIM = (6, "Đoài");
    let KHON_THO = (7, "Khôn");
    let KHAM_THUY = (8, "Khảm");
    let TON_MOC = (9, "Tốn");
    let BAT_QUAI = [CAN_KIM,
                    LY_HOA, 
                    CAN_THO, 
                    CHAN_MOC,
                    TRUNG,
                    DOAI_KIM, 
                    KHON_THO, 
                    KHAM_THUY, 
                    TON_MOC];
    
    let CLOCK_BAT_QUAI = [CAN_KIM, KHAM_THUY, CAN_THO, CHAN_MOC, TON_MOC, LY_HOA, KHON_THO, DOAI_KIM];

    let CHI = {
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

    let DIA_BAN : [(Nat, Text)] = [
        (1, CAN_KIM.1), (2, CHI.HOI), (3,CHI.TY), (4,CHI.SUU), (5, CAN_THO.1), (6,CHI.DAN), 
        (7,CHI.MAO), (8,CHI.THIN), (9, TON_MOC.1), (10,CHI.TI), (11,CHI.NGO), (12,CHI.MUI),
        (13, KHON_THO.1), (14,CHI.THAN), (15,CHI.DAU), (16,CHI.TUAT)
    ];

    let THAP_LUC_THAN : [(Nat, Text)] = [
        (1,"Âm Đức"), (2,"Đại nghĩa"), (3,"Địa Chu"), (4,"Dương Đức"), (5,"Hòa Đức"), (6,"Lã Thân"), 
        (7,"Cao Tùng"), (8,"Thái Dương"), (9,"Đại Trắc"), (10,"Đại Thần"), (11,"Thiên Uy"), (12,"Thiên Đạo"), 
        (13,"Đại Vũ"), (14,"Vũ Đức"), (15,"Thái Thốc"), (16,"Âm Chủ")
    ];

    let THIEN_CAN : [(Nat, Text)] = [
        (1,"Giáp"), (2,"Ất"), (3,"Bính"), (4,"Đinh"), (5,"Mậu"), (6,"Kỷ"), 
        (7,"Canh"), (8,"Tân"), (9,"Nhâm"), (10,"Quý")
    ];

    let DIA_CHI : [(Nat, Text)] = [
        (1,CHI.TY), (2,CHI.SUU), (3,CHI.DAN), (4,CHI.MAO), (5,CHI.THIN), (6,CHI.TI), 
        (7,CHI.NGO), (8,CHI.MUI), (9,CHI.THAN), (10,CHI.DAU), (11,CHI.TUAT), (12,CHI.HOI)
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
            callback(index, THIEN_CAN[can - 1].1, DIA_CHI[chi - 1].1);
            can := if (can == 10) 1 else (can + 1);
            chi := if (chi == 12) 1 else (chi + 1);
        };
    };
    
    public func thai_at(year : Int) : async (Text) {
        let buf = Buffer.Buffer<Text>(0);
        let t = ThaiAt(year);
        buf.add("Số năm từ Thượng cổ Giáp Tý đến " #debug_show(year) # ": " # debug_show(t.tich_nien()));
        buf.add("Tuế Kế: " # debug_show(t.tue_ke()));
        buf.add("Vị trí Thái Ất: " # debug_show(t.tim_thai_at()));
        buf.add("Kỷ nguyên Giáp Tý: " # debug_show(t.tim_ky_nguyen_giap_ty()));
        buf.add("Cục : " # debug_show(t.tinh_cuc()));
        buf.add("Vị trí Kế Thần: " # debug_show(t.tim_ke_than()));
        buf.add("Vị trí Thiên Mục/Văn Xương: " # debug_show(t.tim_thien_muc()));
        buf.add("Vị trí Khách Mục Thủy Kích: " # debug_show(t.tim_khach_muc_thuy_kich()));
        buf.add("Tìm Chủ - Khách: " # debug_show(t.tim_chu_khach()));
        buf.add("Tìm Đại Tướng: " # debug_show(t.tim_dai_tuong()));
        Text.join("\n----------------------------\n", buf.vals())
    };

    public func test() : async Text {
        let test_cases = [
            {
                year = 619;
                thai_at = KHON_THO;
                cuc = 16;
                van_xuong = DIA_BAN[11];
                thuy_kich = DIA_BAN[14];
                chu = 1;
                khach = 33;
            },
            {
                year = 287;
                thai_at = KHAM_THUY;
                cuc = 44;
                van_xuong = DIA_BAN[3];
                thuy_kich = DIA_BAN[12];
                chu = 33;
                khach = 14;
            },
            {
                year = -114;
                thai_at = LY_HOA;
                cuc = 4;
                van_xuong = DIA_BAN[0];
                thuy_kich = DIA_BAN[3];
                chu = 25;
                khach = 17;
            },
            {
                year = 260;
                thai_at = KHON_THO;
                cuc = 17;
                van_xuong = DIA_BAN[12];
                thuy_kich = DIA_BAN[1];
                chu = 7;
                khach = 27;
            },
            {
                year = 196;
                thai_at = CAN_KIM;
                cuc = 25;
                van_xuong = DIA_BAN[2];
                thuy_kich = DIA_BAN[1];
                chu = 29;
                khach = 19;
            }
        ];
        
        for (test in test_cases.vals()) {
            let t = ThaiAt(test.year);
            let ta = t.tim_thai_at();
            let cuc = t.tinh_cuc();
            let van_xuong = t.tim_thien_muc();
            let (_, thuy_kich) = t.tim_khach_muc_thuy_kich();
            let (_, chu_khach) = t.tim_chu_khach();
            assert(ta.cung.0 == test.thai_at.0 and ta.cung.1 == test.thai_at.1);
            assert(cuc.0 == test.cuc);
            assert(van_xuong.0 == test.van_xuong.0 and van_xuong.1 == test.van_xuong.1);
            assert(thuy_kich.0 == test.thuy_kich.0 and thuy_kich.1 == test.thuy_kich.1);
            assert(chu_khach.0 == test.chu and chu_khach.1 == test.khach);
        };
        "OK";
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

        public func tim_thai_at() : {cung : (Nat, Text); stayed_year : Nat} {
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
                cung_index += 1;
                if (cung_index != 4) nam -= 3; // không phải trung cung
            };
            return {
                cung = BAT_QUAI[cung_index];
                stayed_year = (nam % 3);
            };
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
            let nguyen = THIEN_CAN[can_index].1 # " " # DIA_CHI[chi_index].1;
            var current_year = "";
            _move_luc_thap_hoa_giap(?THIEN_CAN[can_index].0, ?1, ?72, func (index : Nat, can : Text, chi : Text) : () {
                if (index == (tueKe % 72)) {
                    // found
                    current_year := can # " " # chi;
                };
            });
            return ((tueKe % 72), nguyen, current_year);
        };

        type CACH_TINH = {
            #nien_ke;
            #nguyet_ke;
            #nhat_ke;
            #thoi_ke;
        };
        let tiet_khi = "Đông Chí"; //"Hạ Chí";
        let is_thoi_ke = false; 
        
        public func tim_ke_than() : (Int, (Nat, Text)) {
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

        public func tim_thien_muc() : (Nat, Text) { 
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
                if (start == DIA_BAN[14 - 1].0) {
                    // khởi Thân gặp Càn(1) - Khôn(13) thì +2
                    if (dia_ban_index == 0 or dia_ban_index == 12) {
                        count := count + 1;
                    };
                } else if (start == DIA_BAN[6 - 1].0) {
                    // Khởi Dần gặp Cấn(5) - Tốn(9) thì +2
                    if (dia_ban_index == 4 or dia_ban_index == 9) {
                        count := count + 1;
                    };
                };
                count := count + 1;
            };
            return DIA_BAN[dia_ban_index];
        };

        public func tim_khach_muc_thuy_kich() : ([(Text, Text)], (Nat, Text)) {
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
            let vitriKeThan = Array.indexOf((index, diaChi), DIA_BAN, func (a : (Nat, Text), b : (Nat, Text)) : Bool {
                return a.1 == b.1;
            });
            let ke_than_index = switch (vitriKeThan) {
                case null Debug.trap("Cannot find vị trí Kế Thần");
                case (?v) v;
            };
            let vanXuong = tim_thien_muc();
            var can_hoa_duc_index = ke_than_index;
            var thuy_kich_index = 4;
            let buf = Buffer.Buffer<(Text, Text)>(0);
            let map = HashMap.HashMap<Nat, (Nat, Text)>(0, Nat.equal, Hash.hash);
            while (can_hoa_duc_index != vanXuong.0 - 1) {
                buf.add((DIA_BAN[can_hoa_duc_index].1, DIA_BAN[thuy_kich_index].1));
                
                map.put(can_hoa_duc_index, THAP_LUC_THAN[thuy_kich_index]);

                can_hoa_duc_index := move(15, can_hoa_duc_index, 1);
                thuy_kich_index := move(15, thuy_kich_index, 1);
            };
            return ([], DIA_BAN[thuy_kich_index]);
        };

        public func tim_chu_khach() : ([((Nat, Text), (Nat, Nat))], (Nat, Nat)) {
            let DIA_BAN_BAT_QUAI_INDEX = [
                ((CAN_KIM.1, CHI.HOI), 1),
                ((KHAM_THUY.1, CHI.TY), 3),
                ((CAN_THO.1, CHI.DAN), 5),
                ((CHAN_MOC.1, CHI.MAO), 7),
                ((TON_MOC.1, CHI.TI), 9),
                ((LY_HOA.1, CHI.NGO), 11),
                ((KHON_THO.1, CHI.THAN), 13),
                ((DOAI_KIM.1, CHI.DAU), 15)
            ];

            let vanXuong = tim_thien_muc();
            let (_, thuyKich) = tim_khach_muc_thuy_kich();
            let thaiAt = tim_thai_at();
            let thai_at_index = switch (Array.find(DIA_BAN_BAT_QUAI_INDEX, 
                                                        func ((x, y) : ((Text, Text), Nat)) : Bool = (x.0 == thaiAt.cung.1))) {
                                                            case (?(_, y)) {
                                                                (y - 1);
                                                            };
                                                            case null Debug.trap("Không tìm thấy thái ất!");
                                                        };
            let cung_before_thai_at = if (thai_at_index == 2 or thai_at_index == 6 or thai_at_index == 10 or thai_at_index == 14) {
                // Nếu Thái Ất là Khảm/Chấn/Ly/Đoài - Tý/Mão/Ngọ/Dậu thì cung trước thái ất lùi về 2
                move(15, thai_at_index, -2);
            } else {
                move(15, thai_at_index, -1);
            };

            let mapBatQuai = Array.map<(Nat, Text), (Text, Nat)>(CLOCK_BAT_QUAI, func ((x, y) : (Nat, Text)) : (Text, Nat) = ((y, x)));
            let batquaiValue = HashMap.fromIter<Text, Nat>(mapBatQuai.vals(), mapBatQuai.size(), Text.equal, Text.hash);
            
            let buf = Buffer.Buffer<((Nat, Text), (Nat, Nat))>(0);
            // chủ đếm từ văn xương đến cung trước thái ất
            var chu = 0;
            buf.add((0, "Tìm Chủ - Khởi Văn Xương"), (0, 0));

            let find = func (name : Text, vitri : Nat, checkGianThan : Bool) : (Nat, Nat) {
                var val = 0;
                var pos = vitri - 1;
                for (((batquai_name, chi_name), p) in DIA_BAN_BAT_QUAI_INDEX.vals()) {
                    if (name == batquai_name or name == chi_name) {
                        if (checkGianThan == true) {
                            val := Option.get(batquaiValue.get(name), 0);
                        } else {
                            val := Option.get(batquaiValue.get(batquai_name), 0);
                        };
                        pos := p - 1;
                        return (pos, val);
                    };
                };
                return (pos, val);
            };
            
            var van_xuong_index = find(vanXuong.1, vanXuong.0, false);
            chu += if (van_xuong_index.1 == 0) 1 else van_xuong_index.1;
            buf.add(DIA_BAN[van_xuong_index.0], van_xuong_index);
            if (van_xuong_index.0 == thai_at_index or van_xuong_index.0 == cung_before_thai_at) {
                ();
            } else {
                var p = van_xuong_index.0;
                while (p != cung_before_thai_at) {
                    if (p == 0 or p == 4 or p == 8 or p == 12) {
                        // nếu là Càn, Cấn, Tốn, Khôn thì đi 2 bước vì cùng cung với Hợi, Dần, Tị, Thân
                        p := move(15, p, 2);
                    } else {
                        p := move(15, p, 1);
                    };
                    let tmp = find(DIA_BAN[p].1, DIA_BAN[p].0, false);
                    chu += tmp.1;
                    buf.add(DIA_BAN[p], tmp);
                };
            };
            // tính đến cung trước thái ất
            
            buf.add((0, "----------------------------------------"), (0, 0));
            // khách đếm từ thủy kích đến trước cung thái ất
            var khach = 0;
            buf.add((0, "Tìm Khách - Khởi Thủy Kích"), (0, 0));

            var thuy_kich_index = find(thuyKich.1, thuyKich.0, false);
            khach += if (thuy_kich_index.1 == 0) 1 else thuy_kich_index.1;
            buf.add(DIA_BAN[thuy_kich_index.0], thuy_kich_index);
            if (thuy_kich_index.0 == thai_at_index or thuy_kich_index.0 == cung_before_thai_at) {
                ();
            } else {
                var p = thuy_kich_index.0;
                while (p != cung_before_thai_at) {
                    if (p == 0 or p == 4 or p == 8 or p == 12) {
                        // nếu là Càn, Cấn, Tốn, Khôn thì đi 2 bước vì cùng cung với Hợi, Dần, Tị, Thân
                        p := move(15, p, 2);
                    } else {
                        p := move(15, p, 1);
                    };
                    let tmp = find(DIA_BAN[p].1, DIA_BAN[p].0, false);
                    khach += tmp.1;
                    buf.add(DIA_BAN[p], tmp);
                };
            };

            return (Buffer.toArray<((Nat, Text), (Nat, Nat))>(buf), (chu, khach));
        };

        public func tim_dai_tuong() : ({
                chu_dai_tuong : (Text, (Nat, Text));
                chu_tham_tuong : (Text, (Nat, Text));
                khach_dai_tuong : (Text, (Nat, Text));
                khach_tham_tuong : (Text, (Nat, Text));
            }) {
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
            let chu_dai_tuong = if (chu % 10 == 0) 1 else (chu % 10);
            let chu_tham_tuong = if ((chu_dai_tuong * 3) % 10 == 0) 1 else ((chu_dai_tuong * 3) % 10);
            let khach_dai_tuong = if (khach % 10 == 0) 1 else (khach % 10); 
            let khach_tham_tuong = if ((khach_dai_tuong * 3) % 10 == 0) 1 else ((khach_dai_tuong * 3) % 10);

            return {
                chu_dai_tuong : (Text, (Nat, Text)) = ("Chủ Đại Tướng", BAT_QUAI[chu_dai_tuong - 1]);
                chu_tham_tuong : (Text, (Nat, Text)) = ("Chủ Tham Tướng", BAT_QUAI[chu_tham_tuong - 1]);
                khach_dai_tuong : (Text, (Nat, Text)) = ("Khách Đại Tướng", BAT_QUAI[khach_dai_tuong - 1]);
                khach_tham_tuong : (Text, (Nat, Text)) = ("Khách Tham Tướng", BAT_QUAI[khach_tham_tuong - 1]);
            };
        };
    };
};