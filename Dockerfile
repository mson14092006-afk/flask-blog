FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
# Giảm kích thước của image bằng cách sử dụng --no-cache-dir để không lưu cache của pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Tạo một user không có quyền root để chạy ứng dụng, giúp tăng cường bảo mật
RUN adduser --disabled-password --gecos '' appuser && \
    chown -R appuser:appuser /app
# Chuyển sang quyền user
USER appuser

EXPOSE 5000

ENV FLASK_ENV=production

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--timeout", "60", "run:app"]
