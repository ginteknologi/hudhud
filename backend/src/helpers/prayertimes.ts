// Mathematical calculation for Islamic Prayer Times (Kemenag standard: Subuh 20 deg, Isya 18 deg)
// Zero external dependency, compatible with Edge Cloudflare Workers

export interface PrayerTimes {
  imsak: string;
  fajr: string;
  dhuhr: string;
  asr: string;
  maghrib: string;
  isha: string;
  sunset: string;
}

export function calculatePrayerTimes(
  date: Date,
  lat: number = -6.382812,
  lng: number = 106.923023,
  timeZone: number = 7
): PrayerTimes {
  // Julian Day
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();

  const a = Math.floor((14 - month) / 12);
  const y = year + 4800 - a;
  const m = month + 12 * a - 3;
  const jd =
    day +
    Math.floor((153 * m + 2) / 5) +
    365 * y +
    Math.floor(y / 4) -
    Math.floor(y / 100) +
    Math.floor(y / 400) -
    32045;

  const d = jd - 2451545.0;

  // Sun coordinates
  const g = (357.529 + 0.98560028 * d) % 360;
  const q = (280.459 + 0.98564736 * d) % 360;
  const L = (q + 1.915 * sinD(g) + 0.02 * sinD(2 * g)) % 360;
  const e = 23.439 - 0.00000036 * d;

  const RA = atan2D(cosD(e) * sinD(L), cosD(L)) / 15;
  const delta = asinD(sinD(e) * sinD(L)); // Sun declination

  // Equation of Time (EoT)
  const EqT = q / 15 - fixHour(RA);

  // Dzuhur / Midday
  const noon = fixHour(12 + timeZone - lng / 15 - EqT);

  // Fajr (Subuh angle: -20 deg), Imsak (-22 deg)
  const fajrHour = noon - hourAngle(-20, lat, delta);
  const imsakHour = fajrHour - 10 / 60; // 10 minutes before Subuh

  // Asr (Shafi'i: shadow length = 1 + shadow at noon)
  const asrAlt = -atanD(1 + tanD(Math.abs(lat - delta)));
  const asrHour = noon + hourAngle(asrAlt, lat, delta);

  // Maghrib / Sunset (-0.833 deg with atmospheric refraction)
  const sunsetHour = noon + hourAngle(-0.833, lat, delta);

  // Isha (-18 deg)
  const ishaHour = noon + hourAngle(-18, lat, delta);

  return {
    imsak: formatTime(imsakHour),
    fajr: formatTime(fajrHour),
    dhuhr: formatTime(noon),
    asr: formatTime(asrHour),
    sunset: formatTime(sunsetHour),
    maghrib: formatTime(sunsetHour),
    isha: formatTime(ishaHour),
  };
}

function hourAngle(alpha: number, lat: number, delta: number): number {
  const cosHA = (sinD(alpha) - sinD(lat) * sinD(delta)) / (cosD(lat) * cosD(delta));
  if (cosHA > 1) return 0;
  if (cosHA < -1) return 12;
  return acosD(cosHA) / 15;
}

function fixHour(hour: number): number {
  hour = hour % 24;
  return hour < 0 ? hour + 24 : hour;
}

function formatTime(hour: number): string {
  const h = Math.floor(fixHour(hour));
  const m = Math.floor((fixHour(hour) - h) * 60);
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`;
}

function sinD(deg: number): number {
  return Math.sin((deg * Math.PI) / 180);
}
function cosD(deg: number): number {
  return Math.cos((deg * Math.PI) / 180);
}
function tanD(deg: number): number {
  return Math.tan((deg * Math.PI) / 180);
}
function asinD(x: number): number {
  return (Math.asin(x) * 180) / Math.PI;
}
function acosD(x: number): number {
  return (Math.acos(x) * 180) / Math.PI;
}
function atanD(x: number): number {
  return (Math.atan(x) * 180) / Math.PI;
}
function atan2D(y: number, x: number): number {
  return (Math.atan2(y, x) * 180) / Math.PI;
}
