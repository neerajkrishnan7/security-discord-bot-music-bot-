# Multi-Stage Dockerfile for SPOOFY Complete Website & Bot Suite

# Stage 1: Build Frontend Dashboard
FROM node:20-alpine AS dashboard-builder
WORKDIR /app/dashboard
COPY dashboard/package*.json ./
RUN npm ci
COPY dashboard/ ./
RUN npm run build

# Stage 2: Production Server & Discord Bot
FROM node:20-alpine AS production
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache python3 make g++ gcc libc-dev

# Install root dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source code, prisma schema, and built dashboard
COPY prisma ./prisma
COPY src ./src
COPY assets ./assets
COPY --from=dashboard-builder /app/dashboard/dist ./dashboard/dist

# Expose Web & WebSocket Port
EXPOSE 4000

ENV NODE_ENV=production
ENV PORT=4000

# Start SPOOFY Unified Server (Bot + Dashboard API + Public Web)
CMD ["node", "src/index.js"]
