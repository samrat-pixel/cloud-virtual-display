FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    chromium-browser \
    supervisor \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ক্রোম পলিসি ফোল্ডার তৈরি (VPN এক্সটেনশন অটো-ইনস্টল পলিসির জন্য)
RUN mkdir -p /etc/chromium/policies/managed

# VeePN ও Browsec VPN এক্সটেনশন অটো-ইনস্টল পলিসি যোগ করা
RUN echo '{"ExtensionInstallForcelist": ["majdfhpaihoncoakbjgbdhglocklcgno;https://google.com", "omghfjlpggmjjaagoclmmobgdodcjboh;https://google.com"]}' > /etc/chromium/policies/managed/vpn_policy.json

# সরাসরি vnc.html অটো-কানেক্ট সেটআপ
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 10000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
