# ANTIGRAVITY-STARTER v1.1 — Tech Stack Audit

> **Šaltinis:** MiniRecall_8.0, ekotora, APS, LB24, RR, SERM, samata.ai projektų analizė
> **Data:** 2026–07–26

---

## 1. Projekto Audito Santrauka

Iš viso išanalizuota **10+ projektų** `antigravity/` kataloge. Pagrindiniai projektai:

| Projektas | Tipas | Pagrindinis stack'as |
|-----------|-------|---------------------|
| **MiniRecall_8.0** | Facebook automatizavimas | Python, DrissionPage, MySQL, Google Sheets, OpenAI |
| **ekotora** | SaaS Web aplikacija | Next.js 15, React 19, TanStack Query, Tailwind, MySQL |
| **APS** | Nekilnojamojo turto sistema | PHP, Python (analizė) |
| **LB24** | Elektroninė prekyba | Python, scraperiai |
| **RR** | Web projektas | JavaScript, ESLint |
| **SERM** | Scraping sistema | Python, strateginiai dokumentai |
| **samata.ai** | AI projektas | Python, AI/LLM |

---

## 2. Stack'o Komponentai

### 2.1 Frontend (Vienintelis standartas — Next.js)

| Komponentas | Naudojama | Pastabos |
|-------------|-----------|----------|
| **Framework** | Next.js 14–15 | App Router, SSR/SSG |
| **React** | React 18–19 | Server & Client Components |
| **TypeScript** | ✓ Visada | Strict mode, absolute imports |
| **Styling** | Tailwind CSS | + tailwind-merge, clsx |
| **State/Data** | TanStack Query (React Query) | Server state management |
| **Animation** | Framer Motion | UI transitions |
| **Icons** | Lucide React | Modern icon library |
| **Charts** | Recharts / D3 | Dashboard vizualizacijos |
| **Lint** | ESLint + Prettier | Standard config |
| **Forms** | Native / React Hook Form | + Zod validation |

**Atradimas:** Visi projektuose naudojami UI komponentai yra **custom** (nėra Material UI, Shadcn ar kitų UI bibliotekų). Tai rodo polinkį į minimalius, ranka rašytus komponentus.

### 2.2 Backend (Du standartai)

#### Pagrindinis: Python

| Komponentas | Naudojama | Pastabos |
|-------------|-----------|----------|
| **Language** | Python 3.10+ | Type hints visada |
| **API** | FastAPI (ekotoroje per Next.js API routes) | Nėra Flask |
| **Scraping** | DrissionPage (rekomenduojama) | + Playwright, Requests |
| **Duomenų apdorojimas** | Pandas | Analizei |
| **Pydantic** | ✓ | Model validacija, settings |

#### Antraeilis: PHP

| Komponentas | Naudojama |
|-------------|-----------|
| **Bridge** | PHP Bridge (tarp Python ir Plesk) |
| **Paskirtis** | Tarpinis serverio valdymas |

### 2.3 Duomenų Bazės

| Tipas | Naudojama | Pastabos |
|-------|-----------|----------|
| **MySQL** | ✓ Pagrindinė | Visuose bot'uose ir SaaS |
| **PostgreSQL** | ✓ | MiniRecall 5.0, naujesni projektai |
| **SQLite** | ✓ | Lokalus darbas, testai |
| **Redis** | ✓ | Cache (docker-compose) |
| **ORM** | SQLAlchemy 2.0+ | Async, Declarative |
| **Migrations** | Alembic | Auto-generate |
| **MySQL Driver** | mysql-connector-python / aiomysql | |
| **PostgreSQL Driver** | asyncpg | Async only |

### 2.4 AI / LLM

| Komponentas | Naudojama |
|-------------|-----------|
| **Pagrindinis provideris** | OpenAI (GPT-4o-mini) |
| **Antraeilis** | Gemini (fallback) |
| **Prieiga** | HTTP REST (`requests.post` → `https://api.openai.com/...`) |
| **Prompt valdymas** | Config failai, prompt cache |

**Atradimas:** AI yra naudojamas dviem būdais:
1. **Generavimui** — turinio/post'ų kūrimas
2. **Analizei** — signal detection, lead scoring

### 2.5 Išorinės Integracijos

| Integracija | Biblioteka | Paskirtis |
|-------------|-----------|-----------|
| **Google Sheets** | gspread, google-api-python-client | Duomenų sinchronizacija |
| **Google OAuth** | google-auth-oauthlib | Autentifikacija |
| **Telegram** | python-telegram-bot / REST | Notification'ai |
| **Facebook** | DrissionPage (scraping) + Graph API | Automatizavimas |
| **LinkedIn** | RapidAPI + custom | Lead generation |
| **RapidAPI** | requests | External data |
| **Apify** | requests | Web scraping |
| **Plesk** | XML-RPC / custom | Hosting management |
| **SSH** | paramiko / fabric | Remote server |

### 2.6 Deployment

| Komponentas | Naudojama | Pastabos |
|-------------|-----------|----------|
| **Serveris** | Plesk / VPS | Nuosavas hostingas |
| **CI/CD** | Nėra standartinio | Rankinis deploymentas |
| **Docker** | Planuojama | docker-compose paruoštas |
| **Task Runner** | Windows Scheduler / .bat | Background procesai |
| **Monitoring** | Telegram bot'ai | Klaidų pranešimai |

---

## 3. Pasikartojantys Modeliai

### 3.1 Architektūros Modeliai

```
projektas/
├── bots/                  ← Automatizavimo moduliai
│   ├── facebook/          ← Specifiniai bot'ai
│   └── linkedin/          ←
├── src/                   ← Pagrindinis kodas
│   ├── scraper/           ← Duomenų rinkimas
│   ├── poster/            ← Turinio publikavimas
│   ├── analyzer/          ← Analizė ir signalai
│   └── utils/             ← Bendra logika
│       ├── config.py      ← Konfigūracija
│       ├── database.py    ← DB jungtis
│       ├── logger.py      ← Loginimas
│       └── notifier.py    ← Pranešimai
├── .env                   ← Aplinkos kintamieji
└── run_*.bat/sh           ← Paleidimo skriptai
```

### 3.2 Dažniausiai naudojamos Python bibliotekos

```text
# ESSENTIAL (visada)
pydantic>=2.0.0           # Validacija, settings
python-dotenv>=1.0.0      # .env loading
httpx>=0.27.0              # HTTP client (async)
requests>=2.31.0           # HTTP client (sync)

# DATABASE (dažniausiai)
sqlalchemy[asyncio]>=2.0   # ORM
asyncpg>=0.29.0            # PostgreSQL
mysql-connector-python>=8.0 # MySQL
alembic>=1.13.0            # Migrations

# SCRAPING (bot'ams)
DrissionPage>=4.0          # Browser automation
playwright>=1.40           # (alternative)
beautifulsoup4>=4.12       # HTML parsing
lxml>=5.2.0                # XML/HTML

# AI/LLM
openai>=1.30.0             # OpenAI API
google-generativeai>=0.8   # Gemini API

# INTEGRATIONS
gspread>=6.1.0             # Google Sheets
google-api-python-client>=2.130
google-auth-oauthlib>=1.2
python-telegram-bot>=20.0

# UTILS
pandas>=2.0.0              # Data analysis
rich>=13.7.0               # Terminal UI
```

### 3.3 Dažniausiai naudojami .env kintamieji

```env
# === Core ===
APP_NAME=
APP_ENV=development
SECRET_KEY=
DEBUG=True

# === Database ===
DATABASE_URL=
MYSQL_HOST=
MYSQL_USER=
MYSQL_PASSWORD=
MYSQL_DATABASE=

# === Auth ===
AUTH_SECRET=
JWT_SECRET=

# === AI ===
OPENAI_API_KEY=
OPENAI_MODEL=gpt-4o-mini
AI_PROVIDER=openai

# === Google ===
GOOGLE_SPREADSHEET_ID=
GOOGLE_SERVICE_ACCOUNT=

# === Telegram ===
TELEGRAM_BOT_TOKEN=
TELEGRAM_CHAT_ID=

# === RapidAPI ===
RAPIDAPI_KEY=

# === SSH / Server ===
SSH_HOST=
SSH_USER=
SSH_PORT=22

# === Plesk ===
PLESK_HOST=
PLESK_API_KEY=
```

### 3.4 Kodavimo Modeliai

**Python modulio šablonas** (randamas visuose bot'uose):
```
src/
├── __init__.py
├── config.py         # Settings klasė
├── database.py       # Session management
├── logger.py         # Structured logging
├── exceptions.py     # Custom errors
├── services.py       # Business logic
└── utils.py          # Helpers
```

**API atsakymo formatas** (ekotoroje):
```json
{
  "success": true|false,
  "data": {},
  "error": null|{},
  "meta": {}
}
```

**AI prompt'o struktūra**:
```python
system_prompt = """Tavo vaidmuo..."""
user_prompt = f"""Sugeneruok..."""
# Fallback: Jei OpenAI klaida → Gemini
```

---

## 4. Specifiniai Atradimai

### 4.1 Kas gerai veikia

- **Modulinė struktūra**: `src/` su `scraper/`, `poster/`, `analyzer/`, `utils/`
- **Config centralizavimas**: Per `config.py` + `.env`
- **Google Sheets sinchronizacija**: Patikrinta SaaS Core
- **Telegram monitoringas**: Veikia kaip error notification sistema
- **DrissionPage**: Stabilus Facebook automatizavimui

### 4.2 Ką galima pagerinti

| Problema | Pasiūlymas |
|----------|-----------|
| Nėra unified logging standarto | Naudoti `structlog` arba `loguru` |
| API keys išsibarstę po kelis .env failus | Vienas centrinis `.env` |
| Nėra CI/CD | GitHub Actions su pytest + lint |
| Docker nenaudojamas aktyviai | Migruoti į Docker Compose |
| Test coverage mažas | Pridėti pytest + pytest-cov |
| Type hints ne visur | Užtikrinti per Ruff/lint |
| Windows .bat scripts (necross-platform) | Pakeisti į `make` arba `bash` |
| Prompt'ai išsibarstę kode | Centralizuoti `prompts/` katalogą |

### 4.3 Stack'o Brandos Lygis

```
Python ecosystem:     ████████░░ 8/10
Next.js/React:        ████████░░ 8/10  (tik ekotoroje)
TypeScript:           ██████░░░░ 6/10
Testing:              ██░░░░░░░░ 2/10
CI/CD:                █░░░░░░░░░ 1/10
Docker:               ██░░░░░░░░ 2/10
Documentation:        ██████░░░░ 6/10
Security:             █████░░░░░ 5/10
```

---

## 5. Rekomendacijos v1.1

### 5.1 Rekomenduojamas Default Stack'as

```
Frontend:   Next.js 15 + TypeScript + Tailwind + TanStack Query
Backend:    Python 3.12 + FastAPI + Pydantic + SQLAlchemy 2.0
Database:   PostgreSQL (primary) + Redis (cache)
AI:         OpenAI + Gemini (fallback)
Testing:    pytest + pytest-asyncio + Jest
CI/CD:      GitHub Actions
Deployment: Docker Compose → VPS/Plesk
```

### 5.2 Rekomenduojamos bibliotekos (pagal realų naudojimą)

```toml
# Python — minimalus set'as
[project]
dependencies = [
    "fastapi>=0.115.0",
    "uvicorn[standard]>=0.30.0",
    "pydantic>=2.7.0",
    "pydantic-settings>=2.4.0",
    "httpx>=0.27.0",
    "python-dotenv>=1.0.0",
    "openai>=1.30.0",
    "sqlalchemy[asyncio]>=2.0.30",
    "asyncpg>=0.29.0",
    "alembic>=1.13.0",
    "gspread>=6.1.0",
    "python-telegram-bot>=20.0",
    "DrissionPage>=4.0",
    "pandas>=2.0.0",
    "rich>=13.7.0",
]
[project.optional-dependencies]
dev = [
    "pytest>=8.2.0",
    "pytest-asyncio>=0.24.0",
    "pytest-cov>=5.0.0",
    "ruff>=0.5.0",
]
```

```json
// Node.js — minimalus set'as
{
  "dependencies": {
    "next": "^15.1.0",
    "react": "^19.0.0",
    "@tanstack/react-query": "^5.62.0",
    "tailwindcss": "^3.4.0",
    "lucide-react": "^0.468.0",
    "framer-motion": "^12.0.0"
  },
  "devDependencies": {
    "typescript": "^5.4.0",
    "eslint": "^8.57.0",
    "prettier": "^3.2.0",
    "jest": "^29.7.0",
    "@testing-library/react": "^15.0.0"
  }
}
```

### 5.3 Rekomenduojami Moduliai v1.1

Pagal realių projektų audítą, šie moduliai yra būtini:

| Modulis | Prioritetas | Kodėl |
|---------|------------|-------|
| **FastAPI + Pydantic** | 🔴 Aukštas | Visuose Python projektuose |
| **Next.js + TypeScript** | 🔴 Aukštas | Visuose web projektuose |
| **SQLAlchemy + asyncpg** | 🔴 Aukštas | DB prieiga visur |
| **Google Sheets** | 🟡 Vidutinis | Sinchronizacijai |
| **Telegram Notifications** | 🟡 Vidutinis | Monitoringas |
| **OpenAI + Gemini** | 🟡 Vidutinis | AI generavimas |
| **DrissionPage** | 🟢 Žemas | Tik bot'ams |
| **Docker Compose** | 🟢 Žemas | Naujuose projektuose |

---

## 6. Išvados

1. **Python yra dominuojanti back-end kalba** — visi bot'ai, scraperiai ir analizės įrankiai
2. **Next.js yra vienintelis front-end standartas** — nėra alternatyvų tarp projektų
3. **MySQL dominuoja, bet PostgreSQL yra ateitis** — naujesniuose projektuose PostgreSQL
4. **AI naudojamas visur** — nuo turinio generavimo iki signal detection
5. **Google Sheets yra de facto duomenų mainų formatas** — tarp Python bot'ų ir žmogaus
6. **CI/CD ir testavimas yra didžiausios spragos** — reikia rimčiausiai stiprinti
7. **DrissionPage > Playwright** — Facebook automatizavimui

### Rekomenduojama veiksmų seka v1.1:

```
1. Pridėti FastAPI modulį su Pydantic settings
2. Pridėti Next.js modulį su TypeScript + Tailwind
3. Pridėti SQLAlchemy + Alembic DB modulį
4. Pridėti Google Sheets integracijos modulį
5. Pridėti Telegram notification modulį
6. Pridėti OpenAI klientą su Gemini fallback
7. Stiprinti CI/CD (GitHub Actions su pytest + lint)
8. Pridėti Docker Compose šabloną
```

---

*Audítą atliko: Freebuff AI Agent (Buffy)*
*Šaltiniai: MiniRecall_8.0, ekotora, APS, LB24, RR, SERM, samata.ai*
