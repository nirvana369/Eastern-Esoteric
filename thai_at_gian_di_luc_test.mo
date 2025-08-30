import {CAN_KIM; KHAM_THUY; CAN_THO; CHAN_MOC; TON_MOC; LY_HOA; KHON_THO; DOAI_KIM; DIA_BAN; ThaiAt} "thai_at_gian_di_luc";
import Array "mo:base/Array";
module {


    public func test_cases_1756_1828() : async (Text) {
        let MAP_DIA_BAN = Array.flatten<(Text, Nat)>([[("", 0)], DIA_BAN]);
        let test_cases_72_cuc_duong = [
            {
                year = 1756;
                thai_at = CAN_KIM;
                cuc = 1;
                van_xuong = MAP_DIA_BAN[14];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 7;
                khach = 13;
            },
            {
                year = 1757;
                thai_at = CAN_KIM;
                cuc = 2;
                van_xuong = MAP_DIA_BAN[15];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 6;
                khach = 1;
            },
            {
                year = 1758;
                thai_at = CAN_KIM;
                cuc = 3;
                van_xuong = MAP_DIA_BAN[16];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 1;
                khach = 40;
            },
            {
                year = 1759;
                thai_at = LY_HOA;
                cuc = 4;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[4];
                chu = 25;
                khach = 17;
            },
            {
                year = 1760;
                thai_at = LY_HOA;
                cuc = 5;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[6];
                chu = 25;
                khach = 14;
            },
            {
                year = 1761;
                thai_at = LY_HOA;
                cuc = 6;
                van_xuong = MAP_DIA_BAN[2];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 25;
                khach = 10;
            },
            {
                year = 1762;
                thai_at = CAN_THO;
                cuc = 7;
                van_xuong = MAP_DIA_BAN[3];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 8;
                khach = 35;//25;
            },
            {
                year = 1763;
                thai_at = CAN_THO;
                cuc = 8;
                van_xuong = MAP_DIA_BAN[4];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 1;
                khach = 22;
            },
            {
                year = 1764;
                thai_at = CAN_THO;
                cuc = 9;
                van_xuong = MAP_DIA_BAN[5];
                thuy_kich = MAP_DIA_BAN[15];
                chu = 3;
                khach = 15;
            },
            {
                year = 1765;
                thai_at = CHAN_MOC;
                cuc = 10;
                van_xuong = MAP_DIA_BAN[6];
                thuy_kich = MAP_DIA_BAN[1];
                chu = 1;
                khach = 12;
            },
            {
                year = 1766;
                thai_at = CHAN_MOC;
                cuc = 11;
                van_xuong = MAP_DIA_BAN[7];
                thuy_kich = MAP_DIA_BAN[4];
                chu = 4;
                khach = 4;
            },
            {
                year = 1767;
                thai_at = CHAN_MOC;
                cuc = 12;
                van_xuong = MAP_DIA_BAN[8];
                thuy_kich = MAP_DIA_BAN[6];
                chu = 37;
                khach = 1;
            },
            {
                year = 1768;
                thai_at = DOAI_KIM;
                cuc = 13;
                van_xuong = MAP_DIA_BAN[9];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 18;
                khach = 19;
            },
            {
                year = 1769;
                thai_at = DOAI_KIM;
                cuc = 14;
                van_xuong = MAP_DIA_BAN[10];
                thuy_kich = MAP_DIA_BAN[11];
                chu = 10;
                khach = 9;
            },
            {
                year = 1770;
                thai_at = DOAI_KIM;
                cuc = 15;
                van_xuong = MAP_DIA_BAN[11];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 9;
                khach = 7;
            },
            {
                year = 1771;
                thai_at = KHON_THO;
                cuc = 16;
                van_xuong = MAP_DIA_BAN[12];
                thuy_kich = MAP_DIA_BAN[15];
                chu = 1;
                khach = 33;
            },
            {
                year = 1772;
                thai_at = KHON_THO;
                cuc = 17;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 7;
                khach = 27;
            },
            {
                year = 1773;
                thai_at = KHON_THO;
                cuc = 18;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[3];
                chu = 7;
                khach = 26;
            },
            {
                year = 1774;
                thai_at = KHAM_THUY;
                cuc = 19;
                van_xuong = MAP_DIA_BAN[14];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 8;
                khach = 32;
            },
            {
                year = 1775;
                thai_at = KHAM_THUY;
                cuc = 20;
                van_xuong = MAP_DIA_BAN[15];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 7;
                khach = 26;
            },
            {
                year = 1776;
                thai_at = KHAM_THUY;
                cuc = 21;
                van_xuong = MAP_DIA_BAN[16];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 2;
                khach = 17;
            },
            {
                year = 1777;
                thai_at = TON_MOC;
                cuc = 22;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[12];
                chu = 16;
                khach = 30;
            },
            {
                year = 1778;
                thai_at = TON_MOC;
                cuc = 23;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[14];
                chu = 16;
                khach = 23;
            },
            {
                year = 1779;
                thai_at = TON_MOC;
                cuc = 24;
                van_xuong = MAP_DIA_BAN[2];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 16;
                khach = 17;
            },
            {
                year = 1780;
                thai_at = CAN_KIM;
                cuc = 25;
                van_xuong = MAP_DIA_BAN[3];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 29;//39; warning
                khach = 40;
            },
            {
                year = 1781 ;
                thai_at = CAN_KIM;
                cuc = 26;
                van_xuong = MAP_DIA_BAN[4];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 22;//32; warning
                khach = 31;
            },
            {
                year =1782 ;
                thai_at = CAN_KIM;
                cuc = 27;
                van_xuong = MAP_DIA_BAN[5];
                thuy_kich = MAP_DIA_BAN[7];
                chu = 31;
                khach = 38;//28; warning
            },
            {
                year =1783 ;
                thai_at = LY_HOA;
                cuc = 28;
                van_xuong = MAP_DIA_BAN[6];
                thuy_kich = MAP_DIA_BAN[9];
                chu = 14;
                khach = 9;
            },
            {
                year =1784 ;
                thai_at = LY_HOA;
                cuc = 29;
                van_xuong = MAP_DIA_BAN[7];
                thuy_kich = MAP_DIA_BAN[12];
                chu = 12; //13; warning
                khach = 39;
            },
            {
                year =1785 ;
                thai_at = LY_HOA;
                cuc = 30;
                van_xuong = MAP_DIA_BAN[8];
                thuy_kich = MAP_DIA_BAN[14];
                chu = 10;
                khach = 32;
            },
            {
                year =1786 ;
                thai_at = CAN_THO;
                cuc = 31;
                van_xuong = MAP_DIA_BAN[9];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 33;
                khach = 10;
            },
            {
                year =1787 ;
                thai_at = CAN_THO;
                cuc = 32;
                van_xuong = MAP_DIA_BAN[10];
                thuy_kich = MAP_DIA_BAN[3];
                chu = 25;
                khach = 8;
            },
            {
                year =1788 ;
                thai_at = CAN_THO;
                cuc = 33;
                van_xuong = MAP_DIA_BAN[11];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 24;
                khach = 3;
            },
            {
                year =1789 ;
                thai_at = CHAN_MOC;
                cuc = 34;
                van_xuong = MAP_DIA_BAN[12];
                thuy_kich = MAP_DIA_BAN[7];
                chu = 26;
                khach = 4;
            },
            {
                year =1790 ;
                thai_at = CHAN_MOC;
                cuc = 35;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 25;
                khach = 28;
            },
            {
                year =1791 ;
                thai_at = CHAN_MOC;
                cuc = 36;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[11];
                chu = 25;
                khach = 27;
            },
            {
                year =1792 ;
                thai_at = DOAI_KIM;
                cuc = 37;
                van_xuong = MAP_DIA_BAN[14];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 1;
                khach = 7;
            },
            {
                year =1793 ;
                thai_at = DOAI_KIM;
                cuc = 38;
                van_xuong = MAP_DIA_BAN[15];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 6;
                khach = 25;//35; warning
            },
            {
                year =1794 ;
                thai_at = DOAI_KIM;
                cuc = 39;
                van_xuong = MAP_DIA_BAN[16];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 35;
                khach = 34;
            },
            {
                year =1795 ;
                thai_at = KHON_THO;
                cuc = 40;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[4];
                chu = 27;
                khach = 19;
            },
            {
                year =1796 ;
                thai_at = KHON_THO;
                cuc = 41;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[6];
                chu = 27;
                khach = 16;
            },
            {
                year =1797 ;
                thai_at = KHON_THO;
                cuc = 42;
                van_xuong = MAP_DIA_BAN[2];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 27;
                khach = 12;
            },
            {
                year =1798 ;
                thai_at = KHAM_THUY;
                cuc = 43;
                van_xuong = MAP_DIA_BAN[3];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 8;
                khach = 17;
            },
            {
                year =1799 ;
                thai_at = KHAM_THUY;
                cuc = 44;
                van_xuong = MAP_DIA_BAN[4];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 33;
                khach = 14;
            },
            {
                year =1800 ;
                thai_at = KHAM_THUY;
                cuc = 45;
                van_xuong = MAP_DIA_BAN[5];
                thuy_kich = MAP_DIA_BAN[15];
                chu = 32;
                khach = 7;
            },
            {
                year =1801 ;
                thai_at = TON_MOC;
                cuc = 46;
                van_xuong = MAP_DIA_BAN[6];
                thuy_kich = MAP_DIA_BAN[1];
                chu = 3;//5; warning
                khach = 16;
            },
            {
                year =1802 ;
                thai_at = TON_MOC;
                cuc = 47;
                van_xuong = MAP_DIA_BAN[7];
                thuy_kich = MAP_DIA_BAN[4];
                chu = 4;
                khach = 8;
            },
            {
                year =1803 ;
                thai_at = TON_MOC;
                cuc = 48;
                van_xuong = MAP_DIA_BAN[8];
                thuy_kich = MAP_DIA_BAN[6];
                chu = 1;
                khach = 5;
            },
            {
                year =1804 ;
                thai_at = CAN_KIM;
                cuc = 49;
                van_xuong = MAP_DIA_BAN[9];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 24;
                khach = 25;
            },
            {
                year =1805 ;
                thai_at = CAN_KIM;
                cuc = 50;
                van_xuong = MAP_DIA_BAN[10];
                thuy_kich = MAP_DIA_BAN[11];
                chu = 16;
                khach = 15;
            },
            {
                year =1806 ;
                thai_at = CAN_KIM;
                cuc = 51;
                van_xuong = MAP_DIA_BAN[11];
                thuy_kich = MAP_DIA_BAN[13];
                chu = 15;
                khach = 13;
            },
            {
                year =1807 ;
                thai_at = LY_HOA;
                cuc = 52;
                van_xuong = MAP_DIA_BAN[12];
                thuy_kich = MAP_DIA_BAN[15];
                chu = 39;
                khach = 31;
            },
            {
                year =1808 ;
                thai_at = LY_HOA;
                cuc = 53;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 38;
                khach = 35;//25; warning
            },
            {
                year =1809 ;
                thai_at = LY_HOA;
                cuc = 54;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[3];
                chu = 38;
                khach = 24;
            },
            {
                year =1810 ;
                thai_at = CAN_THO;
                cuc = 55;
                van_xuong = MAP_DIA_BAN[14];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 16;
                khach = 3;
            },
            {
                year =1811 ;
                thai_at = CAN_THO;
                cuc = 56;
                van_xuong = MAP_DIA_BAN[15];
                thuy_kich = MAP_DIA_BAN[8];
                chu = 15;
                khach = 34;
            },
            {
                year =1812 ;
                thai_at = CAN_THO;
                cuc = 57;
                van_xuong = MAP_DIA_BAN[16];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 10;
                khach = 25;
            },
            {
                year =1813 ;
                thai_at = CHAN_MOC;
                cuc = 58;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[12];
                chu = 12;
                khach = 19;//26; warning
            },
            {
                year =1814 ;
                thai_at = CHAN_MOC;
                cuc = 59;
                van_xuong = MAP_DIA_BAN[1];
                thuy_kich = MAP_DIA_BAN[14];
                chu = 12;
                khach = 19;
            },
            {
                year =1815 ;
                thai_at = CHAN_MOC;
                cuc = 60;
                van_xuong = MAP_DIA_BAN[2];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 12;
                khach = 13;
            },
            {
                year =1816 ;
                thai_at = DOAI_KIM;
                cuc = 61;
                van_xuong = MAP_DIA_BAN[3];
                thuy_kich = MAP_DIA_BAN[2];
                chu = 25;//33;
                khach = 33;//34; warning
            },
            {
                year =1817 ;
                thai_at = DOAI_KIM;
                cuc = 62;
                van_xuong = MAP_DIA_BAN[4];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 34;//26;
                khach = 26;//25; warning
            },
            {
                year =1818 ;
                thai_at = DOAI_KIM;
                cuc = 63;
                van_xuong = MAP_DIA_BAN[5];
                thuy_kich = MAP_DIA_BAN[7];
                chu = 25;
                khach = 22;
            },
            {
                year =1819 ;
                thai_at = KHON_THO;
                cuc = 64;
                van_xuong = MAP_DIA_BAN[6];
                thuy_kich = MAP_DIA_BAN[9];
                chu = 16;
                khach = 11;
            },
            {
                year =1820 ;
                thai_at = KHON_THO;
                cuc = 65;
                van_xuong = MAP_DIA_BAN[7];
                thuy_kich = MAP_DIA_BAN[12];
                chu = 15;
                khach = 1;
            },
            {
                year =1821 ;
                thai_at = KHON_THO;
                cuc = 66;
                van_xuong = MAP_DIA_BAN[8];
                thuy_kich = MAP_DIA_BAN[14];
                chu = 12;
                khach = 34;
            },
            {
                year =1822 ;
                thai_at = KHAM_THUY;
                cuc = 67;
                van_xuong = MAP_DIA_BAN[9];
                thuy_kich = MAP_DIA_BAN[16];
                chu = 25;
                khach = 2;
            },
            {
                year =1823 ;
                thai_at = KHAM_THUY;
                cuc = 68;
                van_xuong = MAP_DIA_BAN[10];
                thuy_kich = MAP_DIA_BAN[3];
                chu = 17;
                khach = 8;
            },
            {
                year =1824 ;
                thai_at = KHAM_THUY;
                cuc = 69;
                van_xuong = MAP_DIA_BAN[11];
                thuy_kich = MAP_DIA_BAN[5];
                chu = 16;
                khach = 23;//32; warning
            },
            {
                year =1825 ;
                thai_at = TON_MOC;
                cuc = 70;
                van_xuong = MAP_DIA_BAN[12];
                thuy_kich = MAP_DIA_BAN[7];
                chu = 30;
                khach = 4;
            },
            {
                year =1826 ;
                thai_at = TON_MOC;
                cuc = 71;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[10];
                chu = 29;
                khach = 32;
            },
            {
                year = 1827;
                thai_at = TON_MOC;
                cuc = 72;
                van_xuong = MAP_DIA_BAN[13];
                thuy_kich = MAP_DIA_BAN[11];
                chu = 29;
                khach = 31;
            }
        ];
        var output = "";
        for (test in test_cases_72_cuc_duong.vals()) {
            let t = ThaiAt(test.year);
            let ta = t.tim_thai_at();
            let cuc = t.tinh_cuc();
            let van_xuong = t.tim_thien_muc_van_xuong();
            let (_, thuy_kich) = t.tim_khach_muc_thuy_kich();
            let (_, chu_khach) = t.tim_chu_khach();
            let assertThaiAt = (ta.cung.0 == test.thai_at.0 and ta.cung.1 == test.thai_at.1);
            let assertCuc = (cuc.0 == test.cuc);
            let assertVanXuong = (van_xuong.0 == test.van_xuong.0 and van_xuong.1 == test.van_xuong.1);
            let assertThuyKich = (thuy_kich.0 == test.thuy_kich.0 and thuy_kich.1 == test.thuy_kich.1);
            let assertChu = (chu_khach.0 == test.chu);
            let assertKhach = (chu_khach.1 == test.khach);
            let chu_khach_1 = t.tim_chu_khach_1();
            let assertChu1 = (chu_khach_1.0 == test.chu);
            let assertKhach1 = (chu_khach_1.1 == test.khach);
            if (not assertThaiAt or not assertCuc or not assertVanXuong or not assertThuyKich or not assertChu or not assertKhach) {
                output #= "\n===================================";
                output #= debug_show(test.year) # "\n";
                output #= debug_show(cuc) # "\n";
                if (not assertThaiAt) output #= debug_show(ta) # "\n";
                if (not assertVanXuong) output #= debug_show(van_xuong) # "\n";
                if (not assertThuyKich) output #= debug_show(thuy_kich) # "\n";
                if (not assertChu or not assertKhach) output #= debug_show(chu_khach) # "\n";
                if (not assertChu1 or not assertKhach1) output #= debug_show(chu_khach_1) # " (**1)\n";
            };
        };
        return output;
    }; 

    public func test() : async Text {
        let MAP_DIA_BAN = Array.flatten<(Text, Nat)>([[("", 0)], DIA_BAN]);
        // need implement 72 cục dương độn - Thái ất giản dị lục (page 99 - 111) 
        let test_cases = [
            {
                year = 619;
                thai_at = KHON_THO;
                cuc = 16;
                van_xuong = MAP_DIA_BAN[11];
                thuy_kich = MAP_DIA_BAN[14];
                chu = 1;
                khach = 33;
            },
            {
                year = 287;
                thai_at = KHAM_THUY;
                cuc = 44;
                van_xuong = MAP_DIA_BAN[3];
                thuy_kich = MAP_DIA_BAN[12];
                chu = 33;
                khach = 14;
            },
            {
                year = -114;
                thai_at = LY_HOA;
                cuc = 4;
                van_xuong = MAP_DIA_BAN[0];
                thuy_kich = MAP_DIA_BAN[3];
                chu = 25;
                khach = 17;
            },
            {
                year = 260;
                thai_at = KHON_THO;
                cuc = 17;
                van_xuong = MAP_DIA_BAN[12];
                thuy_kich = MAP_DIA_BAN[1];
                chu = 7;
                khach = 27;
            },
            {
                year = 196;
                thai_at = CAN_KIM;
                cuc = 25;
                van_xuong = MAP_DIA_BAN[2];
                thuy_kich = MAP_DIA_BAN[1];
                chu = 29;
                khach = 19;
            }
        ];
        
        for (test in test_cases.vals()) {
            let t = ThaiAt(test.year);
            let ta = t.tim_thai_at();
            let cuc = t.tinh_cuc();
            let van_xuong = t.tim_thien_muc_van_xuong();
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
};