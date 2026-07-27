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
# Set default port for the containerized app
ENV PORT=7909
EXPOSE 7909

# Default command — expects a "start" script in package.json which respects process.env.PORT
CMD ["sh", "-c", "npm run start"]
