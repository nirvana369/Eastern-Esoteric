import Float "mo:base/Float";
import Int "mo:base/Int";
import Math "mo:base/Float";

module LunarConverter {
    
    let PI : Float = 3.141592653589793;
    
    public func jdFromDate(dd : Int, mm : Int, yy : Int) : Int {
        let a : Int = Int.div((14 - mm), 12);
        let y : Int = yy + 4800 - a;
        let m : Int = mm + 12 * a - 3;
        var jd : Int = dd + Int.div((153 * m + 2), 5) 
            + 365 * y + Int.div(y, 4) - Int.div(y, 100) 
            + Int.div(y, 400) - 32045;
        
        if (jd < 2299161) {
            jd := dd + Int.div((153 * m + 2), 5) 
                + 365 * y + Int.div(y, 4) - 32083;
        };
        jd;
    };
    
    public func jdToDate(jd : Int) : (Int, Int, Int) {
        var a : Int = 0;
        var b : Int = 0;
        var c : Int = 0;
        
        if (jd > 2299160) {
            a := jd + 32044;
            b := Int.div(4 * a + 3, 146097);
            c := a - Int.div(b * 146097, 4);
        } else {
            b := 0;
            c := jd + 32082;
        };
        
        let d : Int = Int.div(4 * c + 3, 1461);
        let e : Int = c - Int.div(1461 * d, 4);
        let m : Int = Int.div(5 * e + 2, 153);
        let day : Int = e - Int.div(153 * m + 2, 5) + 1;
        let month : Int = m + 3 - 12 * Int.div(m, 10);
        let year : Int = b * 100 + d - 4800 + Int.div(m, 10);
        
        (day, month, year);
    };
    
    public func SunLongitude(jdn : Float) : Float {
        let T : Float = (jdn - 2451545.0) / 36525.0;
        let T2 : Float = T * T;
        let dr : Float = PI / 180.0;
        
        let M : Float = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2;
        let L0 : Float = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
        
        var DL : Float = (1.914600 - 0.004817 * T - 0.000014 * T2) * Math.sin(dr * M);
        DL += (0.019993 - 0.000101 * T) * Math.sin(dr * 2.0 * M) + 0.000290 * Math.sin(dr * 3.0 * M);
        
        var L : Float = L0 + DL;
        L := L * dr;
        L := L - PI * 2.0 * (Float.floor(L / (PI * 2.0)));
        L;
    };
    
    public func getSunLongitude(jdn : Float, timeZone : Float) : Float {
        let T : Float = (jdn - 2451545.5 - timeZone / 24.0) / 36525.0;
        let T2 : Float = T * T;
        let dr : Float = PI / 180.0;
        
        let M : Float = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2;
        var L0 : Float = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
        
        var DL : Float = (1.914600 - 0.004817 * T - 0.000014 * T2) * Math.sin(dr * M);
        DL := DL + (0.019993 - 0.000101 * T) * Math.sin(dr * 2.0 * M) + 0.000290 * Math.sin(dr * 3.0 * M);
        
        var L : Float = L0 + DL;
        let omega : Float = 125.04 - 1934.136 * T;
        L := L - 0.00569 - 0.00478 * Math.sin(omega * dr);
        L := L * dr;
        L := L - PI * 2.0 * (Float.floor(L / (PI * 2.0)));
        // Int.abs(Float.toInt(L / PI * 6.0));
        (L / PI * 6.0);
    };
    
    func NewMoon(k : Int) : Float {
        let T : Float = Float.fromInt(k) / 1236.85;
        let T2 : Float = T * T;
        let T3 : Float = T2 * T;
        let dr : Float = PI / 180.0;
        
        var Jd1 : Float = 2415020.75933 + 29.53058868 * Float.fromInt(k) 
            + 0.0001178 * T2 - 0.000000155 * T3;
        Jd1 := Jd1 + 0.00033 * Math.sin((166.56 + 132.87 * T - 0.009173 * T2) * dr);
        
        let M : Float = 359.2242 + 29.10535608 * Float.fromInt(k) - 0.0000333 * T2 - 0.00000347 * T3;
        let Mpr : Float = 306.0253 + 385.81691806 * Float.fromInt(k) + 0.0107306 * T2 + 0.00001236 * T3;
        let F : Float = 21.2964 + 390.67050646 * Float.fromInt(k) - 0.0016528 * T2 - 0.00000239 * T3;
        
        var C1 : Float = (0.1734 - 0.000393 * T) * Math.sin(M * dr) + 0.0021 * Math.sin(2.0 * dr * M);
        C1 := C1 - 0.4068 * Math.sin(Mpr * dr) + 0.0161 * Math.sin(dr * 2.0 * Mpr);
        C1 := C1 - 0.0004 * Math.sin(dr * 3.0 * Mpr);
        C1 := C1 + 0.0104 * Math.sin(dr * 2.0 * F) - 0.0051 * Math.sin(dr * (M + Mpr));
        C1 := C1 - 0.0074 * Math.sin(dr * (M - Mpr)) + 0.0004 * Math.sin(dr * (2.0 * F + M));
        C1 := C1 - 0.0004 * Math.sin(dr * (2.0 * F - M)) - 0.0006 * Math.sin(dr * (2.0 * F + Mpr));
        C1 := C1 + 0.0010 * Math.sin(dr * (2.0 * F - Mpr)) + 0.0005 * Math.sin(dr * (2.0 * Mpr + M));
        
        let deltat : Float = if (T < -11.0) {
            0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3;
        } else {
            -0.000278 + 0.000265 * T + 0.000262 * T2;
        };
        
        Jd1 + C1 - deltat;
    };
    
    public func getNewMoonDay(k : Int, timeZone : Float) : Int {
        Int.abs(Float.toInt(NewMoon(k) + 0.5 + timeZone / 24.0));
    };
    
    public func getLunarMonth11(yy : Int, timeZone : Float) : Int {
        let off : Float = Float.fromInt(jdFromDate(31, 12, yy)) - 2415021.0;
        let k : Int = Int.abs(Float.toInt(off / 29.530588853));
        var nm : Int = getNewMoonDay(k, timeZone);
        let sunLong : Int = Float.toInt(getSunLongitude(Float.fromInt(nm), timeZone));
        
        if (sunLong >= 9) {
            nm := getNewMoonDay(k - 1, timeZone);
        };
        nm;
    };
    
    public func getLeapMonthOffset(a11 : Int, timeZone : Float) : Int {
        let k : Int = Int.abs(Float.toInt((Float.fromInt(a11) - 2415021.076998695) / 29.530588853 + 0.5));
        var last : Int = 0;
        var i : Int = 1;
        var arc : Int = Float.toInt(getSunLongitude(Float.fromInt(getNewMoonDay(k + i, timeZone)), timeZone));
        
        var continueLoop : Bool = true;
        while (continueLoop) {
            last := arc;
            i += 1;
            arc := Float.toInt(getSunLongitude(Float.fromInt(getNewMoonDay(k + i, timeZone)), timeZone));
            continueLoop := (arc != last and i < 14);
        };
        i - 1;
    };
    
    public func S2L(dd : Int, mm : Int, yy : Int, timeZone : Float) : (Int, Int, Int, Int) {
        let dayNumber : Int = jdFromDate(dd, mm, yy);
        let k : Int = Int.abs(Float.toInt((Float.fromInt(dayNumber) - 2415021.076998695) / 29.530588853));
        var monthStart : Int = getNewMoonDay(k + 1, timeZone);
        
        if (monthStart > dayNumber) {
            monthStart := getNewMoonDay(k, timeZone);
        };
        
        var a11 : Int = getLunarMonth11(yy, timeZone);
        let b11 : Int = a11;
        var lunarYear : Int = yy;
        
        if (a11 >= monthStart) {
            lunarYear := yy;
            a11 := getLunarMonth11(yy - 1, timeZone);
        } else {
            lunarYear := yy + 1;
        };
        
        let lunarDay : Int = dayNumber - monthStart + 1;
        let diff : Int = Int.abs(Float.toInt(Float.fromInt(monthStart - a11) / 29.0));
        
        var lunarLeap : Int = 0;
        var lunarMonth : Int = diff + 11;
        
        if (b11 - a11 > 365) {
            let leapMonthDiff : Int = getLeapMonthOffset(a11, timeZone);
            if (diff >= leapMonthDiff) {
                lunarMonth := diff + 10;
                if (diff == leapMonthDiff) {
                    lunarLeap := 1;
                };
            };
        };
        
        if (lunarMonth > 12) {
            lunarMonth := lunarMonth - 12;
        };
        if (lunarMonth >= 11 and diff < 4) {
            lunarYear -= 1;
        };
        
        (lunarDay, lunarMonth, lunarYear, lunarLeap);
    };
    
    public func L2S(lunarD : Int, lunarM : Int, lunarY : Int, lunarLeap : Int, tZ : Float) : (Int, Int, Int) {
        var a11 : Int = 0;
        var b11 : Int = 0;
        
        if (lunarM < 11) {
            a11 := getLunarMonth11(lunarY - 1, tZ);
            b11 := getLunarMonth11(lunarY, tZ);
        } else {
            a11 := getLunarMonth11(lunarY, tZ);
            b11 := getLunarMonth11(lunarY + 1, tZ);
        };
        
        let k : Int = Int.abs(Float.toInt(0.5 + (Float.fromInt(a11) - 2415021.076998695) / 29.530588853));
        var off : Int = lunarM - 11;
        
        if (off < 0) {
            off += 12;
        };
        
        if (b11 - a11 > 365) {
            let leapOff : Int = getLeapMonthOffset(a11, tZ);
            let leapM : Int = if (leapOff - 2 < 0) { leapOff - 2 + 12 } else { leapOff - 2 };
            
            if (lunarLeap != 0 and lunarM != leapM) {
                return (0, 0, 0);
            } else if (lunarLeap != 0 or off >= leapOff) {
                off += 1;
            };
        };
        
        let monthStart : Int = getNewMoonDay(k + off, tZ);
        jdToDate(monthStart + lunarD - 1);
    };
};