import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';
import { calculatePrayerTimes } from '../helpers/prayertimes';

const waktusolat = new Hono<{ Bindings: Env }>();

// GET /api/v1/waktusolat
waktusolat.get('/', async (c) => {
  const lat = parseFloat(c.req.query('latitude') || '-6.3828119512920924');
  const lng = parseFloat(c.req.query('longitude') || '106.92302257543139');
  const today = new Date();
  const times = calculatePrayerTimes(today, lat, lng);
  return apiResponse(c, 200, true, 'Success', times);
});

// GET /api/v1/waktusolat/list
waktusolat.get('/list', async (c) => {
  const lat = parseFloat(c.req.query('latitude') || '-6.3828119512920924');
  const lng = parseFloat(c.req.query('longitude') || '106.92302257543139');
  const now = new Date();
  const times = calculatePrayerTimes(now, lat, lng);

  const currentTimeMinutes = now.getHours() * 60 + now.getMinutes();

  const toMinutes = (timeStr: string) => {
    const [h, m] = timeStr.split(':').map(Number);
    return h * 60 + m;
  };

  const list = [
    { label: 'Imsak', time: times.imsak, status: false },
    { label: 'Subuh', time: times.fajr, status: false },
    { label: 'Dzuhur', time: times.dhuhr, status: false },
    { label: 'Ashar', time: times.asr, status: false },
    { label: 'Maghrib', time: times.maghrib, status: false },
    { label: 'Isa', time: times.isha, status: false },
  ];

  let nextIndex = list.findIndex((item) => toMinutes(item.time) > currentTimeMinutes);
  if (nextIndex === -1) {
    nextIndex = 1; // Default to Subuh tomorrow
  }
  list[nextIndex].status = true;

  return apiResponse(c, 200, true, 'Success', list);
});

// GET /api/v1/waktusolat/kalender
waktusolat.get('/kalender', async (c) => {
  const lat = parseFloat(c.req.query('latitude') || '-6.3828119512920924');
  const lng = parseFloat(c.req.query('longitude') || '106.92302257543139');
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  // Days in month
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const daysName = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
  const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

  const data: string[][] = [];

  for (let i = 1; i <= daysInMonth; i++) {
    const d = new Date(year, month, i);
    const times = calculatePrayerTimes(d, lat, lng);
    const dayStr = String(i).padStart(2, '0') + ' ' + monthNames[month];
    const dayName = daysName[d.getDay()];

    data.push([
      String(i),
      dayStr,
      dayName,
      times.imsak,
      times.sunset,
    ]);
  }

  return apiResponse(c, 200, true, 'Success', data);
});

// GET /api/v1/waktusolat/wp
waktusolat.get('/wp', async (c) => {
  const lat = parseFloat(c.req.query('latitude') || '-6.3828119512920924');
  const lng = parseFloat(c.req.query('longitude') || '106.92302257543139');
  const now = new Date();
  const times = calculatePrayerTimes(now, lat, lng);

  const hariini = now.toLocaleDateString('id-ID', {
    timeZone: 'Asia/Jakarta',
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });

  const hijriyah = now.toLocaleDateString('en-SA-u-ca-islamic-umalqura', {
    timeZone: 'UTC',
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });

  const result = [
    {
      ...times,
      tanggal_hijriyah: hijriyah,
      tanggal_hariini: hariini,
    },
  ];

  return apiResponse(c, 200, true, 'Success', result);
});

export default waktusolat;
