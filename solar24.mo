import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Buffer "mo:base/Buffer";
import LichHND "LichHND";
import AmLich "AmLich";
import Types "types";

module {

    // Sorted by degrees for easier lookup
    // Thượng - Trung - Hạ -> cách nhau 6 số Thượng + 6 % 9 = (Trung + 6) % 9 = (Hạ + 6) % 9 + 1 = Chuyển tiết Thượng

    /***
        Tiết Khí .
        Khi tính xem Can Chi ngày thuộc Thượng Trung Hạ Nguyên của Tiết Khí thì chỉ lấy Phù
        Đầu mà tính, không phải lấy Tuần Thủ. Dĩ nhiên có rất nhiều Tuần Thủ của Can Chi củng
        chính là Phù Đầu, trường hợp này chính là 5 ngày đầu của một tuần Giáp (tại chưa tới Kỷ,
        nên Tuần Thủ Giáp củng chính là Phù Đầu). 5 ngày sau của tuần Giáp thì có can Kỷ là Phù
        Đầu.
        Ta biết trái đất xoay quanh mặt trời, 1 vòng 360 độ là 1 năm. Đem 360 / 24 = 15 độ.
        Cho nên mỗi tiết khí là 15 kinh độ mặt trời (Sun Longitude)
        Tiết khí căn cứ vào kinh độ của mặt trời cho nên các điểm móc này không thay đổi, tức là tiết
        Lập Xuân thì lúc nào củng là 315 kinh độ mặt trời.
        Tiết khí âm lịch bắt đầu từ tiết Đông Chí.
        Dưới đây là bản liệt kê tiết khí, kinh độ mặt trời, và các ngày Dương Lịch mà tiết khí thường
        bắt đầu.
        Đông Chí (Winter Solstice), 270 độ, 22 Tháng 12 DL
        Tiểu Hàn, 285 độ, 6 Tháng 1 DL
        Đại Hàn, 300 độ, 10 Tháng 1 DL
        Lập Xuân, 315 độ, 4 Tháng 2 DL
        Vũ Thũy, 330 độ, 19 Tháng 2 DL
        Kinh Chập 345 độ, 6 Tháng 3 DL
        Xuân Phân (Spring Equinox), 0 độ, 21 Tháng 3
        Thanh Minh, 15 độ, 5 Tháng 4 DL
        Cốc Vũ, 30 độ, 20 Tháng 4 DL
        Lập Hạ, 45 độ, 6 Tháng 5 DL
        Tiểu Mãn, 60 độ, 21 Tháng 5 DL
        Mang Chủng, 75 độ, 6 Tháng 6 DL
        Hạ Chí (Summer Solstice), 90 độ, 21 Tháng 6 DL
        Tiểu Thử, 105 độ, 7 Tháng 7 DL
        Đại Thử, 120 độ, 23 Tháng 7 DL
        Lập Thu, 135 độ, 8 Tháng 8 DL
        Xử Thử, 150 độ, 23 Tháng 8 DL
        Bạch Lộ, 165 độ, 8 Tháng 9 DL
        Thu Phân (Autum Equinox), 180 độ, 23 Tháng 9 DL
        Hàn Lộ, 195 độ, 8 Tháng 10 DL
        Sương Giáng, 210 độ, 24 Tháng 10 DL
        Lập Đông, 225 độ, 8 Tháng 11 DL
        Tiểu Tuyết, 240 độ, 22 Tháng 11 DL
        Đại Tuyết, 255 độ, 7 Tháng 12 DL
        Tại sao điểm Xuân Phân lại cho là 0 độ?
        Điểm Xuân Phân chính là điểm giao nhau của vòng Hoàng Đạo và Xích Đạo.
        Thật ra 24 Tiết Khí, bao gồm 12 Tiết và 12 Khí (còn gọi là Trung Khí, tức khí giữa hai tiết).
        Lấy Lập Xuân là mốc của Tiết, ta thấy rằng các kinh độ mặt trời có đuôi 5 đều là Tiết và các
        kinh độ có đuôi 0 đều là Khí hay Trung Khí.

        ==========================================
    ***/
    let WEATHER_TERMS_NAME = ["Đông Chí", "Tiểu Hàn", "Đại Hàn",
                            "Lập Xuân", "Vũ Thủy", "Kinh Trập",
                            "Xuân Phân", "Thanh Minh", "Cốc Vũ",
                            "Lập Hạ", "Tiểu Mãn", "Mang Chủng",
                            "Hạ Chí", "Tiểu Thử", "Đại Thử",
                            "Lập Thu", "Xử Thử", "Bạch Lộ",
                            "Thu Phân", "Hàn Lộ", "Sương Giáng",
                            "Lập Đông", "Tiểu Tuyết", "Đại Tuyết"]; 
    let SOLAR_TERMS : [(Text, Float, [Nat])] = [
        // KHẢM
        ("Đông Chí", 270.0, [1, 7, 4]), // Dương Độn
        ("Tiểu Hàn", 285.0, [2, 8, 5]),     
        ("Đại Hàn", 300.0, [3, 9, 6]),
        // CẤN
        ("Lập Xuân", 315.0, [8, 5, 2]),
        ("Vũ Thủy", 330.0, [9, 6, 3]),
        ("Kinh Trập", 345.0, [1, 7, 4]),
        // CHẤN
        ("Xuân Phân", 0.0, [3, 9, 6]),
        ("Thanh Minh", 15.0, [4, 1, 7]),
        ("Cốc Vũ", 30.0, [5, 2, 8]),
        // TỐN
        ("Lập Hạ", 45.0, [4, 1, 7]),
        ("Tiểu Mãn", 60.0, [5, 2, 8]),
        ("Mang Chủng", 75.0, [6, 3, 9]),// Hết Dương độn
        // LY
        ("Hạ Chí", 90.0, [9, 3, 6]), // Âm Độn
        ("Tiểu Thử", 105.0, [8, 2, 5]),
        ("Đại Thử", 120.0, [7, 1, 4]),
        // KHÔN
        ("Lập Thu", 135.0, [2, 5, 8]),
        ("Xử Thử", 150.0, [1, 4, 7]),
        ("Bạch Lộ", 165.0, [9, 3, 6]),
        // ĐOÀI
        ("Thu Phân", 180.0, [7, 1, 4]),
        ("Hàn Lộ", 195.0, [6, 9 ,3]),        
        ("Sương Giáng", 210.0, [5, 8, 2]),
        // CÀN
        ("Lập Đông", 225.0, [6, 9, 3]),   
        ("Tiểu Tuyết", 240.0, [5, 8, 2]),
        ("Đại Tuyết", 255.0, [4, 7 , 1]), // Hết Âm độn
    ];
    
    private func _f(x : Int, n : Int) : Int {
        let f = x + n;
        return f + (f / 10) * -9;
    };

    private func _f10(x : Int) : Int {
        return 10 - x;
    };

    public func _24_tiet_khi() : [(Text, Float, [Int])] {
        // Initialize arrays for h, m, l (indexed 1-24)
        var thuong_nguyen = Array.init<Int>(25, 0);
        var trung_nguyen = Array.init<Int>(25, 0);
        var ha_nguyen = Array.init<Int>(25, 0);
        
        // Given initial values
        thuong_nguyen[1] := 1;
        thuong_nguyen[4] := 8;
        thuong_nguyen[7] := 3;
        thuong_nguyen[10] := 4;
        
        // Second loop: calculate m, l, and extend h, m, l to 24
        for (i in Iter.range(1, 12)) {
            if (i % 3 != 1) thuong_nguyen[i] := _f(thuong_nguyen[i - 1], 1);
            // compute m[i]
            trung_nguyen[i] := _f(thuong_nguyen[i], 6);
            ha_nguyen[i] := _f(trung_nguyen[i], 6);
            
            // extend to 24
            thuong_nguyen[i + 12] := _f10(thuong_nguyen[i]);
            trung_nguyen[i + 12] := _f10(trung_nguyen[i]);
            ha_nguyen[i + 12] := _f10(ha_nguyen[i]);
        };
        
        // Build result string
        var result = "";
        for (i in Iter.range(1, 24)) {
            result := result # debug_show(i) # ": h=" # debug_show(thuong_nguyen[i]) # ", m=" # debug_show(trung_nguyen[i]) # ", l=" # debug_show(ha_nguyen[i]) # "\n";
        };
        
        var i = 0;
        var d : Float = 270 - 15;
        let res = Array.map<Text, (Text, Float, [Int])>(WEATHER_TERMS_NAME, func (x : Text) : (Text, Float, [Int]) {
            i += 1;
            d := if (d + 15 >= 359) 0 else (d + 15);
            (x, d, [thuong_nguyen[i], trung_nguyen[i], ha_nguyen[i]]);
        });

        for (t in Iter.range(0, SOLAR_TERMS.size() - 1)) {
            let (termName, degree, terms) = SOLAR_TERMS[t];
            let (tname, tdegree, tterms) = res[t];
            assert (termName == tname);
            for (j in Iter.range(0, 2)) {
                assert(terms[j] == Int.abs(tterms[j]));
            };
        };
        return res;
    };
    

    public func calculate_ganzhi_datetime(date_time : Types.DateTime) : {nam : Types.GZTimeIndex;
                                                                thang : Types.GZTimeIndex;
                                                                ngay : Types.GZTimeIndex;
                                                                gio : Types.GZTimeIndex } {
        // Tính Năm / Ngày / Giờ theo âm lịch (Thiên Can - Địa Chi)
        let jd = calculate_julian_day(date_time);

        // Year Pillar (60-year cycle)
        let year_gan_idx = (date_time.year - 4) % 10;
        let year_zhi_idx = (date_time.year - 4) % 12;

        // Day Pillar
        let day_offset = Int.abs(Float.toInt(Float.floor(jd + 1.5)));
        let day_gan_idx = (day_offset + 9) % 10;
        let day_zhi_idx = (day_offset + 1) % 12;

        // Hour Pillar
        let hour_zhi_idx = (date_time.hour + 1) / 2 % 12;
        let hour_gan_idx = (day_gan_idx * 2 + hour_zhi_idx) % 10;

        let month_branch_map = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1]; // Month 1 (Jan) -> Dần (idx 2) etc.
        let month_branch_idx = month_branch_map[(date_time.month - 1 + 12) % 12];
        
        let month_gan_idx = (year_gan_idx * 2 + month_branch_idx) % 10;

        return {
            nam = Types._newGZTime(year_gan_idx, year_zhi_idx);
            thang = Types._newGZTime(month_gan_idx, month_branch_idx);
            ngay = Types._newGZTime(day_gan_idx, day_zhi_idx);
            gio = Types._newGZTime(hour_gan_idx, hour_zhi_idx);
        };
    };
        
    private func calculate_julian_day(date : Types.DateTime) : Float {
        var y = date.year;
        var m = date.month;
        let d = Float.fromInt(date.day) + Float.fromInt(date.hour) / 24.0 + Float.fromInt(date.minute) / 1440.0;
        
        if (m <= 2) {
            y -= 1;
            m += 12;
        };
        
        let a = Float.floor(Float.fromInt(y) / 100.0);
        let b = 2.0 - a + Float.floor(a / 4.0);
        
        return Float.floor(365.25 * (Float.fromInt(y) + 4716.0)) 
                + Float.floor(30.6001 * (Float.fromInt(m) + 1.0)) 
                + d + b - 1524.5;
    };

    private func _sun_longitude(date : Types.DateTime, time_zone : Float) : Float {
        let jd = Float.fromInt(LichHND.jdFromDate(date.day, date.month, date.year));
        return LichHND.getSunLongitude(jd, time_zone);
    };

    private func _sun_longitude_1(date : Types.DateTime) : Float {
        let jd = Float.fromInt(LichHND.jdFromDate(date.day, date.month, date.year));
        return LichHND.SunLongitude(jd);
    };

    private func calculate_solar_longitude(mode : Nat, date : Types.DateTime, time_zone : Float) : Float {
        if (mode != 0) {
            return _sun_longitude(date, time_zone);
        };
        let jd = calculate_julian_day(date);
        let T = (jd - 2451545.0) / 36525.0;
        
        var L0 = 280.46646 + 36000.76983 * T + 0.0003032 * T * T;
        L0 -= Float.floor(L0 / 360.0) * 360.0;
        
        var M = 357.52911 + 35999.05029 * T - 0.0001537 * T * T;
        M -= Float.floor(M / 360.0) * 360.0;
        
        let M_rad = M * 3.1415926535 / 180.0;
        
        let C = (1.914602 - 0.004817 * T - 0.000014 * T * T) * Float.sin(M_rad)
                + (0.019993 - 0.000101 * T) * Float.sin(2.0 * M_rad)
                + 0.000289 * Float.sin(3.0 * M_rad);
                
        let sun_long = L0 + C;
        return if (sun_long < 0.0) { sun_long + 360.0 } else { sun_long };
    };

    private func _find_solar_term_index(mode : Nat, date_time : Types.DateTime, time_zone : Float) : (Nat, (Text, Float, [Int])) {
        // Tìm vị trí kinh độ mặt trời và xác định tiết khí trong 24 tiết khí / năm
        // Tìm Kinh độ mặt trời dựa vào ngày/tháng/năm dương lịch
        let sun_long = calculate_solar_longitude(mode, date_time, time_zone);
        
        let solarTerms = _24_tiet_khi();

        // Find the solar term immediately before current position
        var current_term_index = 0;
        // label f for (i in SOLAR_TERMS.keys()) {
        //     if (sun_long >= SOLAR_TERMS[i].1) {
        //         current_term_index := i;
        //     } else {
        //         break f;
        //     };
        // };
        var maxDegree : Float = 0;
        for (i in solarTerms.keys()) {
            if (sun_long >= solarTerms[i].1 and solarTerms[i].1 >= maxDegree) {
                maxDegree := solarTerms[i].1;
                current_term_index := i;
            };
        };
        return (current_term_index + 1, solarTerms[current_term_index]);
    };

    public func getSolarTerm(year : Int, month : Int, day : Int, hour : Int, minute : Int) : (Nat, (Text, Float, [Int])) {
        let t : Types.DateTime = {
            year : Nat = Int.abs(year);
            month : Nat = Int.abs(month);
            day : Nat = Int.abs(day);
            hour : Nat = Int.abs(hour);
            minute : Nat = Int.abs(minute);
        };
        _find_solar_term_index(0 , t, 7);
    };

    public func solarTerms24() : async [(Text, Float, [Int])] {
        return _24_tiet_khi();
    };
    
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

    public func bat_quai_vuong_tuong_huu_tu() : ([[Nat]]) {
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
        Buffer.toArray(state)
    };
}