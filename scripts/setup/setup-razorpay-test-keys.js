#!/usr/bin/env node

/**
 * Razorpay Test Keys Setup Script
 * 
 * This script automatically initializes Razorpay test API keys in Firestore
 * for specified owner accounts.
 * 
 * Usage (Multiple Options):
 *   # Option 1: Environment Variable
 *   RAZORPAY_TEST_KEY=rzp_test_xxx node scripts/setup/setup-razorpay-test-keys.js <owner-id>
 * 
 *   # Option 2: Command Line Argument
 *   node scripts/setup/setup-razorpay-test-keys.js <owner-id> --api-key rzp_test_xxx
 * 
 *   # Option 3: Interactive Prompt (will ask for key)
 *   node scripts/setup/setup-razorpay-test-keys.js <owner-id> --interactive
 * 
 *   # Option 4: Read from stdin
 *   echo "rzp_test_xxx" | node scripts/setup/setup-razorpay-test-keys.js <owner-id> --stdin
 * 
 * Options:
 *   --api-key <key>     Provide Razorpay API key directly
 *   --interactive       Prompt for API key interactively
 *   --stdin             Read API key from stdin
 *   --force             Overwrite existing Razorpay configuration
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Try to load firebase-admin from multiple possible locations
let admin;
try {
  // Try root node_modules first (if installed)
  admin = require('firebase-admin');
} catch (e) {
  try {
    // Try functions/node_modules (project structure)
    const functionsPath = path.join(__dirname, '../../functions/node_modules/firebase-admin');
    admin = require(functionsPath);
  } catch (e2) {
    console.error('❌ Error: firebase-admin not found');
    console.error('   Please install it: npm install firebase-admin');
    console.error('   Or ensure functions/node_modules/firebase-admin exists');
    process.exit(1);
  }
}

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

// Parse command line arguments
const args = process.argv.slice(2);
let ownerId = null;
let apiKey = null;
let force = false;
let interactive = false;
let stdin = false;

for (let i = 0; i < args.length; i++) {
  const arg = args[i];
  
  if (arg === '--force') {
    force = true;
  } else if (arg === '--interactive') {
    interactive = true;
  } else if (arg === '--stdin') {
    stdin = true;
  } else if (arg === '--api-key') {
    apiKey = args[++i];
    if (!apiKey || apiKey.startsWith('--')) {
      console.error(`${colors.red}❌ Error: --api-key requires a value${colors.reset}`);
      process.exit(1);
    }
  } else if (!ownerId && !arg.startsWith('--')) {
    ownerId = arg;
  }
}

// Check if owner ID is provided
if (!ownerId) {
  console.error(`${colors.red}❌ Error: Owner ID is required${colors.reset}\n`);
  console.log(`${colors.cyan}Usage:${colors.reset}\n`);
  
  console.log(`${colors.bright}Option 1: Environment Variable${colors.reset}`);
  console.log(`  RAZORPAY_TEST_KEY=rzp_test_xxx node scripts/setup/setup-razorpay-test-keys.js <owner-id>\n`);
  
  console.log(`${colors.bright}Option 2: Command Line Argument${colors.reset}`);
  console.log(`  node scripts/setup/setup-razorpay-test-keys.js <owner-id> --api-key rzp_test_xxx\n`);
  
  console.log(`${colors.bright}Option 3: Interactive Prompt${colors.reset}`);
  console.log(`  node scripts/setup/setup-razorpay-test-keys.js <owner-id> --interactive\n`);
  
  console.log(`${colors.bright}Option 4: Read from stdin${colors.reset}`);
  console.log(`  echo "rzp_test_xxx" | node scripts/setup/setup-razorpay-test-keys.js <owner-id> --stdin\n`);
  
  console.log(`${colors.yellow}Options:${colors.reset}`);
  console.log(`  --api-key <key>     Provide Razorpay API key directly`);
  console.log(`  --interactive       Prompt for API key interactively`);
  console.log(`  --stdin             Read API key from stdin`);
  console.log(`  --force             Overwrite existing Razorpay configuration\n`);
  
  console.log(`${colors.cyan}Example:${colors.reset}`);
  console.log(`  node scripts/setup/setup-razorpay-test-keys.js blg5v21mbvb6U70xUpzrfKVjYh13 --api-key rzp_test_RlAOuGGXSxvL66\n`);
  process.exit(1);
}

/**
 * Get Razorpay API key from various sources
 */
async function getRazorpayApiKey() {
  // Priority 1: Command line argument
  if (apiKey) {
    if (!apiKey.startsWith('rzp_test_') && !apiKey.startsWith('rzp_live_')) {
      console.error(`${colors.yellow}⚠️  Warning: API key should start with 'rzp_test_' or 'rzp_live_'${colors.reset}`);
    }
    return apiKey.trim();
  }

  // Priority 2: Environment variable
  if (process.env.RAZORPAY_TEST_KEY) {
    const envKey = process.env.RAZORPAY_TEST_KEY.trim();
    if (envKey) {
      if (!envKey.startsWith('rzp_test_') && !envKey.startsWith('rzp_live_')) {
        console.error(`${colors.yellow}⚠️  Warning: API key should start with 'rzp_test_' or 'rzp_live_'${colors.reset}`);
      }
      return envKey;
    }
  }

  // Priority 3: Interactive prompt
  if (interactive) {
    return await promptForApiKey();
  }

  // Priority 4: Read from stdin
  if (stdin) {
    return await readFromStdin();
  }

  // Priority 5: Try to read from .secrets (backup only, not recommended)
  const backupPath = path.join(__dirname, '../../.secrets/api-keys/razorpay-test.json');
  if (fs.existsSync(backupPath)) {
    console.log(`${colors.yellow}⚠️  Reading from backup file (not recommended for production)${colors.reset}`);
    try {
      const razorpayTestKeys = JSON.parse(fs.readFileSync(backupPath, 'utf8'));
      const backupKey = razorpayTestKeys.test?.apiKey;
      if (backupKey) {
        return backupKey;
      }
    } catch (e) {
      // Ignore errors, will show error below
    }
  }

  // No key found - show error
  console.error(`${colors.red}❌ Error: Razorpay API key not provided${colors.reset}\n`);
  console.log(`${colors.cyan}Please provide the API key using one of these methods:${colors.reset}\n`);
  console.log(`1. Environment variable: RAZORPAY_TEST_KEY=rzp_test_xxx`);
  console.log(`2. Command line: --api-key rzp_test_xxx`);
  console.log(`3. Interactive: --interactive`);
  console.log(`4. Stdin: echo "rzp_test_xxx" | ... --stdin\n`);
  process.exit(1);
}

/**
 * Prompt user for API key interactively
 */
function promptForApiKey() {
  return new Promise((resolve) => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    rl.question(`${colors.cyan}Enter Razorpay API Key (rzp_test_... or rzp_live_...): ${colors.reset}`, (answer) => {
      rl.close();
      const key = answer.trim();
      if (!key) {
        console.error(`${colors.red}❌ Error: API key cannot be empty${colors.reset}`);
        process.exit(1);
      }
      if (!key.startsWith('rzp_test_') && !key.startsWith('rzp_live_')) {
        console.error(`${colors.yellow}⚠️  Warning: API key should start with 'rzp_test_' or 'rzp_live_'${colors.reset}`);
      }
      resolve(key);
    });
  });
}

/**
 * Read API key from stdin
 */
function readFromStdin() {
  return new Promise((resolve, reject) => {
    let data = '';
    
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    
    process.stdin.on('end', () => {
      const key = data.trim();
      if (!key) {
        reject(new Error('No API key provided via stdin'));
        return;
      }
      if (!key.startsWith('rzp_test_') && !key.startsWith('rzp_live_')) {
        console.error(`${colors.yellow}⚠️  Warning: API key should start with 'rzp_test_' or 'rzp_live_'${colors.reset}`);
      }
      resolve(key);
    });
    
    process.stdin.on('error', reject);
  });
}

// Firebase service account path (check multiple locations)
const possibleServiceAccountPaths = [
  path.join(__dirname, '../../.secrets/web/firebase_service_account.json'),
  process.env.FIREBASE_SERVICE_ACCOUNT_PATH,
  process.env.GOOGLE_APPLICATION_CREDENTIALS,
].filter(Boolean);

let SERVICE_ACCOUNT_PATH = null;
let serviceAccount = null;

for (const possiblePath of possibleServiceAccountPaths) {
  if (fs.existsSync(possiblePath)) {
    SERVICE_ACCOUNT_PATH = possiblePath;
    try {
      serviceAccount = JSON.parse(fs.readFileSync(possiblePath, 'utf8'));
      break;
    } catch (e) {
      // Try next path
      continue;
    }
  }
}

// Check if service account JSON is provided via environment variable
if (!serviceAccount && process.env.FIREBASE_SERVICE_ACCOUNT) {
  try {
    serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  } catch (e) {
    console.error(`${colors.red}❌ Error: Invalid FIREBASE_SERVICE_ACCOUNT JSON${colors.reset}`);
    process.exit(1);
  }
}

if (!serviceAccount) {
  console.error(`${colors.red}❌ Error: Firebase service account not found${colors.reset}`);
  console.error(`\n${colors.cyan}Please provide Firebase service account using one of:${colors.reset}\n`);
  console.log(`1. File: .secrets/web/firebase_service_account.json`);
  console.log(`2. Environment variable: FIREBASE_SERVICE_ACCOUNT (JSON string)`);
  console.log(`3. Environment variable: GOOGLE_APPLICATION_CREDENTIALS (file path)`);
  console.log(`4. Environment variable: FIREBASE_SERVICE_ACCOUNT_PATH (file path)\n`);
  process.exit(1);
}

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: serviceAccount.project_id || 'atitia-87925',
  });
}

const db = admin.firestore();
const COLLECTION_NAME = 'owner_payment_details';

/**
 * Main function to setup Razorpay test keys
 */
async function setupRazorpayTestKeys() {
  try {
    console.log(`${colors.bright}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
    console.log(`${colors.bright}🔧 Razorpay Test Keys Setup${colors.reset}`);
    console.log(`${colors.bright}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);

    // Get API key from various sources
    const razorpayApiKey = await getRazorpayApiKey();
    
    console.log(`${colors.cyan}📋 Configuration:${colors.reset}`);
    console.log(`   Owner ID: ${ownerId}`);
    console.log(`   Razorpay Key: ${razorpayApiKey.substring(0, 20)}...`);
    console.log(`   Key Type: ${razorpayApiKey.startsWith('rzp_test_') ? 'Test' : 'Live'}\n`);

    // Check if document exists
    const docRef = db.collection(COLLECTION_NAME).doc(ownerId);
    const docSnap = await docRef.get();

    if (docSnap.exists) {
      const existingData = docSnap.data();
      
      if (existingData.razorpayKey && !force) {
        console.log(`${colors.yellow}⚠️  Warning: Razorpay key already exists for this owner${colors.reset}`);
        console.log(`   Existing key: ${existingData.razorpayKey.substring(0, 20)}...`);
        console.log(`   Enabled: ${existingData.razorpayEnabled || false}\n`);
        console.log(`${colors.cyan}💡 Use --force flag to overwrite existing configuration${colors.reset}\n`);
        process.exit(0);
      }

      // Update existing document
      const updateData = {
        razorpayKey: razorpayApiKey,
        razorpayEnabled: true,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      };

      await docRef.update(updateData);

      console.log(`${colors.green}✅ Updated existing payment details document${colors.reset}`);
    } else {
      // Create new document
      const newData = {
        ownerId: ownerId,
        razorpayKey: razorpayApiKey,
        razorpayEnabled: true,
        isActive: true,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      };

      await docRef.set(newData);

      console.log(`${colors.green}✅ Created new payment details document${colors.reset}`);
    }

    // Verify the setup
    const verifySnap = await docRef.get();
    if (verifySnap.exists) {
      const verifiedData = verifySnap.data();
      
      console.log(`\n${colors.bright}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
      console.log(`${colors.bright}✅ Verification Complete${colors.reset}`);
      console.log(`${colors.bright}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
      console.log(`${colors.cyan}📋 Final Configuration:${colors.reset}`);
      console.log(`   Collection: ${COLLECTION_NAME}`);
      console.log(`   Document ID: ${ownerId}`);
      console.log(`   Razorpay Key: ${verifiedData.razorpayKey}`);
      console.log(`   Razorpay Enabled: ${verifiedData.razorpayEnabled}`);
      console.log(`   Active: ${verifiedData.isActive !== false}\n`);

      console.log(`${colors.green}🎉 Razorpay test keys successfully configured!${colors.reset}\n`);
      console.log(`${colors.cyan}📝 Next Steps:${colors.reset}`);
      console.log(`   1. Test payment flow in your app`);
      console.log(`   2. Use Razorpay test cards (no real money)`);
      console.log(`   3. Check payments in Razorpay Dashboard (Test Mode)\n`);
    }

    process.exit(0);
  } catch (error) {
    console.error(`\n${colors.red}❌ Error setting up Razorpay test keys:${colors.reset}`);
    console.error(`   ${error.message}\n`);
    
    if (error.code === 'permission-denied') {
      console.error(`${colors.yellow}💡 Tip: Ensure your service account has Firestore write permissions${colors.reset}\n`);
    }
    
    process.exit(1);
  }
}

// Run the setup
setupRazorpayTestKeys();
