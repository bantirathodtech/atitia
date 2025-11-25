# Atitia Cloud Functions

Cloud Functions for the Atitia PG Management App, including subscription renewal automation.

## Functions

### `checkSubscriptionRenewals`

**Type:** Scheduled Function  
**Schedule:** Daily at 9:00 AM UTC  
**Description:** Automatically checks for expiring subscriptions, sends renewal reminders, manages grace periods, and performs auto-downgrades.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Build TypeScript:**
   ```bash
   npm run build
   ```

3. **Run linter:**
   ```bash
   npm run lint
   ```

## Development

### Local Testing

Run Firebase emulators:
```bash
npm run serve
```

This will start the Functions emulator along with other Firebase services.

### Deployment

Deploy all functions:
```bash
npm run deploy
```

Or from project root:
```bash
firebase deploy --only functions
```

### View Logs

```bash
npm run logs
```

Or:
```bash
firebase functions:log
```

## Configuration

- **Node.js version:** 18
- **TypeScript:** 4.9+
- **Firebase Functions:** v2

## Project Structure

```
functions/
├── src/
│   └── index.ts          # Main functions file
├── lib/                  # Compiled JavaScript (generated)
├── package.json
├── tsconfig.json
└── README.md
```

## Documentation

See [SUBSCRIPTION_RENEWAL_AUTOMATION.md](../docs/monetization/SUBSCRIPTION_RENEWAL_AUTOMATION.md) for detailed documentation.

