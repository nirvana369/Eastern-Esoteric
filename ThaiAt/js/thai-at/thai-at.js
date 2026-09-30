import {CAN,CHI,THIEN_CAN,DIA_CHI,BAT_QUAI,CLOCK_BAT_QUAI,DIA_BAN,BAT_MON,KHAM_THUY,CAN_KIM,LY_HOA,CAN_THO,CHAN_MOC,TRUNG,DOAI_KIM,KHON_THO,TON_MOC} from './types.js';
import {solarToLunar,formatLunar} from '../calendar/calendar-adapter.js';
import {Solar24} from './solar24.js';

const pair=(name,id)=>[name,id];
const eq=(a,b)=>a&&b&&a[0]===b[0]&&a[1]===b[1];
function move(max,s,step){let ret=s,count=step;if(count<0){while(count!==0){ret=ret===0?max:ret-1;count++}}else{while(count!==0){ret=ret>=max?0:ret+1;count--}}return ret}
function findIndex(arr,pred){const i=arr.findIndex(pred);return i<0?null:i}
function gzText(g){return `${THIEN_CAN[g.can]} ${DIA_CHI[g.chi]}`}
function mod(a,b){return ((a%b)+b)%b}
function moveCycle60(can=0,chi=0,stop=60){const out=[];for(let i=0;i<stop;i++){out.push({id:i+1,gz:{can,chi}});can=(can+1)%10;chi=(chi+1)%12}return out}

export class ThaiAt{
  static NAM_NGUYEN_2821=1683;
  static TICH_NIEN_GIAP_TI_THUONG_CO=2821*3600;
  constructor(year){this.year=Number(year);this.month=1;this.day=1;this.hour=1;this.minute=1;this.ke_type='year';this.is_duong_cuc=true;this.yearGanZhi={can:0,chi:0}}
  set_month(m){this.month=Number(m);this.ke_type='month'}
  set_day(d){this.day=Number(d);this.ke_type='day'}
  set_hour(h,m){this.hour=Number(h);this.minute=Number(m);this.ke_type='hour'}
  getYear(){return this.year>0?String(this.year):`${Math.abs(this.year)} TCN`}
  getKeType(){return {code:this.ke_type,name:{year:'Tuế Kế',month:'Nguyệt Kế',day:'Nhật Kế',hour:'Thời Kế'}[this.ke_type]||'Tuế Kế'}}
  getDuongLich(){return `${this.hour}:${String(this.minute).padStart(2,'0')} ${this.day}/${this.month}/${this.year}`}
  getAmLich(){return formatLunar(this.day,this.month,this.year)}
  getGZAmLich(){const gz=Solar24.calculateGanzhiDate({year:this.year,month:this.month,day:this.day,hour:this.hour,minute:this.minute});return `Giờ: ${gzText(gz.gio)} | Ngày: ${gzText(gz.ngay)} | Tháng: ${gzText(gz.thang)} | Năm: ${gzText(gz.nam)}`}
  getSolarTerm(){const st=Solar24.findSolarTerm({year:this.year,month:this.month,day:this.day,hour:this.hour,minute:this.minute});return [st.index,[st.name,st.longitude,[st.index]] ]}

  tich_nien(){
    const gz=Solar24.calculateGanzhiDate({year:this.year,month:this.month,day:this.day,hour:this.hour,minute:this.minute});this.yearGanZhi=gz.nam;
    if(this.ke_type==='month'){
      const l=solarToLunar(this.day,this.month,this.year);const t=(this.year-424)*12-1+l.month;return this.year<0?Math.abs(t+1)+3:Math.abs(t)+3;
    }
    if(this.ke_type==='day'){
      // Source chưa hoàn thiện Nhật Kế: giữ hook, dùng ngày liên tục làm provisional index.
      return Math.abs(Math.floor((this.year-424)*365.2425+this.month*30+this.day));
    }
    if(this.ke_type==='hour'){
      const [solarIndex]=this.getSolarTerm();if(solarIndex>12)this.is_duong_cuc=false;
      const target=gz.ngay;let so=0;for(const x of moveCycle60(0,0,181)){if(eq([THIEN_CAN[x.gz.can],DIA_CHI[x.gz.chi]],[THIEN_CAN[target.can],DIA_CHI[target.chi]])){so=x.id;break}}
      let t=Math.floor(((this.hour+1)*60+this.minute)/2);t=(t%60===0)?t/60:Math.floor(t/60)+1;return (so-1)*12+t;
    }
    const t=ThaiAt.TICH_NIEN_GIAP_TI_THUONG_CO+(this.year-ThaiAt.NAM_NGUYEN_2821);return this.year<0?Math.abs(t+1):Math.abs(t);
  }
  tue_ke(){let t=this.tich_nien()%3600;if(t>360)t%=360;return t}
  tim_thai_at(){let tk=this.tue_ke()%24;if(tk===0)tk=24;const start=(this.ke_type==='hour'&&!this.is_duong_cuc)?8:0;const direction=(this.ke_type==='hour'&&!this.is_duong_cuc)?-1:1;let idx=start,nam=tk;while(nam>3){idx=move(8,idx,direction);if(idx!==4)nam-=3}return {cung:BAT_QUAI[idx],stayed_year:nam%3===0?3:nam%3,so:tk}}
  thai_at_nguyet_ke(thang){let tMonth=mod((this.year-424)*12,3600);if(tMonth>360)tMonth%=360;let nguyen=0,m=tMonth+(thang-1);while(tMonth>60){nguyen=move(2,nguyen,1);tMonth-=60}tMonth+=(thang-1)+3;const seq=moveCycle60(0,0,60);const x=seq.find(z=>z.id===tMonth);m+=3;while(m>72)m-=72;return [tMonth,x?gzText(x.gz):'',nguyen,m]}
  dai_du_thai_at(){let cung_chu=mod(this.tich_nien()+34,2880)%288;let idx=6,dai_du=cung_chu;while(dai_du>36){idx=move(8,idx,1);if(idx!==4)dai_du-=36}return [[cung_chu,dai_du],BAT_QUAI[idx]]}
  tieu_du_thai_at(){const direction=this.year<714?-1:1;let td=(this.year-714)*direction,idx=0;while(td>36){idx=move(8,idx,direction);if(idx!==4)td-=36}return BAT_QUAI[idx]}
  tim_ky_nguyen_giap_ty(){const t=this.tue_ke();let k=Math.floor(t/60);if(t%60!==0)k++;const name=k%3===0?'Hạ nguyên':k%3===1?'Thượng nguyên':'Trung nguyên';const n=t%60;const x=moveCycle60(0,0,60).find(z=>z.id===n);return [name,n,x?gzText(x.gz):'']}
  bat_mon(){let du=this.tich_nien()%2400;if(du>240)du%=240;let mi=0;while(du>30){mi=move(7,mi,1);du-=30}const truc=BAT_MON[mi],out=[],ta=this.tim_thai_at();let ti=findIndex(CLOCK_BAT_QUAI,x=>eq(x,ta.cung));for(let i=0;i<8;i++){out.push([BAT_MON[mi][0],CLOCK_BAT_QUAI[ti]]);mi=move(7,mi,1);ti=move(7,ti,1)}return [truc[0],out]}
  phuong_vi_phuc_tinh(){const n=this.tue_ke()%60;const x=moveCycle60(0,0,60).find(z=>z.id===n);if(!x)return '';return [CHI.DAN,CHI.SUU,CHI.TY,CHI.HOI,CHI.THAN,CHI.MUI,CHI.NGO,CHI.TI,CHI.THIN,CHI.MAO][x.gz.can]}
  tinh_cuc(){const t=this.tue_ke(),phep=Math.floor(t/72),canIndex=phep*2,nguyen=`${THIEN_CAN[canIndex%10]} ${CHI.TY}`;let current='';const seq=moveCycle60(canIndex%10,0,72);const x=seq.find(z=>z.id===t%72);if(x)current=gzText(x.gz);return [t%72===0?72:t%72,nguyen,current]}
  tim_ke_than(){const n=this.tich_nien()%12,start=(this.ke_type==='hour'&&!this.is_duong_cuc)?8:2,idx=move(11,start,(n-1)*-1);return [n,DIA_BAN.filter(x=>x[0]===DIA_CHI[idx])[0]||[DIA_CHI[idx],idx+1]]}
  tim_thien_muc_van_xuong(){let tm=this.tich_nien()%18;if(tm===0)tm=18;const start=(this.ke_type==='hour'&&!this.is_duong_cuc)?DIA_BAN[5][1]:DIA_BAN[13][1];let count=1,idx=start-1;while(count<tm){idx=move(15,idx,1);if(start===DIA_BAN[13][1]){if(idx===0||idx===12)count++}else if(idx===4||idx===8)count++;count++}return [tm,DIA_BAN[idx]]}
  tim_khach_muc_thuy_kich(){const [,kt]=this.tim_ke_than(),ki=findIndex(DIA_BAN,x=>x[0]===kt[0]);const [,vx]=this.tim_thien_muc_van_xuong();let ci=ki,ti=4;while(ci!==vx[1]-1){ci=move(15,ci,1);ti=move(15,ti,1)}return [[],DIA_BAN[ti]]}
  mapChiCan(name){if([CHI.MUI,CHI.THAN,KHON_THO[0]].includes(name))return KHON_THO;if([CHI.TI,CHI.THIN,TON_MOC[0]].includes(name))return TON_MOC;if([CHI.HOI,CHI.TUAT,CAN_KIM[0]].includes(name))return CAN_KIM;if([CHI.SUU,CHI.DAN,CAN_THO[0]].includes(name))return CAN_THO;if([CHI.MAO,CHAN_MOC[0]].includes(name))return CHAN_MOC;if([CHI.NGO,LY_HOA[0]].includes(name))return LY_HOA;if([CHI.DAU,DOAI_KIM[0]].includes(name))return DOAI_KIM;return KHAM_THUY}
  ke_muc(){const lookup=x=>{const i=CLOCK_BAT_QUAI.findIndex(y=>eq(x,y));return i<0?x[1]-1:i};const yearHop={0:CHI.SUU,1:CHI.TY,2:CHI.HOI,3:CHI.TUAT,4:CHI.DAU,5:CHI.THAN,6:CHI.MUI,7:CHI.NGO,8:CHI.TI,9:CHI.THIN,10:CHI.MAO,11:CHI.DAN}[this.yearGanZhi.chi];const [,vx]=this.tim_thien_muc_van_xuong(),ta=this.tim_thai_at();const y= this.mapChiCan(DIA_CHI[this.yearGanZhi.chi]),yh=this.mapChiCan(yearHop),v=this.mapChiCan(vx[0]),a=this.mapChiCan(ta.cung[0]);const yi=lookup(y),vyi0=lookup(yh);let gia=0,vyi=vyi0;while(vyi!==yi){vyi=move(7,vyi,1);gia++}let vi=lookup(v);while(gia-- >0)vi=move(7,vi,1);const ai=lookup(a);let num=0;while(vi!==ai){num+=CLOCK_BAT_QUAI[vi][1];vi=move(7,vi,1)}let k=num;while(k>10)k-=10;let tham=k*3;while(tham>10)tham-=10;const idx=BAT_QUAI.findIndex(x=>x[1]===tham);return [num,BAT_QUAI[idx<0?0:idx]]}
  tim_chu_khach(){
    const map=[[[CAN_KIM[0],CHI.HOI],1],[[KHAM_THUY[0],CHI.TY],8],[[CHI.SUU,CHI.SUU],0],[[CAN_THO[0],CHI.DAN],3],[[CHAN_MOC[0],CHI.MAO],4],[[CHI.THIN,CHI.THIN],0],[[TON_MOC[0],CHI.TI],9],[[LY_HOA[0],CHI.NGO],2],[[CHI.MUI,CHI.MUI],0],[[KHON_THO[0],CHI.THAN],7],[[DOAI_KIM[0],CHI.DAU],6],[[CHI.TUAT,CHI.TUAT],0]];
    const [,vx]=this.tim_thien_muc_van_xuong(),[,tk]=this.tim_khach_muc_thuy_kich(),ta=this.tim_thai_at();
    const getVal=name=>{const b=BAT_QUAI.find(x=>x[0]===name);if(b)return b[1];const row=map.find(x=>x[0][0]===name||x[0][1]===name);if(!row)throw Error('Cung không tồn tại: '+name);const indirect=[CHI.DAN,CHI.THAN,CHI.TI,CHI.HOI,CHI.THIN,CHI.TUAT,CHI.SUU,CHI.MUI];return indirect.includes(name)?1:row[1]};
    const find=name=>{const value=getVal(name),row=map.findIndex(x=>x[0][0]===name||x[0][1]===name);return [name,row,value]};
    const [taName,taPos]=find(ta.cung[0]),before=move(11,taPos,-1),trace=[];
    const checkThaiAt=(name,pos)=>{
      if(pos!==taPos) return false;
      if(name===taName) return true;
      const excluded=[CHI.HOI,CHI.DAN,CHI.THAN,CHI.TI];
      return !excluded.includes(name);
    };
    const walk=(start,label)=>{
      let [name,pos,val]=find(start),sum=val;
      const entry={label,start,steps:[{cung:map[pos][0],value:val}]};trace.push(entry);
      if(checkThaiAt(name,pos)||pos===before)return sum;
      while(pos!==before){pos=move(11,pos,1);sum+=map[pos][1];entry.steps.push({cung:map[pos][0],value:map[pos][1]})}
      return sum
    };
    const chu=walk(vx[0],'Chủ - Văn Xương'),khach=walk(tk[0],'Khách - Thủy Kích');return {trace,values:[chu,khach]}
  }
  tim_dai_tuong(){const [chu,khach]=this.tim_chu_khach().values;const d=n=>n%10===0?n/10:n%10,t=n=>(n*3)%10===0?1:(n*3)%10;return [['C.Đại Tướng',BAT_QUAI[d(chu)-1]],['C.Tham Tướng',BAT_QUAI[t(d(chu))-1]],['K.Đại Tướng',BAT_QUAI[d(khach)-1]],['K.Tham Tướng',BAT_QUAI[t(d(khach))-1]]]}
  tim_chu_khach_1(){const [,vx]=this.tim_thien_muc_van_xuong(),[,tk]=this.tim_khach_muc_thuy_kich(),ta=this.tim_thai_at().cung;const ti=findIndex(CLOCK_BAT_QUAI,x=>x[0]===ta[0]);const before=move(7,ti,-1);const val=name=>{const i=CLOCK_BAT_QUAI.findIndex(x=>x[0]===name);if(i>=0)return [i,CLOCK_BAT_QUAI[i][1]];const c=this.mapChiCan(name),ci=findIndex(CLOCK_BAT_QUAI,x=>x[0]===c[0]);const indirect=[CHI.DAN,CHI.THAN,CHI.TI,CHI.HOI,CHI.THIN,CHI.TUAT,CHI.SUU,CHI.MUI];return [ci,indirect.includes(name)?1:c[1]]};
    const calc=name=>{
      let [i,v]=val(name);
      if(i===ti) return v;   // ← cùng cung với Thái Ất → Tù, trả về giá trị gốc
      let s=v;
      while(i!==before){i=move(7,i,1);s+=CLOCK_BAT_QUAI[i][1]}
      return s
    };return [calc(vx[0]),calc(tk[0])]}

  buildState(){
    const thai=this.tim_thai_at(),[,ke]=this.tim_ke_than();
    const cuc=this.tinh_cuc(),ky=this.tim_ky_nguyen_giap_ty(),vx=this.tim_thien_muc_van_xuong(),tk=this.tim_khach_muc_thuy_kich(),ck=this.tim_chu_khach(),bm=this.bat_mon(),dt=this.tim_dai_tuong(),dd=this.dai_du_thai_at(),td=this.tieu_du_thai_at(),km=this.ke_muc();
    return {thaiAt:thai,keThan:ke,cuc,kyNguyen:ky,vanXuong:vx,thuyKich:tk,chuKhach:ck.values,bm, daiTuong:dt,daiDu:dd,tieuDu:td,keMuc:km,lunar:this.getAmLich(),gz:this.getGZAmLich(),solar:this.getDuongLich(),solarTerm:this.getSolarTerm(),keType:this.getKeType()}
  }
}

export class ThaiAtGianDiLuc{
  constructor(t){this.t=t}
  infoDaiDu(){const [[chu,n],c]=this.t.dai_du_thai_at();return `${chu}, Đại Du=${n}, cung ${c[0]}(${c[1]})`}
  infoChuDaiTuong(){return 'page 67 — skeleton; tiếp tục implement theo tài liệu gốc.'}
  infoThuyKich(){return 'skeleton — chưa hoàn thiện trong source gốc.'}
  infoCoDonAmDuong(){return ''}
  infoVanXuong(){return 'Các rule Văn Xương được giữ làm extension point.'}
}

export function calculateThaiAt({year,month,day,hour,minute,keType}){const t=new ThaiAt(year);if(keType==='month')t.set_month(month);else if(keType==='day')t.set_day(day);else if(keType==='hour')t.set_hour(hour,minute);const state=t.buildState();const viewer=new BatQuaiViewer(t);return {t,state,viewer:viewer.output(),trace:buildDebug(t,state)}}

export class BatQuaiViewer{
  constructor(t){this.t=t;this.map=new Map();this.maxRow=1;this.init()}
  push(key,value){const a=this.map.get(key)||[];a.push(value);this.map.set(key,a);this.maxRow=Math.max(this.maxRow,a.length-1)}
  init(){const [,term]=this.t.getSolarTerm();const tietKhi=term?.[0]||'';for(const q of BAT_QUAI){this.push(q[0],`${q[0]}(${q[1]})`);if(q[1]!==5){const [idx]=this.t.getSolarTerm();this.push(q[0],`[Tiết ${idx}]`);this.push(q[0],`[${Solar24.batQuaiState(q[0],tietKhi)}]`)}}}
  calc(){const t=this.t,s=t.buildState();const pushC=(c,v)=>this.push(t.mapChiCan(c[0])[0],v);this.push('Trung',`Năm: ${s.cuc[2]}`);this.push('Trung',t.getYear());this.push('Trung',`Chủ: ${s.chuKhach[0]} - Khách: ${s.chuKhach[1]}`);this.push('Trung','');this.push('Trung',`Cục: ${s.cuc[0]} | ${s.cuc[1]}`);this.push('Trung',`Nguyên: ${s.kyNguyen[0]}`);pushC(s.thaiAt.cung,'Thái Ất');pushC(s.keThan,'Kế Thần');pushC(s.vanXuong[1],'Văn Xương');pushC(s.thuyKich[1],'Thủy Kích');pushC(s.daiDu[1],'Đại Du');pushC(s.tieuDu,'Tiểu Du');pushC(s.keMuc[1],'K.Kế Mục');for(const x of s.daiTuong)pushC(x[1],x[0]);for(const x of s.bm[1])pushC(x[1],x[0]);return s}
  output(){const s=this.calc();const palaces=BAT_QUAI.map(q=>({id:q[1],name:q[0],rows:this.map.get(q[0])||[]}));return {layout:[[9,2,7],[4,5,6],[3,8,1]],maxRow:Math.max(9,this.maxRow),palaces,state:s}}
}

function buildDebug(t,s){const info=[];const add=(k,v)=>info.push({key:k,value:v});add('Kiểu kế',s.keType);add('Dương lịch',s.solar);add('Âm lịch',s.lunar);add('Can Chi',s.gz);add('Tiết khí',s.solarTerm);add('Tích niên',t.tich_nien());add('Tuế kế',t.tue_ke());add('Thái Ất',s.thaiAt);add('Kỷ nguyên Giáp Tý',s.kyNguyen);add('Cục',s.cuc);add('Kế Thần',s.keThan);add('Thiên Mục/Văn Xương',s.vanXuong);add('Khách Mục/Thủy Kích',s.thuyKich);add('Bát Môn',s.bm);add('Chủ - Khách',s.chuKhach);add('Đại Tướng',s.daiTuong);add('Đại Du',s.daiDu);add('Tiểu Du',s.tieuDu);add('Kế Mục',s.keMuc);return info}
