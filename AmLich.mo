import Array "mo:base/Array";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import Char "mo:base/Char";
import LichHND "LichHND";
import Types "types";

module {
    
    // Thiên Can data structure
    public type ThienCan = {
        id : Nat;
        chuCaiDau : ?Text;
        tenCan : ?Text;
        nguHanh : ?Text;
        nguHanhID : ?Nat;
        vitriDiaBan : ?Nat;
        amDuong : ?Int;
    };
    
    let thienCan : [ThienCan] = [
        {id = 0; chuCaiDau = null; tenCan = null; nguHanh = null; nguHanhID = null; vitriDiaBan = null; amDuong = null},
        {id = 1; chuCaiDau = ?"G"; tenCan = ?"Giáp"; nguHanh = ?"M"; nguHanhID = ?2; vitriDiaBan = ?3; amDuong = ?1},
        {id = 2; chuCaiDau = ?"A"; tenCan = ?"Ất"; nguHanh = ?"M"; nguHanhID = ?2; vitriDiaBan = ?4; amDuong = ?(-1)},
        {id = 3; chuCaiDau = ?"B"; tenCan = ?"Bính"; nguHanh = ?"H"; nguHanhID = ?4; vitriDiaBan = ?6; amDuong = ?1},
        {id = 4; chuCaiDau = ?"D"; tenCan = ?"Đinh"; nguHanh = ?"H"; nguHanhID = ?4; vitriDiaBan = ?7; amDuong = ?(-1)},
        {id = 5; chuCaiDau = ?"M"; tenCan = ?"Mậu"; nguHanh = ?"O"; nguHanhID = ?5; vitriDiaBan = ?6; amDuong = ?1},
        {id = 6; chuCaiDau = ?"K"; tenCan = ?"Kỷ"; nguHanh = ?"O"; nguHanhID = ?5; vitriDiaBan = ?7; amDuong = ?(-1)},
        {id = 7; chuCaiDau = ?"C"; tenCan = ?"Canh"; nguHanh = ?"K"; nguHanhID = ?1; vitriDiaBan = ?9; amDuong = ?1},
        {id = 8; chuCaiDau = ?"T"; tenCan = ?"Tân"; nguHanh = ?"K"; nguHanhID = ?1; vitriDiaBan = ?10; amDuong = ?(-1)},
        {id = 9; chuCaiDau = ?"N"; tenCan = ?"Nhâm"; nguHanh = ?"T"; nguHanhID = ?3; vitriDiaBan = ?12; amDuong = ?1},
        {id = 10; chuCaiDau = ?"Q"; tenCan = ?"Quý"; nguHanh = ?"T"; nguHanhID = ?3; vitriDiaBan = ?1; amDuong = ?(-1)}
    ];
    
    // Giáp, Kỷ             ->   Bính (3) | 1,6 -> 3
    // Ất, Canh             ->   Mậu (5)  | 2,7 -> 5
    // Bính, Tân           ->   Canh (7)  | 3,8 -> 7
    // Đinh, Nhâm       ->   Nhâm (9)     | 4,9 -> 9
    // Mậu, Quý           ->   Giáp (1)   | 5,10 -> 1
    let ngu_ho_don : [Nat] = [0, 3, 5, 7, 9, 1, 3, 5, 7, 9, 1];
    
    // ############ Cách tìm nhanh ngũ hành ###############
    /*
        Giáp, Ất = 1
        Bính, Đinh = 2
        Mậu, Kỷ = 3
        Canh, Tân = 4
        Nhâm, Quý = 5

        Tý, Sửu = 1     Ngọ, Mùi = 1
        Dần, Mão = 2    Thân, Dậu = 2
        Thìn, Tỵ = 3    Tuất, Hợi = 3

        Mộc = 1 => 3 (Mộc tam cục)
        Kim = 2 => 4 (Kim tứ cục)
        Thủy = 3 => 2 (Thủy nhị cục)
        Hỏa = 4 => 6 (Hỏa lục cục)
        Thổ = 5 => 5 (Thổ ngũ cục)

        Lấy thiên can + địa chi nếu lớn hơn 5 thì trừ đi 5
    */
    // #########################  Giáp, Ất, Bính, Đinh, Mậu, Kỷ, Canh, Tân, Nhâm, Quý
    let tinh_nhanh_thien_can : [Nat] = [0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5];
    // ######################## Tý, Sửu, Dần, Mão, Thìn, Tỵ, Ngọ, Mùi, Thân, Dậu, Tuất, Hợi
    let tinh_nhanh_dia_chi : [Nat] = [0, 1, 1, 2, 2, 3, 3, 1, 1, 2, 2, 3, 3];
    // ################## M  K  T  H  Thổ ##################
    let ngu_hanh_cuc : [Nat] = [0, 3, 4, 2, 6, 5];
    
    public func ten_ngu_hanh_cuc(cuc : Nat) : Text {
        if (cuc == 3) {
            return "Mộc tam cục";
        } else if (cuc == 4) {
            return "Kim tứ cục";
        } else if (cuc == 2) {
            return "Thủy nhị cục";
        } else if (cuc == 6) {
            return "Hỏa lục cục";
        } else if (cuc == 5) {
            return "Thổ ngũ cục";
        } else {
            return "Không xác định";
        };
    };
    
    // ####################################################
    
    public type DiaChi = {
        id : Nat;
        tenChi : Text;
        tenHanh : Text;
        menhChu : ?Text;
        thanChu : ?Text;
        amDuong : Int;
    };
    
    let diaChi : [DiaChi] = [
        {id = 0; tenChi = "Hem có"; tenHanh = ":D"; menhChu = null; thanChu = null; amDuong = 0},
        {id = 1; tenChi = "Tý"; tenHanh = "T"; menhChu = ?"Tham lang"; thanChu = ?"Linh tinh"; amDuong = 1},
        {id = 2; tenChi = "Sửu"; tenHanh = "O"; menhChu = ?"Cự môn"; thanChu = ?"Thiên tướing"; amDuong = -1},
        {id = 3; tenChi = "Dần"; tenHanh = "M"; menhChu = ?"Lộc tồn"; thanChu = ?"Thiên lương"; amDuong = 1},
        {id = 4; tenChi = "Mão"; tenHanh = "M"; menhChu = ?"Văn khúc"; thanChu = ?"Thiên đồng"; amDuong = -1},
        {id = 5; tenChi = "Thìn"; tenHanh = "O"; menhChu = ?"Liêm trinh"; thanChu = ?"Văn xương"; amDuong = 1},
        {id = 6; tenChi = "Tỵ"; tenHanh = "H"; menhChu = ?"Vũ khúc"; thanChu = ?"Thiên cơ"; amDuong = -1},
        {id = 7; tenChi = "Ngọ"; tenHanh = "H"; menhChu = ?"Phá quân"; thanChu = ?"Hỏa tinh"; amDuong = 1},
        {id = 8; tenChi = "Mùi"; tenHanh = "O"; menhChu = ?"Vũ khúc"; thanChu = ?"Thiên tướng"; amDuong = -1},
        {id = 9; tenChi = "Thân"; tenHanh = "K"; menhChu = ?"Liêm trinh"; thanChu = ?"Thiên lương"; amDuong = 1},
        {id = 10; tenChi = "Dậu"; tenHanh = "K"; menhChu = ?"Văn khúc"; thanChu = ?"Thiên đồong"; amDuong = -1},
        {id = 11; tenChi = "Tuất"; tenHanh = "O"; menhChu = ?"Lộc tồn"; thanChu = ?"Văn xương"; amDuong = 1},
        {id = 12; tenChi = "Hợi"; tenHanh = "T"; menhChu = ?"Cự môn"; thanChu = ?"Thiên cơ"; amDuong = -1}
    ];
    
    public func ngayThangNam(nn : Int, tt : Int, nnnn : Int, duongLich : Bool, timeZone : Int) : (Int, Int, Int, Int) {
        var thangNhuan : Nat = 0;
        // if nnnn > 1000 and nnnn < 3000 and nn > 0 and \
        if (nn > 0 and nn < 32 and tt < 13 and tt > 0) {
            if (duongLich == true) {
                // Assuming S2L returns (Nat, Nat, Nat, Nat)
                let (lunarDay, lunarMonth, lunarYear, lunarLeap) = LichHND.S2L(nn, tt, nnnn, Float.fromInt(timeZone));
                return (lunarDay, lunarMonth, lunarYear, lunarLeap);
            } else {
                return (nn, tt, nnnn, thangNhuan);
            };
        } else {
            // Raise exception - in Motoko we use Error or return optional
            return (0, 0, 0, 0); // Error case
        };
    };

    public func canChiNgay(nn : Int, tt : Int, nnnn : Int, duongLich : Bool, timeZone : Int, thangNhuan : Bool) : (Nat, Nat) {
        var new_nn = nn;
        var new_tt = tt;
        var new_nnnn = nnnn;
        
        if (duongLich == false) {
            // Assuming L2S returns (Nat, Nat, Nat)
            let (day, month, year) = LichHND.L2S(nn, tt, nnnn, if (thangNhuan) 1 else 0, Float.fromInt(timeZone));
            new_nn := day;
            new_tt := month;
            new_nnnn := year;
        };
        
        let jd = LichHND.jdFromDate(new_nn, new_tt, new_nnnn);
        let canNgay = (jd + 9) % 10;
        let chiNgay = (jd + 1) % 12;
        return (Int.abs(canNgay), Int.abs(chiNgay));
    };
    
    public func canChiGio(canNgay : Nat, gio : Int) : (Nat, Nat) {
        let hour_zhi_idx = (gio + 1) / 2 % 12;
        let hour_gan_idx = (canNgay * 2 + hour_zhi_idx) % 10;
        return (Int.abs(hour_gan_idx), Int.abs(hour_zhi_idx));
    };
    
    public func chuyen_gio_duong_sang_am(gio : Nat) : Nat {
        if (gio >= 1 and gio < 3) {
            return 2;
        } else if (gio >= 3 and gio < 5) {
            return 3;
        } else if (gio >= 5 and gio < 7) {
            return 4;
        } else if (gio >= 7 and gio < 9) {
            return 5;
        } else if (gio >= 9 and gio < 11) {
            return 6;
        } else if (gio >= 11 and gio < 13) {
            return 7;
        } else if (gio >= 13 and gio < 15) {
            return 8;
        } else if (gio >= 15 and gio < 17) {
            return 9;
        } else if (gio >= 17 and gio < 19) {
            return 10;
        } else if (gio >= 19 and gio < 21) {
            return 11;
        } else if (gio >= 21 and gio < 23) {
            return 12;
        } else {
            return 1;
        };
    };
    
    public func ngayThangNamCanChi(nn : Int, tt : Int, nnnn : Int, hour : Int, timeZone : Int) : (Types.GZTimeIndex, 
                                                                                                    Types.GZTimeIndex, 
                                                                                                    Types.GZTimeIndex, 
                                                                                                    Types.GZTimeIndex) {
        var new_nn = nn;
        var new_tt = tt;
        var new_nnnn = nnnn;
        var thangNhuan : Int = 0;

        let jd = Int.abs(LichHND.jdFromDate(new_nn, new_tt, new_nnnn));
        let canNgay = (jd + 9) % 10;
        let chiNgay = (jd + 1) % 12;

        
        let (ngay, thang, nam, ttNhuan) = ngayThangNam(nn, tt, nnnn, true, timeZone);
        new_nn := ngay;
        new_tt := thang;
        new_nnnn := nam;
        thangNhuan := ttNhuan;
        
        // Can của tháng
        let canThang = (new_nnnn * 12 + new_tt + 3) % 10;
        let chiThang = (new_tt + 1) % 12;
        // Can chi của năm
        let canNam = (new_nnnn + 6) % 10;
        let chiNam = (new_nnnn + 8) % 12;

        let (canGio, chiGio) = canChiGio(canNgay, hour);
        
        return (Types._newGZTimeInt(canNam, chiNam),
                Types._newGZTimeInt(canThang, chiThang), 
                Types._newGZTimeInt(canNgay, chiNgay), 
                Types._newGZTimeInt(canGio, chiGio));
    };
    
    public func tim_can_cung(canNam : Nat) : [Nat] {
        var can_cung : [var Nat] = Array.init<Nat>(13, 0);
        /*
            Dựa vào Ngũ hổ độn để đếm, 
            bắt đầu từ cung dần (vị trí số 3)
            Lấy thiên can của cung dần dựa trên canNam
            thuận chiều kim đồng hồ đếm từ cung dần tới các cung sau đó
        */
        var index_can : Nat = 3;
        var start_can_cung : Nat = ngu_ho_don[canNam];
        
        for (i in Iter.range(1, 12)) {
            can_cung[index_can] := start_can_cung;
            index_can += 1;
            if (index_can > 12) {
                index_can := 1;
            };
            start_can_cung += 1;
            if (start_can_cung > 10) {
                start_can_cung := 1;
            };
        };
        
        Array.freeze(can_cung);
    };
    
    public func tim_ngu_hanh_can_chi(can : Nat, chi : Nat) : Nat {
        var nguhanh : Nat = tinh_nhanh_thien_can[can] + tinh_nhanh_dia_chi[chi];
        if (nguhanh > 5) {
            nguhanh -= 5;
        };
        ngu_hanh_cuc[nguhanh];
    };
    
    public func tim_cuc(cungMenh : Nat, canNam : Nat) : Nat {
        // print("--------------------Cung mệnh: ", cungMenh)
        // print("--------------------Can năm: ", canNam)
        let can_cung = tim_can_cung(canNam);
        var menh : Nat = cungMenh + 2;
        if (menh > 12) {
            menh -= 12;
        };
        // print(menh)
        // print(can_cung[menh])
        var nguhanh : Nat = tinh_nhanh_thien_can[can_cung[menh]] + tinh_nhanh_dia_chi[menh];
        if (nguhanh > 5) {
            nguhanh -= 5;
        };
        // print(ten_ngu_hanh_cuc(ngu_hanh_cuc[nguhanh]))
        ngu_hanh_cuc[nguhanh];
    };
    
    public type NguHanhInfo = {
        id : Nat;
        tenHanh : Text;
        cuc : Nat;
        tenCuc : Text;
        css : Text;
    };
    
    public func nguHanh(tenHanh : Text) : NguHanhInfo {
        /*
        Args:
            tenHanh (string): Tên Hành trong ngũ hành, Kim hoặc K, Moc hoặc M,
            Thuy hoặc T, Hoa hoặc H, Tho hoặc O

        Returns:
            Dictionary: ID của Hành, tên đầy đủ của Hành, số Cục của Hành

        Raises:
            Exception: Description
        */
        if (tenHanh == "Kim" or tenHanh == "K") {
            return {
                id = 1;
                tenHanh = "Kim";
                cuc = 4;
                tenCuc = "Kim tứ Cục";
                css = "hanhKim";
            };
        } else if (tenHanh == "Moc" or tenHanh == "M") {
            return {
                id = 2;
                tenHanh = "Mộc";
                cuc = 3;
                tenCuc = "Mộc tam Cục";
                css = "hanhMoc";
            };
        } else if (tenHanh == "Thuy" or tenHanh == "T") {
            return {
                id = 3;
                tenHanh = "Thủy";
                cuc = 2;
                tenCuc = "Thủy nhị Cục";
                css = "hanhThuy";
            };
        } else if (tenHanh == "Hoa" or tenHanh == "H") {
            return {
                id = 4;
                tenHanh = "Hỏa";
                cuc = 6;
                tenCuc = "Hỏa lục Cục";
                css = "hanhHoa";
            };
        } else if (tenHanh == "Tho" or tenHanh == "O") {
            return {
                id = 5;
                tenHanh = "Thổ";
                cuc = 5;
                tenCuc = "Thổ ngũ Cục";
                css = "hanhTho";
            };
        } else {
            // Raise exception
            return {
                id = 0;
                tenHanh = "Error";
                cuc = 0;
                tenCuc = "Error";
                css = "error";
            };
        };
    };
    
    public func ngu_hanh(tenHanh : Nat) : NguHanhInfo {
        /*
        Args:
            tenHanh (Nat): Tên Hành trong ngũ hành, 2,3,4,5,6

        Returns:
            Dictionary: ID của Hành, tên đầy đủ của Hành, số Cục của Hành

        Raises:
            Exception: Description
        */
        if (tenHanh == 4) {
            return {
                id = 1;
                tenHanh = "Kim";
                cuc = 4;
                tenCuc = "Kim tứ Cục";
                css = "hanhKim";
            };
        } else if (tenHanh == 3) {
            return {
                id = 2;
                tenHanh = "Mộc";
                cuc = 3;
                tenCuc = "Mộc tam Cục";
                css = "hanhMoc";
            };
        } else if (tenHanh == 2) {
            return {
                id = 3;
                tenHanh = "Thủy";
                cuc = 2;
                tenCuc = "Thủy nhị Cục";
                css = "hanhThuy";
            };
        } else if (tenHanh == 6) {
            return {
                id = 4;
                tenHanh = "Hỏa";
                cuc = 6;
                tenCuc = "Hỏa lục Cục";
                css = "hanhHoa";
            };
        } else if (tenHanh == 5) {
            return {
                id = 5;
                tenHanh = "Thổ";
                cuc = 5;
                tenCuc = "Thổ ngũ Cục";
                css = "hanhTho";
            };
        } else {
            // Raise exception
            return {
                id = 0;
                tenHanh = "Error";
                cuc = 0;
                tenCuc = "Error";
                css = "error";
            };
        };
    };
    
    public func sinhKhac(hanh1 : Nat, hanh2 : Nat) : Int {
        let matranSinhKhac : [[?Int]] = [
            [null, null, null, null, null, null],
            [null, ?0, ?(-1), ?1, ?(-1), ?1],
            [null, ?(-1), ?0, ?1, ?1, ?(-1)],
            [null, ?1, ?1, ?0, ?1, ?(-1)],
            [null, ?(-1), ?1, ?(-1), ?0, ?1],
            [null, ?1, ?(-1), ?(-1), ?1, ?0]
        ];
        
        switch (matranSinhKhac[hanh1][hanh2]) {
            case (?result) result;
            case (null) 0;
        };
    };
    
    public func nguHanhNapAm(diaChi : Nat, thienCan : Nat, xuatBanMenh : Bool) : Text {
        // Sử dụng Ngũ Hành nạp âm để tính Hành của năm.
        let banMenh : [(Text, Text)] = [
            ("K1", "HẢI TRUNG KIM"),
            ("T1", "GIÁNG HẠ THỦY"),
            ("H1", "TÍCH LỊCH HỎA"),
            ("O1", "BÍCH THƯỢNG THỔ"),
            ("M1", "TANG ÐỐ MỘC"),
            ("T2", "ÐẠI KHÊ THỦY"),
            ("H2", "LƯ TRUNG HỎA"),
            ("O2", "THÀNH ÐẦU THỔ"),
            ("M2", "TÒNG BÁ MỘC"),
            ("K2", "KIM BẠCH KIM"),
            ("H3", "PHÚ ÐĂNG HỎA"),
            ("O3", "SA TRUNG THỔ"),
            ("M3", "ÐẠI LÂM MỘC"),
            ("K3", "BẠCH LẠP KIM"),
            ("T3", "TRƯỜNG LƯU THỦY"),
            ("K4", "SA TRUNG KIM"),
            ("T4", "THIÊN HÀ THỦY"),
            ("H4", "THIÊN THƯỢNG HỎA"),
            ("O4", "LỘ BÀN THỔ"),
            ("M4", "DƯƠNG LIỄU MỘC"),
            ("T5", "TRUYỀN TRUNG THỦY"),
            ("H5", "SƠN HẠ HỎA"),
            ("O5", "ÐẠI TRẠCH THỔ"),
            ("M5", "THẠCH LỰU MỘC"),
            ("K5", "KIẾM PHONG KIM"),
            ("H6", "SƠN ÐẦU HỎA"),
            ("O6", "ỐC THƯỢNG THỔ"),
            ("M6", "BÌNH ÐỊA MỘC"),
            ("K6", "XOA XUYẾN KIM"),
            ("T6", "ÐẠI HẢI THỦY")
        ];
        
        let matranNapAm : [[?Text]] = [
            [?"0", ?"G", ?"Ất", ?"Bính", ?"Đinh", ?"Mậu", ?"Kỷ", ?"Canh", ?"Tân", ?"N", ?"Q"],
            [?"1", ?"K1", null, ?"T1", null, ?"H1", null, ?"O1", null, ?"M1", null],
            [?"2", null, ?"K1", null, ?"T1", null, ?"H1", null, ?"O1", null, ?"M1"],
            [?"3", ?"T2", null, ?"H2", null, ?"O2", null, ?"M2", null, ?"K2", null],
            [?"4", null, ?"T2", null, ?"H2", null, ?"O2", null, ?"M2", null, ?"K2"],
            [?"5", ?"H3", null, ?"O3", null, ?"M3", null, ?"K3", null, ?"T3", null],
            [?"6", null, ?"H3", null, ?"O3", null, ?"M3", null, ?"K3", null, ?"T3"],
            [?"7", ?"K4", null, ?"T4", null, ?"H4", null, ?"O4", null, ?"M4", null],
            [?"8", null, ?"K4", null, ?"T4", null, ?"H4", null, ?"O4", null, ?"M4"],
            [?"9", ?"T5", null, ?"H5", null, ?"O5", null, ?"M5", null, ?"K5", null],
            [?"10", null, ?"T5", null, ?"H5", null, ?"O5", null, ?"M5", null, ?"K5"],
            [?"11", ?"H6", null, ?"O6", null, ?"M6", null, ?"K6", null, ?"T6", null],
            [?"12", null, ?"H6", null, ?"O6", null, ?"M6", null, ?"K6", null, ?"T6"]
        ];
        
        let nh = matranNapAm[diaChi][thienCan];
        switch (nh) {
            case (?result) {
                if (Text.size(result) > 0 and (
                    Text.startsWith(result, #text "K") or
                    Text.startsWith(result, #text "M") or
                    Text.startsWith(result, #text "T") or
                    Text.startsWith(result, #text "H") or
                    Text.startsWith(result, #text "O")
                )) {
                    if (xuatBanMenh) {
                        // Find in banMenh
                        for ((key, value) in banMenh.vals()) {
                            if (key == result) {
                                return value;
                            };
                        };
                        return "Không tìm thấy";
                    } else {
                        let arr = Text.toArray(result);
                        if (arr.size() > 0) return Char.toText(arr[0]);
                        return "Error";
                    };
                } else {
                    return "Error";
                };
            };
            case (null) {
                return "Error";
            };
        };
    };

    
    
    public func dichCung(cungBanDau : Nat, args : [Int]) : Int {
        var cungSauKhiDich : Int = cungBanDau;
        for (soCungDich in args.vals()) {
            cungSauKhiDich += soCungDich;
        };
        if (cungSauKhiDich % 12 == 0) {
            return 12;
        };
        (cungSauKhiDich % 12);
    };
    
    public func khoangCachCung(cung1 : Nat, cung2 : Nat, chieu : Nat) : Nat {
        if (chieu == 1) {  // Con trai, chiều dương
            return (cung1 - cung2 + 12) % 12;
        } else {
            return (cung2 - cung1 + 12) % 12;
        };
    };
    
    public func timCuc(viTriCungMenhTrenDiaBan : Nat, canNamSinh : Nat) : Text {
        let canThangGieng = (canNamSinh * 2 + 1) % 10;
        let canThangMenh = ((viTriCungMenhTrenDiaBan - 3) % 12 + canThangGieng) % 10;
        let finalCanThangMenh = if (canThangMenh == 0) { 10 } else { canThangMenh };
        nguHanhNapAm(viTriCungMenhTrenDiaBan, finalCanThangMenh, false);
    };
    
    public func timTuVi(cuc : Nat, ngaySinhAmLich : Nat) : Int {
        // Tìm vị trí của sao Tử vi
        var cungDan : Nat = 3;  // Vị trí cung Dần ban đầu là 3
        let cucBanDau = cuc;
        
        if (cuc != 2 and cuc != 3 and cuc != 4 and cuc != 5 and cuc != 6) {
            // Tránh trường hợp infinite loop
            return 0; // Error case
        };
        
        var currentCuc = cuc;
        while (currentCuc < ngaySinhAmLich) {
            currentCuc += cucBanDau;
            cungDan += 1; // Dịch vị trí cung Dần
        };
        
        let saiLech = currentCuc - ngaySinhAmLich;
        let finalSaiLech = if (saiLech % 2 == 1) { -saiLech } else { saiLech };
        
        dichCung(cungDan, [finalSaiLech]);
    };
    
    public func timTrangSinh(cucSo : Nat) : Nat {
        // Tìm vị trí của Tràng sinh
        // Theo thứ tự cục số
        // vị trí Tràng sinh sẽ là Dần, Tỵ, Thân hoặc Hợi
        
        /*LƯU Ý* Theo cụ Thiên Lương: Nam -> Thuận, Nữ -> Nghịch*/
        
        if (cucSo == 6) {  // Hỏa lục cục
            return 3; // Tràng sinh ở Dần
        } else if (cucSo == 4) {  // Kim tứ cục
            return 6; // Tràng sinh ở Tỵ
        } else if (cucSo == 2 or cucSo == 5) {  // Thủy nhị cục, Thổ ngũ cục
            return 9; // Tràng sinh ở Thân
        } else if (cucSo == 3) {  // Mộc tam cục
            return 12; // Tràng sinh ở Hợi
        } else {
            return 0; // Error case
        };
    };
    
    public func timHoaLinh(chiNamSinh : Nat, gioSinh : Nat, gioiTinh : Int, amDuongNamSinh : Int) : (Int, Int) {
        var khoiCungHoaTinh : Nat = 0;
        var khoiCungLinhTinh : Nat = 0;
        
        if (chiNamSinh == 3 or chiNamSinh == 7 or chiNamSinh == 11) {   // Dần Ngọ Tuất
            khoiCungHoaTinh := 2; // Sửu
            khoiCungLinhTinh := 4;    // Mão
        } else if (chiNamSinh == 1 or chiNamSinh == 5 or chiNamSinh == 9) { // Thân Tý Thìn
            khoiCungHoaTinh := 3; // Dần
            khoiCungLinhTinh := 11; // Tuất
        } else if (chiNamSinh == 6 or chiNamSinh == 10 or chiNamSinh == 2) {  // Tỵ Dậu Sửu 
            khoiCungHoaTinh := 11; //  Tuất
            khoiCungLinhTinh := 4; // Mão
        } else if (chiNamSinh == 12 or chiNamSinh == 4 or chiNamSinh == 8) {  // Hợi Mão Mùi
            khoiCungHoaTinh := 10; // Dậu
            khoiCungLinhTinh := 11; // Tuất
        } else {
            return (0, 0); // Error case
        };
        
        var viTriHoaTinh : Int = 0;
        var viTriLinhTinh : Int = 0;
        
        if ((gioiTinh * amDuongNamSinh) == -1) {
            viTriHoaTinh := dichCung(khoiCungHoaTinh, [(-1) * (gioSinh - 1)]);
            viTriLinhTinh := dichCung(khoiCungLinhTinh, [(gioSinh - 1)]);
        } else if ((gioiTinh * amDuongNamSinh) == 1) {
            viTriHoaTinh := dichCung(khoiCungHoaTinh, [(gioSinh - 1)]);
            viTriLinhTinh := dichCung(khoiCungLinhTinh, [(-1) * (gioSinh - 1)]);
        };
        
        (viTriHoaTinh, viTriLinhTinh);
    };
    
    public func timThienKhoi(canNam : Nat) : Nat {
        /*
            Giáp Mậu thị Ngưu Dương
            Ất Kỷ Thử Hầu hương
            Canh Tân phùng Mã Hổ
            Nhâm Quý Thố Xà tàng
            Bính Đinh Trư Kẻ vị
            Thử thị quý nhân phương.
            
            Thí dụ : Người sinh tuổi Giáp tuổi Mậu
            An Thiên-Khôi ở Sửu, an Thiên-Việt ở Mùi

            Người sinh tuổi Ất tuổi Kỷ
            An Thiên-Khôi ở Tý, an Thiên-Việt ở Thân
            
            Người sinh tuổi Canh tuổi Tân
            An Thiên-Khôi ở Ngọ, an Thiên-Việt ở Dần
            
            Người sinh tuổi Nhâm tuổi Quý
            An Thiên-Khôi ở Mão, an Thiên-Việt ở Tỵ
            
            Người sinh tuổi Bính tuổi Đinh
            An Thiên-Khôi ở Hợi, an Thiên-Việt ở Dậu
        */
        let khoiViet : [Nat] = [0, 2, 1, 12, 12, 2, 1, 7, 7, 4, 4];
        if (canNam < khoiViet.size()) {
            return khoiViet[canNam];
        } else {
            return 0; // Error case
        };
    };
    
    public func timThienViet(canNam : Nat) : Nat {
        /*
            Giáp Mậu thị Ngưu Dương
            Ất Kỷ Thử Hầu hương
            Canh Tân phùng Mã Hổ
            Nhâm Quý Thố Xà tàng
            Bính Đinh Trư Kẻ vị
            Thử thị quý nhân phương.
            
            Thí dụ : Người sinh tuổi Giáp tuổi Mậu
            An Thiên-Khôi ở Sửu, an Thiên-Việt ở Mùi

            Người sinh tuổi Ất tuổi Kỷ
            An Thiên-Khôi ở Tý, an Thiên-Việt ở Thân
            
            Người sinh tuổi Canh tuổi Tân
            An Thiên-Khôi ở Ngọ, an Thiên-Việt ở Dần
            
            Người sinh tuổi Nhâm tuổi Quý
            An Thiên-Khôi ở Mão, an Thiên-Việt ở Tỵ
            
            Người sinh tuổi Bính tuổi Đinh
            An Thiên-Khôi ở Hợi, an Thiên-Việt ở Dậu
        */
        let thienViet : [Nat] = [0, 8, 9, 10, 10, 8, 9, 3, 3, 6, 6];
        if (canNam < thienViet.size()) {
            return thienViet[canNam];
        } else {
            return 0; // Error case
        };
    };
    
    public func timThienQuanThienPhuc(canNam : Nat) : (Nat, Nat) {
        // Giáp dương Nhâm khuyển Ất long nghi
        // Mậu thổ Canh chư Quý mã thượng
        // Kỳ nhân quý hiển khả tiên tri
        let thienQuan : [Nat] = [0, 8, 5, 6, 3, 4, 10, 12, 10, 11, 7];

        // Giáp ái kim kê Ất ái hầu
        // Đinh chư Bính thử Kỷ hổ đầu
        // Tân quý phùng xà phúc lộc nhiêu
        let thienPhuc : [Nat] = [0, 10, 9, 1, 12, 4, 3, 7, 6, 7, 6];
        
        if (canNam < thienQuan.size() and canNam < thienPhuc.size()) {
            return (thienQuan[canNam], thienPhuc[canNam]);
        } else {
            return (0, 0); // Error case
        };
    };
    
    public func timCoThan(chiNam : Nat) : Nat {
        if (chiNam == 12 or chiNam == 1 or chiNam == 2) {
            return 3;
        } else if (chiNam == 3 or chiNam == 4 or chiNam == 5) {
            return 6;
        } else if (chiNam == 6 or chiNam == 7 or chiNam == 8) {
            return 9;
        } else {
            return 12;
        };
    };
    
    public func timThienMa(chiNam : Nat) : Nat {
        let demNghich = chiNam % 4;
        if (demNghich == 1) {
            return 3;
        } else if (demNghich == 2) {
            return 12;
        } else if (demNghich == 3) {
            return 9;
        } else if (demNghich == 0) {
            return 6;
        } else {
            return 0; // Error case
        };
    };
    
    public func timPhaToai(chiNam : Nat) : Nat {
        // tứ chính : Tuổi Tý, Ngọ, Mão, Dậu (cung Tị) 1, 7, 4, 10
        // tứ mộ : tuổi Thìn, Tuất, Sửu, Mùi (cung Sửu) 5, 11, 2, 8
        // tứ sinh : tuổi Dần, Thân, Tị, Hợi (cung Dậu) 3, 9, 6, 12
        if (chiNam == 1 or chiNam == 7 or chiNam == 4 or chiNam == 10) {
            return 6;
        } else if (chiNam == 5 or chiNam == 11 or chiNam == 2 or chiNam == 8) {
            return 2;
        } else if (chiNam == 3 or chiNam == 9 or chiNam == 6 or chiNam == 12) {
            return 10;
        } else {
            return 0; // Error case
        };
    };
    
    public func timTriet(canNam : Nat) : (Nat, Nat) {
        // Giáp Kỷ, Thân Dậu cung
        if (canNam == 1 or canNam == 6) {
            return (9, 10);
        // Ất Canh, Ngọ Mùi cung
        } else if (canNam == 2 or canNam == 7) {
            return (7, 8);
        // Bính Tân, Thìn Tị cung
        } else if (canNam == 3 or canNam == 8) {
            return (5, 6);
        // Đinh Nhâm, Dần Mão cung
        } else if (canNam == 4 or canNam == 9) {
            return (3, 4);
        // Mậu Quý, Tý Sửu cung
        } else if (canNam == 5 or canNam == 10) {
            return (1, 2);
        } else {
            return (0, 0); // Error case
        };
    };
    
    public func timLuuTru(canNam : Nat) : (Nat, Nat) {
        let maTranLuuHa : [Nat] = [0, 10, 11, 8, 5, 6, 7, 9, 4, 12, 3];
        let maTranThienTru : [Nat] = [0, 6, 7, 1, 6, 7, 9, 3, 7, 10, 11];
        
        if (canNam < maTranLuuHa.size() and canNam < maTranThienTru.size()) {
            return (maTranLuuHa[canNam], maTranThienTru[canNam]);
        } else {
            return (0, 0); // Error case
        };
    };
};
