# WIP - source: https://medium.com/@elifront/best-next-js-docker-compose-hot-reload-production-ready-docker-setup-28a9125ba1dc

ARG NODE_VERSION=22.6.0
FROM node:${NODE_VERSION}-slim as base
ENV NODE_ENV="production"
ARG PNPM_VERSION=9.12.0
RUN npm install -g pnpm@$PNPM_VERSION

# DEPS
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# HOT RELOAD
FROM base AS dev
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# BUILD
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
ENV NEXT_TELEMETRY_DISABLED 1
COPY . .
RUN pnpm run build \
    pnpm prune --prod

# RUN
FROM scratch AS runner
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED 1
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

CMD ["node", "server.js"]
