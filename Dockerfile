# Python 3.10 slim 이미지 사용
FROM python:3.10-slim

# 작업 디렉토리 설정
WORKDIR /app

# requirements만 먼저 복사 → 캐시 유지를 위해
COPY backend/requirements.txt .

# 라이브러리 설치
RUN pip install --no-cache-dir -r requirements.txt

# 나머지 백엔드 파일 복사
COPY backend/ .

# 8080 포트 사용 (Railway 기준)
EXPOSE 8080

# Flask 실행
CMD ["python", "app.py"]
