FROM coturn/coturn:latest

# CoTURN 설정 파일 생성 (/tmp 경로 사용)
RUN echo "listening-port=\$PORT" > /tmp/turnserver.conf && \
    echo "min-port=49152" >> /tmp/turnserver.conf && \
    echo "max-port=65535" >> /tmp/turnserver.conf && \
    echo "lt-cred-mech" >> /tmp/turnserver.conf && \
    echo "user=render:RenderP2P123!" >> /tmp/turnserver.conf && \
    echo "user=student:FastConnect456!" >> /tmp/turnserver.conf && \
    echo "realm=render.webrtc" >> /tmp/turnserver.conf && \
    echo "verbose" >> /tmp/turnserver.conf && \
    echo "fingerprint" >> /tmp/turnserver.conf

# CoTURN 서버만 실행 (Health Check 제거)
CMD ["sh", "-c", "turnserver -c /tmp/turnserver.conf --external-ip=$(wget -qO- http://ifconfig.me || echo '0.0.0.0')"]
