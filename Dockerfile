# Use Node.js 22-slim image
FROM node:22-slim

RUN apk add --no-cache \
  python3 \
  make \
  g++ \
  gcc \
  && ln -sf python3 /usr/bin/python

# Set working directory
WORKDIR /app

# Copy only package.json and package-lock.json first (for layer caching)
COPY package*.json ./

# Install dependencies with --build-from-source to ensure bcrypt is compiled for the current architecture
RUN npm install --legacy-peer-deps --build-from-source

# Copy the rest of the application
COPY . .

# Build the app (NestJS -> dist/)
RUN npm run build

# Expose the port that the application listens on.
EXPOSE 5000

# Run the application.
CMD ["sh", "-c", "npm run prisma:migrate:migrate && npm run start:prod"]
