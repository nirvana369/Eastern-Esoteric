import Debug "mo:base/Debug";
import Int "mo:base/Int";

module {
    
    public let CAN_KIM = ("Càn", 1);
    public let LY_HOA = ("Ly", 2);
    public let CAN_THO = ("Cấn", 3);
    public let CHAN_MOC = ("Chấn", 4);
    public let TRUNG = ("Trung", 5);
    public let DOAI_KIM = ("Đoài", 6);
    public let KHON_THO = ("Khôn", 7);
    public let KHAM_THUY = ("Khảm", 8);
    public let TON_MOC = ("Tốn", 9);
    public let THIEN_CAN : [Text] = ["Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ", "Canh", "Tân", "Nhâm", "Quý"];
    public let DIA_CHI : [Text] = ["Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi"];
    

    public type DateTime = {
        year : Nat;
        month : Nat;
        day : Nat;
        hour : Nat;
        minute : Nat;
    };

    public type GZTimeIndex = {
        can : Nat; // can - mapping with THIEN_CAN
        chi : Nat;  // chi - mapping with DIA_CHI
    };

    public func _newGZTime(g : Nat, z : Nat) : GZTimeIndex {
        if (g + 1 > 10) Debug.trap("Thiên Can index từ 0-9");
        if (z + 1 > 12) Debug.trap("Địa Chi index từ 0-11");
        return {
            can = g;
            chi = z;
        };
    };

    public func _newGZTimeInt(g_int : Int, z_int : Int) : GZTimeIndex {
        let g = Int.abs(g_int);
        let z = Int.abs(z_int);
        if (g + 1 > 10) Debug.trap("Thiên Can index từ 0-9");
        if (z + 1 > 12) Debug.trap("Địa Chi index từ 0-11");
        return {
            can = g;
            chi = z;
        };
    };
}