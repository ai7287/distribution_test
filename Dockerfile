# ============ STEP 1: React 앱 빌드 ============
FROM node:20 as frontend-builder

WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend/ .
RUN npm run build


# ============ STEP 2: Flask 서버 환경 ============
FROM python:3.10-slim

# 작업 디렉토리
WORKDIR /app

# Python 패키지 설치
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Flask 서버 코드 복사
COPY backend/ .

# React 빌드 결과 복사 → Flask에서 static 폴더로 서빙
COPY --from=frontend-builder /app/frontend/build ./frontend/build

# Railway에서 사용하는 포트 (자동으로 ENV["PORT"] 전달됨)
EXPOSE 8080

# Flask 실행
CMD ["python", "app.py"]
