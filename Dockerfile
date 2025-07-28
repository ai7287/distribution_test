FROM node:18 AS frontend

WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build


# Step 2: Flask backend
FROM python:3.11-slim AS backend

WORKDIR /app

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

# React build 결과를 Flask의 static 폴더로 복사
COPY --from=frontend /app/frontend/build ./static

CMD ["python", "app.py"]
