# 1단계: React 빌
FROM node:20 as frontend
WORKDIR /app/frontend
COPY frontend/ .     # 여기에 package.json 반드시 있어야 함
RUN npm install && npm run build

# 2단계: Flask 서버
FROM python:3.10-slim
WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .
COPY --from=frontend /app/frontend/build ./frontend/build

EXPOSE 8080
CMD ["python", "app.py"]
