FROM docker.io/node:16-slim

RUN apt-get update
RUN apt-get install -y git make g++ python3 gnupg2
RUN ln -sv /usr/local/bin/node /bin/node
RUN npm i -g pnpm

ARG API_HASH=none
RUN git clone https://github.com/talentmaker/api.git /tmp/talentmaker-api

WORKDIR /tmp/talentmaker-api

RUN pnpm install --ignore-scripts
RUN pnpm build:prod

RUN mv /tmp/talentmaker-api/build /api

WORKDIR /api

RUN pnpm install --prod --no-optional

COPY encryption-key.txt .

RUN echo $(cat encryption-key.txt) | gpg --batch --yes --passphrase-fd 0 --output ./.env --decrypt ./.env.gpg

CMD ["index.js"]
