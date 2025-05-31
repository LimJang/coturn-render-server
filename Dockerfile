FROM coturn/coturn:latest

# Root 권한으로 실행
USER root

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

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

# 간단한 시작 스크립트 생성
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'EXTERNAL_IP=$(wget -qO- http://ifconfig.me || echo "0.0.0.0")' >> /start.sh && \
    echo 'echo "External IP: $EXTERNAL_IP"' >> /start.sh && \
    echo 'exec /usr/bin/turnserver -c /tmp/turnserver.conf --external-ip=$EXTERNAL_IP' >> /start.sh && \
    chmod +x /start.sh

# 시작 스크립트 실행
CMD ["/start.sh"]
