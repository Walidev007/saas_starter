# Use an official Node runtime as a parent image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Install app dependencies
# Copy package.json and lockfile if present
COPY package*.json ./

# Prefer npm ci when a lockfile is present, fallback to npm install
RUN npm ci || npm install

# Bundle app source
COPY . .

# If a build script exists, run it (works for Next/Vite/CRA/etc.)
RUN if [ -f package.json ] && grep -q "\"build\"" package.json; then npm run build; fi || true

ENV NODE_ENV=production
EXPOSE 3000

# Default command — expects a "start" script in package.json
CMD ["sh", "-c", "npm run start"]
