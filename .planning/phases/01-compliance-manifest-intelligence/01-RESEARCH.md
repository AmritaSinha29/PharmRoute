# Phase 1: Compliance & Manifest Intelligence - Research

**Researched:** 2026-04-11
**Phase:** 01-compliance-manifest-intelligence
**Status:** Research complete

## Research Summary

Pivot to the **Elixir/Phoenix/LiveView** stack. This replaces Python (FastAPI) and React with a fully integrated, fault-tolerant functional system built on the Erlang VM. Extensively leveraged by companies prioritizing extreme scalability and real-time features.

---

## 1. Elixir Backend & GenAI Integration

**Approach:** Connect to Gemini 1.5 Pro REST APIs directly from Elixir.
Since official Google GenAI SDKs for Elixir are lighter, we use HTTP clients (e.g., `req` or `tesla`) to directly hit the `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent` endpoint.

**Payload mapping:**
Elixir Maps -> JSON. Enforce JSON structured output using the `responseMimeType: "application/json"` specification in the request payload.

---

## 2. Real-Time Concurrency (OTP & PubSub)

Instead of Redis queues or Celery, Elixir uses native lightweight processes:
1. User uploads a BMR via LiveView.
2. LiveView spawns an asynchronous `Task` (or uses `Oban` for persistent jobs).
3. The background process parses the document, validates DB rules, and broadcasts progress updates using **Phoenix.PubSub**:
   `Phoenix.PubSub.broadcast(PharmRoute.PubSub, "shipment:{id}", {:progress, "Extracting ingredients...", 50})`
4. The LiveView process receives the message using `handle_info` and updates the Reactivity socket. The DOM updates instantly.

---

## 3. Database Layer (Ecto)

- **PostgreSQL** remains the standard.
- **Ecto** is the data mapper/query library for Elixir.
- Implement schemas for `Substance`, `ComplianceRule`, and `Shipment`.
- Ecto Changesets provide robust structural validation before hitting the database.

---

## 4. Phoenix LiveView Frontend

- No separate frontend codebase `frontend/` vs `backend/`. The entire project resides in standard Phoenix structure.
- **LiveView File Uploads:** Use `<.live_file_input>` to handle drag-and-drop asynchronous chunked uploads directly over WebSockets.
- Use **TailwindCSS** for dark mode professional styling.

### Project Structure (Standard Phoenix)
```
pharm_route/
├── lib/
│   ├── pharm_route/              # Business logic (Contexts, Ecto Schemas)
│   │   ├── compliance/
│   │   ├── manifest/
│   │   └── repo.ex
│   ├── pharm_route_web/          # Web layer (LiveViews, Controllers)
│   │   ├── live/                 # LiveView components
│   │   ├── components/           # Tailwind core components
│   │   └── router.ex
├── priv/
│   └── repo/
│       ├── migrations/
│       └── seeds.exs             # Seed data for WHO substances & Rules
├── mix.exs                       # Dependencies
```
