import { Context } from 'hono';

export const apiResponse = (
  c: Context,
  statusCode: number = 200,
  success: boolean = true,
  message: string = 'Success',
  data: any = null,
  extra: Record<string, any> = {}
) => {
  return c.json(
    {
      success,
      code: statusCode,
      message,
      data: data !== null ? data : {},
      ...extra,
    },
    statusCode as any
  );
};
