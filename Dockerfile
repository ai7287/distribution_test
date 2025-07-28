# 루트의 Dockerfile (React + Flask 통합)
FROM node:18 AS frontend

# React build
cd frontend
npm install
npm run build
# Flask 서버
FROM python:3.11-slim AS backend
cd backend
pip install -r requirements.txt

CMD ["python", "app.py"]
