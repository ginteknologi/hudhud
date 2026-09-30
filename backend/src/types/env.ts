// Bindings interface for Cloudflare Workers Environment
export type Env = {
  DB: D1Database;
  MEDIA_BUCKET?: R2Bucket;
  ENVIRONMENT: string;
  JWT_SECRET: string;
};
