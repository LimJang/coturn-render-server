FROM coturn/coturn:latest

# 필요한 패키지 설치 (wget 포함)
USER root
RUN apk add --no-cache wget curl

# CoTURN 설정 파일 생성
RUN echo "listening-port=\$PORT" > /tmp/turnserver.conf && \
    echo "min-port=49152" >> /tmp/turnserver.conf && \
    echo "max-port=65535" >> /tmp/turnserver.conf && \
    echo "lt-cred-mech" >> /tmp/turnserver.conf && \
    echo "user=render:RenderP2P123!" >> /tmp/turnserver.conf && \
    echo "user=student:FastConnect456!" >> /tmp/turnserver.conf && \
    echo "realm=render.webrtc" >> /tmp/turnserver.conf && \
    echo "verbose" >> /tmp/turnserver.conf && \
    echo "fingerprint" >> /tmp/turnserver.conf

# CoTURN 서버 실행 (권한 문제 해결)
CMD ["sh", "-c", "EXTERNAL_IP=$(wget -qO- http://ifconfig.me 2>/dev/null || curl -s http://ifconfig.me || echo '0.0.0.0') && turnserver -c /tmp/turnserver.conf --external-ip=$EXTERNAL_IP"]
