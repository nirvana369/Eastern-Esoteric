const TERMS=[
  ['Đông Chí',270],['Tiểu Hàn',285],['Đại Hàn',300],
  ['Lập Xuân',315],['Vũ Thủy',330],['Kinh Trập',345],
  ['Xuân Phân',0],['Thanh Minh',15],['Cốc Vũ',30],
  ['Lập Hạ',45],['Tiểu Mãn',60],['Mang Chủng',75],
  ['Hạ Chí',90],['Tiểu Thử',105],['Đại Thử',120],
  ['Lập Thu',135],['Xử Thử',150],['Bạch Lộ',165],
  ['Thu Phân',180],['Hàn Lộ',195],['Sương Giáng',210],
  ['Lập Đông',225],['Tiểu Tuyết',240],['Đại Tuyết',255]
];
const mod=(x,m)=>((x%m)+m)%m;
export function calculateJulianDay(date){let y=date.year,m=date.month;const d=date.day+date.hour/24+date.minute/1440;if(m<=2){y--;m+=12}const a=Math.floor(y/100),b=2-a+Math.floor(a/4);return Math.floor(365.25*(y+4716))+Math.floor(30.6001*(m+1))+d+b-1524.5}
export function calculateSolarLongitude(date){const jd=calculateJulianDay(date),T=(jd-2451545)/36525;let L0=mod(280.46646+36000.76983*T+0.0003032*T*T,360);let M=mod(357.52911+35999.05029*T-0.0001537*T*T,360);const r=M*Math.PI/180;const C=(1.914602-0.004817*T-0.000014*T*T)*Math.sin(r)+(0.019993-0.000101*T)*Math.sin(2*r)+0.000289*Math.sin(3*r);return mod(L0+C,360)}
export function findSolarTerm(date){const lon=calculateSolarLongitude(date);let idx=0,max=-1;for(let i=0;i<TERMS.length;i++){const deg=TERMS[i][1];if(lon>=deg&&deg>=max){max=deg;idx=i}}return {index:idx+1,name:TERMS[idx][0],longitude:TERMS[idx][1],solarLongitude:lon}}

export function calculateGanzhiDate(date){
  // Direct port of solar24.mo::calculate_ganzhi_datetime.
  const jd=calculateJulianDay(date);
  const yearGan=mod(date.year-4,10);
  const yearZhi=mod(date.year-4,12);
  const dayOffset=Math.abs(Math.floor(jd+1.5));
  const dayGan=mod(dayOffset+9,10);
  const dayZhi=mod(dayOffset+1,12);
  const hourZhi=mod(Math.floor((date.hour+1)/2),12);
  const hourGan=mod(dayGan*2+hourZhi,10);
  const monthBranchMap=[2,3,4,5,6,7,8,9,10,11,0,1];
  const monthBranch=monthBranchMap[mod(date.month-1,12)];
  const monthGan=mod(yearGan*2+monthBranch,10);
  return {nam:{can:yearGan,chi:yearZhi},thang:{can:monthGan,chi:monthBranch},ngay:{can:dayGan,chi:dayZhi},gio:{can:hourGan,chi:hourZhi}};
}

export function solarTerms24(){return TERMS.map((x,i)=>[x[0],x[1],[i+1]])}
export function batQuaiVuongTuong(){const base=[1,8,3,4,9,2,7,6],out=[base];const move=(i,s)=> (s+i)%8;for(let i=1;i<8;i++){const row=[];for(let j=0;j<8;j++)row.push(base[move(j,i)]);out.push(row)}return out}
const WEATHER_TERMS=['Đông Chí','Lập Xuân','Xuân Phân','Lập Hạ','Hạ Chí','Lập Thu','Thu Phân','Lập Đông'];
export function batQuaiState(cung,tietKhi){const names=['Vượng','Tướng','Thai','Một','Tù','Tử','Hưu','Phế'];const qi=['Càn','Ly','Cấn','Chấn','Trung','Đoài','Khôn','Khảm','Tốn'];const ci=qi.indexOf(cung);const ti=WEATHER_TERMS.indexOf(tietKhi);if(ci<0||ti<0)return 'Not found!';const base=[1,8,3,4,9,2,7,6];const palaceId=ci+1;const pos=base.indexOf(palaceId);if(pos<0)return 'Not found!';return names[mod(pos-ti,8)]}
export const Solar24={calculateJulianDay,calculateGanzhiDate,calculateSolarLongitude,findSolarTerm,solarTerms24,batQuaiVuongTuong,batQuaiState};
