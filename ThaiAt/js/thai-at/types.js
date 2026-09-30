export const CAN = Object.freeze({GIAP:'Giáp', AT:'Ất', BINH:'Bính', DINH:'Đinh', MAU:'Mậu', KY:'Kỷ', CANH:'Canh', TAN:'Tân', NHAM:'Nhâm', QUY:'Quý'});
export const CHI = Object.freeze({TY:'Tý', SUU:'Sửu', DAN:'Dần', MAO:'Mão', THIN:'Thìn', TI:'Tị', NGO:'Ngọ', MUI:'Mùi', THAN:'Thân', DAU:'Dậu', TUAT:'Tuất', HOI:'Hợi'});
export const THIEN_CAN=Object.values(CAN), DIA_CHI=Object.values(CHI);
export const CAN_KIM=['Càn',1], LY_HOA=['Ly',2], CAN_THO=['Cấn',3], CHAN_MOC=['Chấn',4], TRUNG=['Trung',5], DOAI_KIM=['Đoài',6], KHON_THO=['Khôn',7], KHAM_THUY=['Khảm',8], TON_MOC=['Tốn',9];
export const BAT_QUAI=[CAN_KIM,LY_HOA,CAN_THO,CHAN_MOC,TRUNG,DOAI_KIM,KHON_THO,KHAM_THUY,TON_MOC];
export const CLOCK_BAT_QUAI=[CAN_KIM,KHAM_THUY,CAN_THO,CHAN_MOC,TON_MOC,LY_HOA,KHON_THO,DOAI_KIM];
export const DIA_BAN=[[CAN_KIM[0],1],[CHI.HOI,2],[CHI.TY,3],[CHI.SUU,4],[CAN_THO[0],5],[CHI.DAN,6],[CHI.MAO,7],[CHI.THIN,8],[TON_MOC[0],9],[CHI.TI,10],[CHI.NGO,11],[CHI.MUI,12],[KHON_THO[0],13],[CHI.THAN,14],[CHI.DAU,15],[CHI.TUAT,16]];
export const BAT_MON=[['Khai',1],['Hưu',8],['Sinh',3],['Thương',4],['Đỗ',9],['Cảnh',2],['Tử',7],['Kinh',6]];
export const CUU_TINH=[['Thiên Bồng',1],['Thiên Nhuế',2],['Thiên Xung',3],['Thiên Phụ',4],['Thiên Cầm',5],['Thiên Tâm',6],['Thiên Trụ',7],['Thiên Nhậm',8],['Thiên Anh',9]];
export const THAP_LUC_THAN=[['Âm Đức',1],['Đại nghĩa',2],['Địa Chu',3],['Dương Đức',4],['Hòa Đức',5],['Lã Thân',6],['Cao Tùng',7],['Thái Dương',8],['Đại Trắc',9],['Đại Thần',10],['Thiên Uy',11],['Thiên Đạo',12],['Đại Vũ',13],['Vũ Đức',14],['Thái Thốc',15],['Âm Chủ',16]];
export const LAYOUT=[[9,2,7],[4,5,6],[3,8,1]];
export function newGZTime(can,chi){ if(can<0||can>9) throw new Error('Thiên Can index từ 0-9'); if(chi<0||chi>11) throw new Error('Địa Chi index từ 0-11'); return {can,chi}; }
export const gzText=g=>`${THIEN_CAN[g.can]} ${DIA_CHI[g.chi]}`;
