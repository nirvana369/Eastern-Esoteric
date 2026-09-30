import {LAYOUT} from '../thai-at/types.js';

export class BatQuaiDrawer {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.options = options;
    this.currentData = null;
    this.dpr = window.devicePixelRatio || 1;
    this._onResize = () => { if (this.currentData) this.render(this.currentData); };
    window.addEventListener('resize', this._onResize);
  }

  destroy() {
    window.removeEventListener('resize', this._onResize);
  }

  resize() {
    const r = this.canvas.getBoundingClientRect();
    this.canvas.width = Math.max(1, Math.floor(r.width * this.dpr));
    this.canvas.height = Math.max(1, Math.floor(r.height * this.dpr));
    this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
    return { w: r.width, h: r.height };
  }

  render(data) {
    if (!data) return;
    this.currentData = data;
    const { w, h } = this.resize();
    const ctx = this.ctx;
    ctx.clearRect(0, 0, w, h);

    const pad = 18;
    const gap = 8;
    const cw = (w - pad * 2 - gap * 2) / 3;
    const ch = (h - pad * 2 - gap * 2) / 3;
    const palette = {
      bg: '#10141c', border: '#596175', text: '#e8eaf0',
      muted: '#858da0', accent: '#d9b56d', center: '#202635'
    };

    ctx.fillStyle = palette.bg;
    ctx.fillRect(0, 0, w, h);

    const palaces = Array.isArray(data.palaces) ? data.palaces : [];
    const byId = new Map(palaces.map(p => [p.id, p]));

    for (let r = 0; r < 3; r++) {
      for (let c = 0; c < 3; c++) {
        const id = LAYOUT[r][c];
        const palace = byId.get(id);
        const x = pad + c * (cw + gap);
        const y = pad + r * (ch + gap);
        this.drawCell(ctx, x, y, cw, ch, palace, id, palette, data);
      }
    }
  }

  drawCell(ctx, x, y, w, h, palace, id, palette, data) {
    ctx.fillStyle = id === 5 ? palette.center : palette.bg;
    ctx.fillRect(x, y, w, h);
    ctx.strokeStyle = palette.border;
    ctx.lineWidth = 1;
    ctx.strokeRect(x + .5, y + .5, w - 1, h - 1);

    ctx.fillStyle = palette.accent;
    ctx.font = 'bold 15px system-ui';
    ctx.fillText(`${palace?.name || '?'} (${id})`, x + 10, y + 22);

    ctx.fillStyle = palette.muted;
    ctx.font = '11px system-ui';
    ctx.fillText(`Cung ${id}`, x + w - 55, y + 21);

    const rows = Array.isArray(palace?.rows) ? palace.rows : [];
    // maxRow belongs to the viewer/state object. Do not reference an
    // undeclared global variable here; older prototype code did that.
    const requestedMaxRow = Number.isFinite(data?.maxRow) ? data.maxRow : rows.length - 1;
    const max = Math.max(0, Math.min(requestedMaxRow + 1, rows.length));

    let yy = y + 43;
    ctx.font = '12px ui-monospace, Consolas, monospace';
    for (let i = 0; i < max; i++) {
      const text = String(rows[i] ?? '');
      ctx.fillStyle = i === 0 ? palette.text : palette.muted;
      const clipped = this.clip(ctx, text, Math.max(20, w - 20));
      ctx.fillText(clipped, x + 10, yy);
      yy += 16;
      if (yy > y + h - 10) break;
    }
  }

  clip(ctx, s, max) {
    if (ctx.measureText(s).width <= max) return s;
    while (s && ctx.measureText(s + '…').width > max) s = s.slice(0, -1);
    return s + '…';
  }
}
