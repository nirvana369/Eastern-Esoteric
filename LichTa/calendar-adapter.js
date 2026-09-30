// import { LichTa } from 'https://esm.sh/@lichta/core';
import { LichTa } from './lichta-core.mjs';
import { findSolarTerm } from '../thai-at/solar24.js';
import { newGZTime } from '../thai-at/types.js';

// CalendarAdapter is deliberately limited to calendar conversion.
// Can-Chi is calculated by Solar24 using the formulas ported from solar24.mo.
export class CalendarAdapter {
  static fromDateTime(dt) {
    const lunar = LichTa.toLunar(dt.day, dt.month, dt.year, 7);
    return {
      dt,
      lunar,
      // LichTa's JD is the day-based JDN used by its Can-Chi helpers.
      // Keep it available to higher layers, but do not parse Can-Chi strings here.
      jd: lunar.jd,
      solarTerm: findSolarTerm(dt)
    };
  }

  static lunarText(x) {
    return `${x.day}/${x.month}/${x.year}${x.isLeap ? ' (nhuận)' : ''}`;
  }
}

export function solarToLunar(d, m, y) {
  return CalendarAdapter.fromDateTime({ day: d, month: m, year: y, hour: 12, minute: 0 }).lunar;
}

// Kept for compatibility with existing ThaiAt code. The actual calculation is
// delegated to Solar24 in the new architecture.
export function canChiDate(d, m, y, h, min) {
  return null;
}

export function formatLunar(d, m, y) {
  return CalendarAdapter.lunarText(solarToLunar(d, m, y));
}
