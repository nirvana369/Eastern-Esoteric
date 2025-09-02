/*******************************************************************
* Copyright         : 2025 nirvana369
* File Name         : KMDG.mo
* Description       : Kỳ Môn Độn Giáp
*                    
* Revision History  :
* Date				Author    		Comments
* ---------------------------------------------------------------------------
* 08/08/2025		nirvana369 		implement
* 20/08/2025 TODO : Research => Định nghĩa tiết khí : Lập đông, hàn lộ, tiểu hàn
* 20/08/2025 TODO : BUG => Tính tiết khí ngày : 20/1/2025 10h36 Đại Hàn -> tính sai Tiểu Hàn 
* 28/08/2025 Confirm: research 20/08/2025 => Kỳ môn độn giáp - đàm liên -> lập đông , hàn lộ 693          +1
                                             Kỳ môn độn giáp bí kíp toàn thư -> lập đông, hàn lộ 693      +2
                                             Kỳ môn độn giáp - nguyễn mạnh bảo -> lập đông, hàn lộ 693    +3
******************************************************************/

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import LichHND "LichHND";
import AmLich "AmLich";
import Types "types";
import Solar24 "solar24";

module {
    // --- Constants ---

    // This is the order for displaying the 3x3 grid, starting from top-left.
    let DISPLAY_ORDER : [Nat] = [4, 9, 2, 3, 5, 7, 8, 1, 6];
    
    // Basic Astrological Data
    let THIEN_CAN : [Text] = Types.THIEN_CAN;
    let DIA_CHI : [Text] = Types.DIA_CHI;
    let DOORS : [(Nat, Text)] = [(1, "Hưu"), 
                                    (8, "Sinh"), 
                                    (3, "Thương"), 
                                    (4, "Đỗ"), 
                                    (9, "Cảnh"), 
                                    (2, "Tử"), 
                                    (7, "Kinh"), 
                                    (6, "Khai")];
                                    // Phù Xà Âm Hợp Hổ Vũ Địa Thiên
    let GODS : [Text] = ["Trực Phù", "Đằng Xà", "Thái Âm", "Lục Hợp", "Bạch Hổ", "Huyền Vũ", "Cửu Địa", "Cửu Thiên"];
    let STARS : [(Nat, Text)] = [(1,"Thiên Bồng"),
                                (8, "Thiên Nhậm"),
                                (3, "Thiên Xung"),
                                (4, "Thiên Phụ"),
                                (9, "Thiên Anh"),
                                (2, "Thiên Nhuế"),
                                (7, "Thiên Trụ"),
                                (6, "Thiên Tâm"),
                                (5, "Thiên Cầm")];
    
    let STAR_ORIGINAL_PALACE : [(Text, Nat)] = [
        ("Thiên Bồng", 1), ("Thiên Nhuế", 2), ("Thiên Xung", 3), ("Thiên Phụ", 4),
        ("Thiên Cầm", 5), ("Thiên Tâm", 6), ("Thiên Trụ", 7), ("Thiên Nhậm", 8), ("Thiên Anh", 9)
    ];

    type TRUNG_CUNG_MODE = {
        #General;
        #ThauDiaKyMon;
    };

    type GZTimeIndex = Types.GZTimeIndex;

    let _newGZTime = Types._newGZTime;

    let SOLAR_TERMS = Solar24.SOLAR_TERMS;

    let PALACE_NAMES : [(Nat, Text)] = [
        (1, "Khảm"), (2, "Khôn"), (3, "Chấn"), (4, "Tốn"), 
        (5, "Trung"), (6, "Càn"), (7, "Đoài"), (8, "Cấn"), (9, "Ly")
    ];

    // Hậu thiên bát quái
    let CUNG = {
        CAN_KIM = 5;
        KHAM_THUY = 0;
        CAN_THO = 7;
        CHAN_MOC = 2;
        TRUNG = 4;
        TON_MOC = 3;
        LY_HOA = 8;
        KHON_THO = 1;
        DOAI_KIM = 6;
    };
    // -------------------------------------------------------------
    // PUBLIC TYPES
    // -------------------------------------------------------------

    public type DateTime = {
        year : Nat;
        month : Nat;
        day : Nat;
        hour : Nat;
        minute : Nat;
    };

    public type Palace = {
        number : Nat;
        name : Text;
        stem_heaven : Text;
        stem_earth : Text;
        star : Text;
        door : Text;
        god : Text;
        is_center : Bool;
    };

    public type PalaceX = {
        var cung_id : Nat;
        var cung_name : Text;
        var thien_can_dia_ban : Text;
        var thien_can_thien_ban : Text;
        var chi : Text;
        var cuu_tinh : Text;
        var bat_mon : Text;
        var bat_than : Text;
        var is_center : Bool;
    };

    public type ChartData = {
        date_time : DateTime;
        nam : GZTimeIndex;
        thang : GZTimeIndex;
        ngay : GZTimeIndex;
        gio : GZTimeIndex;
        tuan_thu : GZTimeIndex; // Tuần Thủ
        phu_dau : GZTimeIndex;  // Phù Đầu
        nghi_an_giap : Text;
        am_duong_don : (Int, Text);
        tiet_khi_index : Nat;
        tam_nguyen : (Nat, Text);
        don_cuc_so : Nat;
        khong_vong : [Text];
        direct_star : Text;
        direct_door : Text;
        palaces : [Palace];
        information : [Text];
    };

    func _new_palace() : PalaceX {
        return  {
            var cung_id : Nat = 0;
            var cung_name : Text = "";
            var thien_can_dia_ban : Text = "";
            var thien_can_thien_ban : Text = "";
            var chi : Text = "";
            var cuu_tinh : Text = "";
            var bat_mon : Text = "";
            var bat_than : Text = "";
            var is_center : Bool = false;
        };
    };

    public class KyMonTranDo(palaces: [Palace]) {

        let CELL_WIDTH = 30;
        // Hàm tìm Palace theo number
        func findPalace(num : Nat) : Palace {
            switch (Array.find<Palace>(palaces, func (p) { p.number == num })) {
                case (?p) p;
                case null { Debug.trap("Invalid data") }; // Không bao giờ xảy ra với dữ liệu đã cho
            }
        };
        
        // Định nghĩa các trường cần hiển thị theo thứ tự
        let fields : [(Text, (Palace) -> Text)] = [
            ("", func (p: Palace) : Text { p.name # " (" # Nat.toText(p.number + 1) # ")" }),
            ("", func (p: Palace) : Text { "[" # p.stem_heaven # "] - " # p.stem_earth }),
            ("", func (p: Palace) : Text { p.star }),
            ("", func (p: Palace) : Text { p.door }),
            ("", func (p: Palace) : Text { p.god })
            // Thêm trường mới ở đây
        ];

        // Định nghĩa layout hậu thiên bát quái đồ
        let layout : [[Nat]] = [
            [3, 8, 1],
            [2, 4, 6],
            [7, 0, 5]
        ];

        func createHorizontalLine() : Text {
            "+" # Text.join("" ,Array.tabulate<Text>((CELL_WIDTH + 1) * 3, func _ = ".").vals()) # "+\n"
        };

        func formatCell(content: Text) : Text {
            let padding = (CELL_WIDTH - Text.size(content)) / 2;
            let leftPad = Text.join("" ,Array.tabulate<Text>(padding, func _ = ".").vals());
            let rightPad = Text.join("" ,Array.tabulate<Text>(CELL_WIDTH - padding - Text.size(content), func _ = ".").vals());
            leftPad # content # rightPad
        };

        func createRow(rowIds : [Nat], fieldIndex: Nat) : Text {
            var row = "|";
            for (num in rowIds.vals()) {
                let p = findPalace(num);
                let content = if (num == 4 and fieldIndex > 1) "" 
                            else fields[fieldIndex].1(p);
                row := row # formatCell(content) # "|";
            };
            row # "\n"
        };

        public func lapTran() : Text {
            var output = createHorizontalLine();
            
            for (row in layout.vals()) {
                for (fieldIndex in Iter.range(0, fields.size() - 1)) {
                    output := output # createRow(row, fieldIndex);
                };
                output := output # "|" # Text.join("" ,Array.tabulate<Text>((CELL_WIDTH + 1) * 3, func _ = ".").vals()) # "|\n";
            };
            
            output := output # createHorizontalLine();
            output
        };

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

    private func clockMove(initPos : Nat, direction : Int, callback : (Nat, Nat) -> (), syncPos : Nat) {
        let clockmap = [0, 7, 2, 3, 8, 1, 6, 5];
        var canIdx = switch (Array.indexOf(initPos, clockmap, Nat.equal)) {
            case (?idx) idx;
            case (null) 0;
        };
        var canSyncIdx = switch (Array.indexOf(syncPos, clockmap, Nat.equal)) {
            case (?idx) idx;
            case (null) 0;
        };
        for (i in Iter.range(0, 7)) {
            callback(clockmap[canIdx], clockmap[canSyncIdx]);
            canIdx := move(7, canIdx, direction);
            canSyncIdx := move(7, canSyncIdx, direction);
        };
    };

    private func hauThienBatQuaiMove(initPos : Nat, direction : Int, callback : (Nat) -> ()) {
        var can = initPos;
        for (i in Iter.range(0, 8)) {
            callback(can);
            can := move(8, can, direction);
        };
    };

    private func _tuan_thu(h : GZTimeIndex) : GZTimeIndex {
        //  Tìm Tuần Thủ
        var can = h.can;
        var chi = h.chi;
        while (can != 0) {
            can := move(9, can, -1);
            chi := move(11, chi, -1);
        };
        return _newGZTime(can, chi);
    };

    private func _mapping(p : PalaceX) : Palace {
        return {
                number : Nat = p.cung_id;
                name : Text = p.cung_name;
                stem_heaven : Text = p.thien_can_thien_ban;
                stem_earth : Text = p.thien_can_dia_ban;
                star : Text = p.cuu_tinh;
                door : Text = p.bat_mon;
                god : Text = p.bat_than;
                is_center : Bool = p.is_center;
            };
    };

    func _khong_vong(t : GZTimeIndex) : (Nat, Nat) {
        // Tìm không vong : Từ thời gia tìm tuần thủ, biết Giáp gì lấy 2 Chi trước giáp đó
        let td = _tuan_thu(t);
        let chi_kv_1 = move(11, td.chi, -1);
        let chi_kv_2 = move(11, chi_kv_1, -1);
        (chi_kv_1, chi_kv_2);
    };

    private func _find_solar_term_index(mode : Nat, date_time : DateTime, time_zone : Float) : Nat {
        // Tìm vị trí kinh độ mặt trời và xác định tiết khí trong 24 tiết khí / năm
        // Tìm Kinh độ mặt trời dựa vào ngày/tháng/năm dương lịch
        let (current_term_index, _) = Solar24._find_solar_term_index(mode, date_time, time_zone);
        return current_term_index;
    };
        
    private func _phu_dau(d : GZTimeIndex) : GZTimeIndex {
        // Tìm Phù Đầu
        var can = d.can;
        var chi = d.chi;
        if (can <= 4) {
            while (can != 0) {
                can := move(9, can, -1);
                chi := move(11, chi, -1);
            };
        } else {
            while (can != 5) {
                can := move(9, can, -1);
                chi := move(11, chi, -1);
            };
        };
        
        return _newGZTime(can, chi);
    };

    private func _nghi_hidden_giap(tuan_thu : GZTimeIndex) : Text {
        // Xác định Nghi ẩn Giáp dựa vào chi của Tuần thủ : 
        // Giáp :   Tý - Mậu
        //          Tuất - Kỷ
        //          Thân ...
        //          ... 
        // Xun Shou is the first stem in the current 10-day cycle
        let luc_nghi = switch(tuan_thu.chi) {
            case (0) "Mậu";  // Giáp Tý
            case (10) "Kỷ";   // Giáp Tuất
            case (8) "Canh"; // Giáp Thân
            case (6) "Tân";  // Giáp Ngọ
            case (4) "Nhâm"; // Giáp Thìn
            case (2) "Quý"; // Giáp Dần
            case _ "Mậu"; // Default (shouldn't happen)
        };
        return luc_nghi;
    };

    private func _sun_longitude(date : DateTime, time_zone : Float) : Float {
        let jd = Float.fromInt(LichHND.jdFromDate(date.day, date.month, date.year));
        return LichHND.getSunLongitude(jd, time_zone);
    };

    private func _sun_longitude_1(date : DateTime) : Float {
        let jd = Float.fromInt(LichHND.jdFromDate(date.day, date.month, date.year));
        return LichHND.SunLongitude(jd);
    };

    public func don_giap_ky_mon(cuc : Nat,
                                    am_duong_don : Int, 
                                    can_gio : Text, 
                                    chi_gio : Text
                                    ) : (Text) {
        if (cuc < 1 or cuc > 9) Debug.trap("Cục không hợp lệ! Giá trị nhận từ 1-9");
        if (am_duong_don == 0 or am_duong_don < -1 or am_duong_don > 1) Debug.trap("Dương độn: 1 / Âm độn : -1");
        let can_gio_index : Nat = switch (Array.indexOf<Text>(can_gio, THIEN_CAN, Text.equal)) {
            case (?id) id;
            case (null) Debug.trap("Can giờ không hợp lệ!");
        };
        let chi_gio_index : Nat = switch (Array.indexOf<Text>(chi_gio, DIA_CHI, Text.equal)) {
            case (?id) id;
            case (null) Debug.trap("Chi giờ không hợp lệ!");
        };
        let log = Buffer.Buffer<Text>(0);

        let don_cuc : Int = cuc - 1;

        // Lập trận : có tổng cộng 1080 trận = 2 (âm/dương) * 9 (cục) * 60 (can chi/lục thập hoa giáp)
        let palaces = _don_giap_ky_mon(don_cuc, _newGZTime(can_gio_index, chi_gio_index), am_duong_don, log);

        let lap_tran_ky_mon = KyMonTranDo(palaces);
        let data = lap_tran_ky_mon.lapTran();
        
        _addInfomation(log, [data]);
        (Text.join("\n", log.vals()));
    };

    private func _don_giap_ky_mon(don_cuc : Int,
                                    gio : GZTimeIndex,
                                    am_duong_don : Int,
                                    log : Buffer.Buffer<Text>)  : [Palace] {

        let direction : Int = am_duong_don; // Dương đi thuận - Âm đi nghịch;

        let luc_nghi_map = ["Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý", "Đinh", "Bính", "Ất"];
        
        let don_giap_ban = HashMap.HashMap<Text, PalaceX>(0, Text.equal, Text.hash);
        let mapping_can_cung = HashMap.HashMap<Nat, Text>(0, Nat.equal, Hash.hash);
        let don_giap_cung = HashMap.fromIter<Nat, Text>(PALACE_NAMES.vals(), PALACE_NAMES.size(), Nat.equal, Hash.hash);
        
        // Độn giáp
        // An Địa bàn Lục nghi - tam kỳ
        var cung_don_giap_idx = Int.abs(don_cuc); // Đã giảm 1 để mapping với index 9 cung địa bàn từ 0 - 8; Đảm bảo cục luôn > 0
        var luc_nghi_start = 0; // Luôn bắt đầu từ can Mậu để đếm - khởi từ cung của số độn cục
        hauThienBatQuaiMove(cung_don_giap_idx, direction, func (index) {
            let p = _new_palace();
            p.cung_id := index;
            p.cung_name := Option.get(don_giap_cung.get(index + 1), "None");
            p.thien_can_dia_ban := luc_nghi_map[luc_nghi_start];

            p.is_center := ((p.cung_id + 1) == 5);

            don_giap_ban.put(p.thien_can_dia_ban, p);
            mapping_can_cung.put(index, p.thien_can_dia_ban);
            luc_nghi_start := move(8, luc_nghi_start, 1);
        });

        _an_thien_ban(don_giap_ban, mapping_can_cung, gio, am_duong_don, log);

        let truc_phu = truc_phu__an_cuu_tinh(don_giap_ban, mapping_can_cung, gio, am_duong_don, log);

        truc_su__an_bat_mon(don_giap_ban, mapping_can_cung, gio, am_duong_don, log);
        
        _an_bat_than(don_giap_ban, mapping_can_cung, gio, truc_phu, am_duong_don, log);

        var final_palaces = Buffer.Buffer<Palace>(9);
        for ((can, p) in don_giap_ban.entries()) {
            final_palaces.add(_mapping(p));
        };

        return Buffer.toArray(final_palaces);
    };

    private func _trung_cung_process(trungCungMode : TRUNG_CUNG_MODE, am_duong_don : Int) : Nat {
        switch (trungCungMode) {
            case (#ThauDiaKyMon) {
                // Theo Thấu Địa Kỳ Môn thì Dương Độn Thiên Cầm ký cung Khôn (2), Âm Độn ký cung Cấn (8)
                // if (chart_data.am_duong_don == "Dương Độn") (CUNG.KHON) else (CUNG.CAN);
                if (am_duong_don > 0) { // chart_data.am_duong_don.0 > 0
                    return CUNG.KHON_THO
                };
                return CUNG.CAN_THO;
            };
            // Theo Kỳ môn độn giáp thì luôn ký cung Khôn (2)
            case (_) return CUNG.KHON_THO;
        };
    };

    private func _an_thien_ban(don_giap_ban : HashMap.HashMap<Text, PalaceX>,
                                        mapping_can_cung : HashMap.HashMap<Nat, Text>,
                                        gio : GZTimeIndex,
                                        am_duong_don : Int,
                                        _ : Buffer.Buffer<Text>) {
        
        let tuan_thu = _tuan_thu(gio);
        let nghi_an_giap = _nghi_hidden_giap(tuan_thu);
        let thien_can_gio = THIEN_CAN[gio.can];

        var nghi_truc_phu = switch (don_giap_ban.get(nghi_an_giap)) {
            case (?p) {
                if (p.is_center) {
                    _trung_cung_process(#General, am_duong_don);
                } else {
                    p.cung_id
                };
            };
            case (null) 0;  // không xảy ra - nếu xảy ra có nghĩa độn giáp địa bàn không tồn tại (Lục) Nghi Ẩn Giáp
        };

        // Tìm vị trí Trực Phù gia Thời Can
        let truc_phu = switch (don_giap_ban.get(thien_can_gio)) {
                case (?p) {
                    if (p.is_center) {
                        _trung_cung_process(#General, am_duong_don);
                    } else {
                        p.cung_id
                    };
                };
                case (null) (nghi_truc_phu); // trường hợp thiên can giờ rơi vào can Giáp -> lấy can Tuần Thủ
            };

        // An Thiên Bàn
        clockMove(truc_phu, 1, func (index, syncIndex) {
            let can_cung = Option.get(mapping_can_cung.get(index), "");
            switch (don_giap_ban.get(can_cung)) {
                case (?palace) {
                    let can_thien_ban = Option.get(mapping_can_cung.get(syncIndex), "");
                    palace.thien_can_thien_ban := can_thien_ban;
                };
                case (null) ();
            };
        }, nghi_truc_phu);
    };

    private func truc_phu__an_cuu_tinh(don_giap_ban : HashMap.HashMap<Text, PalaceX>,
                                        mapping_can_cung : HashMap.HashMap<Nat, Text>,
                                        gio : GZTimeIndex,
                                        am_duong_don : Int,
                                        log : Buffer.Buffer<Text>) : Nat {
        let tuan_thu = _tuan_thu(gio);
        let nghi_an_giap = _nghi_hidden_giap(tuan_thu);
        let thien_can_gio = THIEN_CAN[gio.can];

        let stars = HashMap.fromIter<Nat, Text>(STARS.vals(), STARS.size(), Nat.equal, Hash.hash);
        let star_pos = func (idx : Nat) : Text = Option.get<Text>(stars.get(idx + 1), "");

        var cuu_tinh = "";
        // An cửu tinh theo Tuần Thủ
        var nghi_truc_phu = switch (don_giap_ban.get(nghi_an_giap)) {
            case (?p) {
                if (p.is_center) {
                    cuu_tinh := "Thiên Cầm -> cung ";
                    _trung_cung_process(#General, am_duong_don);
                } else {
                    cuu_tinh := star_pos(p.cung_id) # " -> cung ";
                    p.cung_id
                };
            };
            case (null) 0;  // không xảy ra - nếu xảy ra có nghĩa độn giáp địa bàn không tồn tại (Lục) Nghi Ẩn Giáp
        };

        // chart_data := {
        //     chart_data with
        //     direct_star = star_pos(nghi_truc_phu);
        // };
        _addInfomation(log, ["chart.direct_star => " # star_pos(nghi_truc_phu)]);

        var star_start_index = switch (Array.indexOf<(Nat, Text)>((0, star_pos(nghi_truc_phu)), STARS, func (x, y) : Bool = x.1 == y.1)) {
            case (?idx) idx;
            case (null) 0;
        };

        // Tìm vị trí Trực Phù gia Thời Can
        let truc_phu = switch (don_giap_ban.get(thien_can_gio)) {
                case (?p) {
                    if (p.is_center) {
                        _trung_cung_process(#General, am_duong_don);
                    } else {
                        p.cung_id
                    };
                };
                case (null) (nghi_truc_phu); // trường hợp thiên can giờ rơi vào can Giáp -> lấy can Tuần Thủ
            };
        

        _addInfomation(log, ["Trực Phù : " # cuu_tinh # Nat.toText(truc_phu + 1)]);
        
        // Tìm Thiên Bàn Cửu Tinh
        clockMove(truc_phu, 1, func (index, _) {
            let can_cung = Option.get(mapping_can_cung.get(index), "");
            switch (don_giap_ban.get(can_cung)) {
                case (?palace) {
                    palace.cuu_tinh := STARS[star_start_index].1;
                    // if (star_start_index + 1 == 2) {
                    //     // Nếu là Thiên Nhuế thì Thiên Cầm cùng cung
                    //     _addInfomation(["Thiên Cầm -> " # palace.cung_name]);
                    // };
                    star_start_index := move(7, star_start_index, 1);
                };
                case (null) ();
            };
        }, 0);

        return truc_phu;
    };

    private func truc_su__an_bat_mon(don_giap_ban : HashMap.HashMap<Text, PalaceX>,
                                        mapping_can_cung : HashMap.HashMap<Nat, Text>,
                                        gio : GZTimeIndex,
                                        am_duong_don : Int,
                                        log : Buffer.Buffer<Text>) {

        let direction : Int = am_duong_don; // Dương đi thuận - Âm đi nghịch;
        let tuan_thu = _tuan_thu(gio);
        let nghi_an_giap = _nghi_hidden_giap(tuan_thu);

        let doors = HashMap.fromIter<Nat, Text>(DOORS.vals(), DOORS.size(), Nat.equal, Hash.hash);
        let door_pos = func (idx : Nat) : Text = Option.get<Text>(doors.get(idx + 1), "");
        
        var bat_mon = "";
        // An Bát môn theo Tuần Thủ
        // tìm vị trí Bát môn đầu tiên chuyển về Thiên bàn
        // nếu Nghi ẩn Giáp Tuần Thủ ở Trung cung => không có bát môn => sẽ lấy theo trực phù
        // Tức ở Trung cung nếu Dương độn thì lấy Khôn (Tử Môn), Âm độn thì lấy Cấn (Sinh môn)
        var nghi_truc_su = switch (don_giap_ban.get(nghi_an_giap)) {
            case (?p) {
                if (p.is_center) {
                    bat_mon := "Trung cung -> cung ";
                    _trung_cung_process(#General, am_duong_don);
                } else {
                    bat_mon := door_pos(p.cung_id) # " -> cung ";
                    p.cung_id
                };
            };
            case (null) 0;
        };

        var door_start_index = switch (Array.indexOf<(Nat, Text)>((0, door_pos(nghi_truc_su)), DOORS, func (x, y) : Bool = x.1 == y.1)) {
            case (?idx) idx;
            case (null) 0;
        };
        
        // chart_data := {
        //     chart_data with
        //     direct_door = door_pos(nghi_truc_su);
        // };
        _addInfomation(log, ["chart.direct_door => " # door_pos(nghi_truc_su)]);

        var truc_su = nghi_truc_su;
        var chi_tuan_thu_idx = tuan_thu.chi;
        // Tìm Trực Sử - Dương độn đễm xuôi, Âm độn đếm ngược đi theo Hậu thiên bát quái
        // Từ Nghi Ẩn Giáp đếm Chi cho đến Chi Thời gia
        // Nếu Nghi ẩn Giáp ở tại trung cung thì vẫn đếm từ trung cung
        var vi_tri_nghi_tuan_thu = switch (don_giap_ban.get(nghi_an_giap)) {
            case (?p) p.cung_id;
            case (null) 0;
        };
        var found = false;
        hauThienBatQuaiMove(vi_tri_nghi_tuan_thu, direction, func (index) {
            
            if (not found) {
                _addInfomation(log, [DIA_CHI[chi_tuan_thu_idx]]);

                let can_cung = Option.get(mapping_can_cung.get(index), "");
                let is_trung_cung = switch (don_giap_ban.get(can_cung)) {
                                        case (?palace) palace.is_center;
                                        case (null) (false);
                                    };

                // Đếm chi chứ không đếm can !! Đếm từ Chi Tuần Thủ đến chi của Thời chi
                if (not found and DIA_CHI[chi_tuan_thu_idx] == DIA_CHI[gio.chi]) {
                    // Trường hợp trực sử nhập trung cung mà trung cung thì không có chứa Bát môn
                    // => Trực sử chuyển vào cung Khôn (2) - Tử môn
                    truc_su := if (is_trung_cung) _trung_cung_process(#General, am_duong_don) else index;
                    found := true;
                };
            };
            chi_tuan_thu_idx := move(11, chi_tuan_thu_idx, 1);

        });

        _addInfomation(log, [("Trực sử : " # bat_mon # Nat.toText(truc_su + 1))]);
        // Tìm Thiên Bàn Bát Môn
        // Trực Sử môn gia Thời Chi
        clockMove(truc_su, 1, func (index, _) {
            let can_cung = Option.get(mapping_can_cung.get(index), "");
            switch (don_giap_ban.get(can_cung)) {
                case (?palace) {
                    palace.bat_mon := DOORS[door_start_index].1;
                    door_start_index := move(7, door_start_index, 1);
                };
                case (null) ();
            };
        }, 0);
    };

    private func _an_bat_than(don_giap_ban : HashMap.HashMap<Text, PalaceX>,
                                mapping_can_cung : HashMap.HashMap<Nat, Text>,
                                gio : GZTimeIndex,
                                truc_phu : Nat,
                                am_duong_don : Int,
                                _ : Buffer.Buffer<Text>) {
        let direction : Int = am_duong_don; // Dương đi thuận - Âm đi nghịch;
        let thien_can_gio = THIEN_CAN[gio.can];
        // An Bát thần
        var bat_than_idx = 0;
        var tieu_truc_phu = switch (don_giap_ban.get(thien_can_gio)) {
            case (?p) {
                if (p.is_center) {
                    truc_phu
                } else {
                    p.cung_id
                };
            };
            case (null) truc_phu;
        };

        clockMove(tieu_truc_phu, direction, func (index, _) {
            let can_cung = Option.get(mapping_can_cung.get(index), "");
            switch (don_giap_ban.get(can_cung)) {
                case (?palace) {
                    palace.bat_than := GODS[bat_than_idx];
                    bat_than_idx += 1;
                };
                case (null) ();
            };
        }, 0);
    };
        
    func _addInfomation(log : Buffer.Buffer<Text>, data : [Text]) {
        for (item in data.vals()) log.add(item);
    };


    public class KyMonDonGiap() {

        let log = Buffer.Buffer<Text>(0);
        var solar_longitude_calc_mode = 0;

        public func reset_data() : ChartData {
            return {
                date_time = {
                    year : Nat = 0;
                    month : Nat = 0;
                    day : Nat = 0;
                    hour : Nat = 0;
                    minute : Nat = 0;
                };
                nam = _newGZTime(0, 0);
                thang = _newGZTime(0, 0);
                ngay = _newGZTime(0, 0);
                gio = _newGZTime(0, 0);
                tuan_thu = _newGZTime(0, 0);
                phu_dau = _newGZTime(0, 0);
                nghi_an_giap = "";
                am_duong_don = (0, ""); don_cuc_so = 0; khong_vong = [];
                direct_star = ""; direct_door = ""; tiet_khi_index = 0; tam_nguyen = (0, "");
                palaces = []; information = [];
            };
        };

        var trungCungMode : TRUNG_CUNG_MODE = #General;

        var chart_data : ChartData = reset_data();

        public func setTrungCungMode(mode : TRUNG_CUNG_MODE) {
            trungCungMode := mode;
        };

        public func setSolarLongitudeCalcMode(m : Nat) {
            solar_longitude_calc_mode := m;
        };

        public func tim_tuan_thu() {
            chart_data := {
                chart_data with
                tuan_thu = _tuan_thu(chart_data.gio);
            };
        };

        public func tim_phu_dau() {
            chart_data := {
                chart_data with
                phu_dau = _phu_dau(chart_data.ngay);
            };
        };

        public func tim_nguyen() {
            // Tìm Nguyên (Thượng - Trung - Hạ) dựa vào Phù đầu (Giáp/Kỷ) + Chi
            // Nếu Địa Chi  thuộc tứ Chính => Thượng Nguyên
            //      -       thuộc tứ Sinh => Trung Nguyên
            //      -       thuộc tứ Mộ => Hạ Nguyên
            let nguyen_index = if (chart_data.phu_dau.chi % 3 == 0) {
                                // tứ chính
                                (0, "Thượng Nguyên");
                            } else if (chart_data.phu_dau.chi % 3 == 2) {
                                // tứ sinh
                                (1, "Trung Nguyên");
                            } else { // chart_data.chi_phu_dau_index % 3 == 1
                                // tứ mộ
                                (2, "Hạ Nguyên");
                            };
            chart_data := {
                chart_data with
                tam_nguyen = nguyen_index;
            }
        };

        public func calculate_chart(date_time : DateTime) : Text {

            log.clear();
            chart_data := {
                chart_data with
                date_time : DateTime = {
                    year = date_time.year;
                    month = date_time.month;
                    day = date_time.day;
                    hour = date_time.hour;
                    minute = date_time.minute;
                };
            };
            if (solar_longitude_calc_mode == 0) {
                chart_data := {
                    chart_data with
                    date_time : DateTime = {
                        year = date_time.year;
                        month = date_time.month;
                        day = date_time.day - 1; // date_time_convert_to_can_chi(0); => old calculate need day - 1
                        hour = date_time.hour;
                        minute = date_time.minute;
                    };
                };
            };
            // 1. Calculate Bazi (Four Pillars)
            // calculate_bazi();
            // // 3. Calculate Month Ganzhi (This must be after solar term)
            // calculate_month_ganzhi();
            date_time_convert_to_can_chi(solar_longitude_calc_mode);

            // 2. Determine Solar Term
            find_solar_term_index();
            

            tim_tuan_thu();

            tim_phu_dau();

            find_luc_nghi();
            
            tim_nguyen();

            // 4. Determine Dun Type and Ju Number
            determine_dun_ju();

            // 5. Find Void Branches (Không Vong)
            find_khong_vong();
            
            // 7. Arrange all elements on the chart
            arrange_palaces();

            getQimonInfo();
        };

        public func getQimonInfo() : Text {
            let info = Buffer.Buffer<Text>(0);
            info.add("Năm: " # THIEN_CAN[chart_data.nam.can] # " " # DIA_CHI[chart_data.nam.can]);
            info.add("Tháng: " # THIEN_CAN[chart_data.thang.can] # " " # DIA_CHI[chart_data.thang.chi]);
            info.add("Ngày: " # THIEN_CAN[chart_data.ngay.can] # " " # DIA_CHI[chart_data.ngay.chi]);
            info.add("Giờ: " # THIEN_CAN[chart_data.gio.can] # " " # DIA_CHI[chart_data.gio.chi]);
            info.add("Tuần Thủ: " # THIEN_CAN[chart_data.tuan_thu.can] # " " # DIA_CHI[chart_data.tuan_thu.chi] # " - Lục Nghi: " # chart_data.nghi_an_giap);
            info.add("Phù đầu: " # THIEN_CAN[chart_data.phu_dau.can] # " " # DIA_CHI[chart_data.phu_dau.chi]);

            info.add("Tiết khí : " # SOLAR_TERMS[chart_data.tiet_khi_index].0 # " | Nguyên: " # chart_data.tam_nguyen.1 # " | " # chart_data.am_duong_don.1 # " | Cục: " # debug_show(chart_data.don_cuc_so));
            info.add(debug_show(SOLAR_TERMS[chart_data.tiet_khi_index]));
            
            for (log in chart_data.information.vals()) info.add(log);

            let ky_mon_tran = KyMonTranDo(chart_data.palaces);
            let bat_quai_do_3x3 = ky_mon_tran.lapTran();
            info.add(bat_quai_do_3x3);

            Text.join("\n-------------\n", info.vals());
        };

        private func calculate_bazi() {
            // Tính Năm / Ngày / Giờ theo âm lịch (Thiên Can - Địa Chi)
            let date_time : DateTime = chart_data.date_time;
            let jd = Solar24.calculate_julian_day(date_time);

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

            chart_data := {
                chart_data with 
                nam = _newGZTime(year_gan_idx, year_zhi_idx);
                ngay = _newGZTime(day_gan_idx, day_zhi_idx);
                gio = _newGZTime(hour_gan_idx, hour_zhi_idx);
            };
        };
        
        private func calculate_month_ganzhi() {
            // Tính Tháng theo âm lịch (Thiên Can - Địa Chi)
            let date_time = chart_data.date_time;
            let month_branch_map = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1]; // Month 1 (Jan) -> Dần (idx 2) etc.
            let month_branch_idx = month_branch_map[(date_time.month - 1 + 12) % 12];
            
            let year_gan_idx = (date_time.year - 4) % 10;
            let month_gan_idx = (year_gan_idx * 2 + month_branch_idx) % 10;

            chart_data := {
                chart_data with 
                thang = _newGZTime(month_gan_idx, month_branch_idx);
            };
        };

        private func date_time_convert_to_can_chi(mode : Nat) {
            let dt = chart_data.date_time;
            if (mode != 0) {
                let (gzNam, gzThang, gzNgay, gzGio) = AmLich.ngayThangNamCanChi(dt.day, dt.month, dt.year, dt.hour, 7);
                chart_data := {
                    chart_data with 
                    nam = gzNam;
                    thang = gzThang;
                    ngay = gzNgay;
                    gio = gzGio;
                };
                return;
            };
            calculate_bazi();
            calculate_month_ganzhi();
        };
        
        private func find_solar_term_index() {
            let current_term_index = _find_solar_term_index(solar_longitude_calc_mode, chart_data.date_time, 7);
            
            chart_data := {
                chart_data with
                tiet_khi_index = current_term_index; // mapping with SOLAR_TERMS[solar_index]
            };
        };
        
        private func determine_dun_ju() {
            //  Xác định Âm/Dương độn và số Cục

            // Determine Dun type
            // Hạ Chí (idx 6) to Đại Tuyết (idx 17) -> Âm Độn
            // Đông Chí (idx 18) to Mang Chủng (idx 5) -> Dương Độn
            let am_duong_don = if (chart_data.tiet_khi_index > 5 and chart_data.tiet_khi_index < 18) {
                (-1, "Âm Độn"); // Yin Dun
            } else {
                (1, "Dương Độn"); // Yang Dun
            };
            // tìm cục dựa vào tiết khí & nguyên (thượng/trung/hạ)
            let cuc = (SOLAR_TERMS[chart_data.tiet_khi_index].2)[chart_data.tam_nguyen.0];

            chart_data := {
                chart_data with
                am_duong_don = am_duong_don;
                don_cuc_so = cuc;
            };
        };
        
        private func find_khong_vong() {
            let kv_thang = _khong_vong(chart_data.thang);
            var kv = "Không vong:\n -Tháng: " # DIA_CHI[kv_thang.0] # ", " #  DIA_CHI[kv_thang.1];
            
            let kv_ngay = _khong_vong(chart_data.ngay);
            kv #= "\n -Ngày: " # DIA_CHI[kv_ngay.0] # ", "  #  DIA_CHI[kv_ngay.1];
            
            let kv_gio = _khong_vong(chart_data.gio);
            kv #= "\n -Giờ: " # DIA_CHI[kv_gio.0] # ", "  #  DIA_CHI[kv_gio.1];
            
            _addInfomation(log, [kv]);

            chart_data := {
                chart_data with
                khong_vong = [DIA_CHI[kv_gio.0], DIA_CHI[kv_gio.1]] 
            };
        };

        private func find_luc_nghi() {
            chart_data := {
                chart_data with
                nghi_an_giap = _nghi_hidden_giap(chart_data.tuan_thu);
            }
        };

        private func arrange_palaces() {

            let don_cuc : Int = chart_data.don_cuc_so - 1;
            let am_duong_don = chart_data.am_duong_don.0;

            let palaces = _don_giap_ky_mon(don_cuc, chart_data.gio, am_duong_don, log);

            chart_data := {
                chart_data with
                palaces = palaces;
                information = Array.flatten([chart_data.information, Buffer.toArray(log)]);
            };
        };

        public func get_chart() : ChartData {
            return chart_data;
        };

        public func convert(dt : DateTime) : ({day : Int; month : Int; year : Int; isLeap : Int},
                                                        {nam : GZTimeIndex; thang : GZTimeIndex; ngay : GZTimeIndex; gio : GZTimeIndex},
                                                        {nam : Text; thang : Text; ngay : Text; gio : Text},
                                                        {sun_longitude_original: Float; sun_term_index_original: Nat;
                                                        sun_longitude : Float;
                                                        sun_term_index : Nat; sun_longitude_1 : Float}) {
            let (lunarDay, lunarMonth, lunarYear, lunarLeap) = AmLich.ngayThangNam(dt.day, dt.month, dt.year, true, 7);
            let amLich = {
                day = lunarDay;
                month = lunarMonth;
                year = lunarYear;
                isLeap = lunarLeap;
            };

            let (gzNam, gzThang, gzNgay, gzGio) = AmLich.ngayThangNamCanChi(dt.day, dt.month, dt.year, dt.hour, 7);
            let canChiIndex = { 
                nam = gzNam;
                thang = gzThang;
                ngay = gzNgay;
                gio = gzGio;
            };

            let canChi = {
                nam = ("Năm: " # THIEN_CAN[canChiIndex.nam.can] # " " # DIA_CHI[canChiIndex.nam.chi]);
                thang = ("Tháng: " # THIEN_CAN[canChiIndex.thang.can] # " " # DIA_CHI[canChiIndex.thang.chi]);
                ngay = ("Ngày: " # THIEN_CAN[canChiIndex.ngay.can] # " " # DIA_CHI[canChiIndex.ngay.chi]);
                gio = ("Giờ: " # THIEN_CAN[canChiIndex.gio.can] # " " # DIA_CHI[canChiIndex.gio.chi]);
            };
            let sun = {
                sun_longitude_original = Solar24.calculate_solar_longitude(0, dt, 7);
                sun_term_index_original = _find_solar_term_index(0, dt, 7);
                sun_longitude = Solar24.calculate_solar_longitude(1, dt, 7);
                sun_term_index = _find_solar_term_index(1, dt, 7);
                sun_longitude_1 = _sun_longitude_1(dt);
            };
            return (amLich, canChiIndex, canChi, sun);
        };
    };

    public func KMDG_FROM_DATETIME(prompt : DateTime, solarCalcMode : Nat) : async (Text, ChartData) {
        let qimen = KyMonDonGiap();
        qimen.setSolarLongitudeCalcMode(solarCalcMode);
        let chart = qimen.calculate_chart(prompt);
        (chart, qimen.get_chart());
    };

    public func KMDG_FROM_STATE(cuc : Nat,
                                        am_duong_don : Int, 
                                        can_gio : Text, 
                                        chi_gio : Text) : async (Text) {
        let chart = don_giap_ky_mon(cuc, am_duong_don, can_gio, chi_gio);
        (chart);
    };

    public func KMDG_AMLICH(prompt : DateTime) : async ({day : Int; month : Int; year : Int; isLeap : Int},
                                                        {nam : GZTimeIndex; thang : GZTimeIndex; ngay : GZTimeIndex; gio : GZTimeIndex},
                                                        {nam : Text; thang : Text; ngay : Text; gio : Text},
                                                        {sun_longitude_original: Float; sun_term_index_original: Nat;
                                                        sun_longitude : Float;
                                                        sun_term_index : Nat; sun_longitude_1 : Float}) {
        let qimen = KyMonDonGiap();
        return qimen.convert(prompt);
    };
};
