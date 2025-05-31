FROM coturn/coturn:latest

# Render 최적화 설정
EXPOSE $PORT

# CoTURN 설정 파일 생성
RUN echo "listening-port=\$PORT" > /etc/turnserver.conf && \
    echo "min-port=49152" >> /etc/turnserver.conf && \
    echo "max-port=65535" >> /etc/turnserver.conf && \
    echo "lt-cred-mech" >> /etc/turnserver.conf && \
    echo "user=render:RenderP2P123!" >> /etc/turnserver.conf && \
    echo "user=student:FastConnect456!" >> /etc/turnserver.conf && \
    echo "realm=render.webrtc" >> /etc/turnserver.conf && \
    echo "verbose" >> /etc/turnserver.conf && \
    echo "fingerprint" >> /etc/turnserver.conf

# HTTP Health Check 스크립트 (Render Sleep 방지)
RUN echo '#!/bin/sh' > /health.sh && \
    echo 'while true; do' >> /health.sh && \
    echo '  echo "HTTP/1.1 200 OK\r\nContent-Length: 12\r\n\r\nTURN Server" | nc -l $PORT &' >> /health.sh && \
    echo '  sleep 300' >> /health.sh && \
    echo 'done' >> /health.sh && \
    chmod +x /health.sh

# CoTURN 시작 명령어
CMD ["sh", "-c", "turnserver -c /etc/turnserver.conf --external-ip=$(wget -qO- http://ifconfig.me) & /health.sh"]