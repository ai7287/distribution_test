// frontend/src/UploadForm.js
import React, { useState } from 'react';
import axios from 'axios';

const UploadForm = () => {
  const [file, setFile] = useState(null);

  const handleFileChange = (e) => {
    setFile(e.target.files[0]);
  };

  const handleUpload = async () => {
    if (!file) return alert('파일을 선택하세요.');

    const formData = new FormData();
    formData.append('file', file);

    try {
      //await axios.post(
      // 'https://your-railway-app.up.railway.app/upload', // Railway 주소
      // formData,
      //{ headers: { 'Content-Type': 'multipart/form-data' } }
      // );
      alert('업로드 완료!');
    } catch (err) {
      console.error(err);
      alert('업로드 실패');
    }
  };

  return (
    <div>
      <input type="file" accept="video/mp4" onChange={handleFileChange} />
      <button onClick={handleUpload}>업로드</button>
    </div>
  );
};

export default UploadForm;
