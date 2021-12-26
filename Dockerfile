FROM docker.io/node:16-slim

RUN apt-get update
RUN apt-get install -y chromium

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROME_PATH=/usr/bin/chromium

RUN ln -s /usr/bin/chromium /usr/bin/chromium-browser

WORKDIR /rendertron

COPY rendertron-config.json config.json

RUN npm i rendertron@^3.1.0

ENV PORT=8000
EXPOSE 8000

CMD ["node", "./node_modules/.bin/rendertron"]
