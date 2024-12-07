# syntax = docker/dockerfile:1
ARG NODE_VERSION=22.6.0
FROM node:${NODE_VERSION}-slim as base
WORKDIR /app
ENV NODE_ENV="production"
ARG PNPM_VERSION=9.12.0
RUN npm install -g pnpm@$PNPM_VERSION

# BUILD
FROM base as build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential node-gyp pkg-config python-is-python3
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod=false
COPY . .
RUN pnpm run build \
    pnpm prune --prod

# RUN
FROM scratch
COPY --from=build /app /app
USER appuser:appuser
EXPOSE 3000
CMD [ "pnpm", "run", "start" ]
