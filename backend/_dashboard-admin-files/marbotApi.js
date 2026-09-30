// Copy file ini ke: dashboard-admin/src/services/marbotApi.js
// Tambahkan VITE_MARBOT_API_URL ke .env dashboard-admin

import axios from "axios";
import { performTokenRefresh } from "./tokenRefresh";
import { handleApiError } from "@/lib/errorHandler";

const marbotApi = axios.create({
  baseURL: import.meta.env.VITE_MARBOT_API_URL + "/api/v1/cms",
});

marbotApi.interceptors.request.use((config) => {
  const token = localStorage.getItem("admin_token");
  if (token) {
    config.headers = config.headers || {};
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

marbotApi.interceptors.response.use(
  (response) => response.data,
  async (error) => {
    const originalRequest = error.config;

    if (
      error.response?.status === 401 &&
      !originalRequest._retry &&
      localStorage.getItem("admin_refreshToken")
    ) {
      originalRequest._retry = true;
      try {
        const newToken = await performTokenRefresh();
        originalRequest.headers = originalRequest.headers || {};
        originalRequest.headers.Authorization = `Bearer ${newToken}`;
        return marbotApi(originalRequest);
      } catch (refreshError) {
        return Promise.reject(refreshError);
      }
    }

    handleApiError(error);
    return Promise.reject(error);
  },
);

export default marbotApi;
