# 루트의 Dockerfile (React + Flask 통합)
FROM node:18 AS frontend

# React build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Flask 서버
FROM python:3.11-slim AS backend

WORKDIR /app
COPY backend/requirements.txt .
RUN pip install -r requirements.txt

# backend 코드 복사
COPY backend/ .

# React 빌드된 파일 정적 폴더로 복사
COPY --from=frontend /app/frontend/build ./static

CMD ["python", "app.py"]
