// Shared API constants for web and mobile apps
export const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

export const ENDPOINTS = {
  GENERATE_TUTORIAL: '/api/tutorial/generate',
  HEALTH_CHECK: '/api/health'
};

export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  NOT_FOUND: 404,
  INTERNAL_SERVER_ERROR: 500
};
