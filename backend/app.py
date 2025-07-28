from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
import traceback
from werkzeug.utils import secure_filename
from datetime import datetime
import uuid

app = Flask(__name__, static_folder="../frontend/build", static_url_path="/")
CORS(app)

# ✅ 최대 업로드 허용 크기 설정 (예: 100MB)
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1024  # 100MB

# 업로드 루트 디렉토리
BACKEND_UPLOAD_DIR = os.path.join("/tmp", "uploads")
os.makedirs(BACKEND_UPLOAD_DIR, exist_ok=True)

@app.route('/api/upload', methods=['POST'])
def upload_file():
    try:
        file = request.files.get('file')
        room_type = request.form.get('roomType', 'room')
        session_id = request.form.get('sessionId')

        if not file:
            return jsonify(success=False, error='파일이 없습니다.'), 400

        if not session_id:
            date_str = datetime.now().strftime('%Y%m%d')
            session_id = f"session_{date_str}_{uuid.uuid4().hex[:6]}"

        print(f"[INFO] 사용 중인 session_id: {session_id}")

        # 저장할 폴더 생성
        room_dir = os.path.join(BACKEND_UPLOAD_DIR, session_id, room_type)
        os.makedirs(room_dir, exist_ok=True)

        # 파일 저장
        filename = secure_filename(file.filename)
        video_path = os.path.join(room_dir, filename)
        file.save(video_path)
        print(f"[UPLOAD] 저장된 비디오: {video_path}")

        # 예시 파일 복사
        example_src_path = os.path.join(os.path.dirname(__file__), "examples", "example.txt")
        example_dst_path = os.path.join(room_dir, "example.txt")
        if os.path.exists(example_src_path):
            with open(example_src_path, "rb") as src, open(example_dst_path, "wb") as dst:
                dst.write(src.read())
            print(f"[COPY] 예시 파일 저장됨: {example_dst_path}")
        else:
            print("[WARNING] 예시 파일이 존재하지 않음:", example_src_path)

        return jsonify(
            success=True,
            message="업로드 완료",
            session_id=session_id,
            filename=filename,
            room=room_type,
            path=os.path.relpath(video_path, BACKEND_UPLOAD_DIR),
        )

    except Exception as e:
        traceback.print_exc()
        return jsonify(success=False, error='예외 발생', message=str(e)), 500

@app.route('/uploads/<path:filename>')
def serve_file(filename):
    return send_from_directory(BACKEND_UPLOAD_DIR, filename)

# React SPA 대응
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve_react(path):
    full_path = os.path.join(app.static_folder, path)
    if path != "" and os.path.exists(full_path):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, "index.html")

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5050))
    app.run(host='0.0.0.0', port=port)
