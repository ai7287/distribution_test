# ------------------------------
# 1단계: React 앱 빌드
# ------------------------------
FROM node:20 as frontend

WORKDIR /app/frontend

COPY frontend/ .

RUN npm install && npm run build


# ------------------------------
# 2단계: Flask 백엔드 + React 정적파일 통합
# ------------------------------
FROM python:3.10-slim

WORKDIR /app

# requirements.txt 복사 및 설치
COPY backend/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Flask 코드 복사
COPY backend/ .

# React build 결과 복사 → Flask에서 static 폴더로 사용
COPY --from=frontend /app/frontend/build ./frontend/build

# 포트 노출 (Railway 기준)
EXPOSE 8080

# Flask 실행
CMD ["python", "app.py"]
