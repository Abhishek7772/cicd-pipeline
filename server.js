// server.js — Main Application Entry Point
// Author: Abhishek Parmar
// Project: Cloud-Based Automated CI/CD Pipeline

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// ── Health Check Endpoint ─────────────────────────────
// Used by CI/CD pipeline after every deployment
// Returns HTTP 200 if application is running correctly
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    version: process.env.GIT_COMMIT || 'local',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// ── API Routes ────────────────────────────────────────
app.get('/api/users', (req, res) => {
  res.status(200).json({
    users: [],
    message: 'Users fetched successfully'
  });
});

app.post('/api/users', (req, res) => {
  const { name, email } = req.body;
  if (!name || !email) {
    return res.status(400).json({ error: 'Name and email are required' });
  }
  res.status(201).json({
    message: 'User created successfully',
    data: { name, email }
  });
});

app.get('/api/status', (req, res) => {
  res.status(200).json({
    status: 'running',
    environment: process.env.NODE_ENV || 'production'
  });
});

// ── 404 Handler ───────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// ── Start Server ──────────────────────────────────────
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});

module.exports = app;
