# 🔑 Razorpay Test Keys Setup - Multiple Options

This guide shows all the different ways you can provide Razorpay API keys to the setup script.

---

## ✅ Recommended: Environment Variable

**Best for:** Production, CI/CD, or when you want to keep keys out of command history

```bash
# Set environment variable and run
RAZORPAY_TEST_KEY=rzp_test_RlAOuGGXSxvL66 ./scripts/setup/setup-razorpay-test-keys.sh <owner-id>

# Or export first, then run
export RAZORPAY_TEST_KEY=rzp_test_RlAOuGGXSxvL66
./scripts/setup/setup-razorpay-test-keys.sh <owner-id>
```

**Pros:**
- ✅ Keys not in command history
- ✅ Easy to use in scripts
- ✅ Works with CI/CD pipelines

---

## ✅ Recommended: Command Line Argument

**Best for:** Quick one-time setup

```bash
./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --api-key rzp_test_RlAOuGGXSxvL66
```

**Pros:**
- ✅ Simple and straightforward
- ✅ No extra setup needed

**Note:** API key may appear in shell history

---

## ✅ Interactive Prompt

**Best for:** First-time setup or when you prefer to type the key securely

```bash
./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --interactive
```

The script will prompt you:
```
Enter Razorpay API Key (rzp_test_... or rzp_live_...): 
```

**Pros:**
- ✅ Key not visible on screen while typing
- ✅ Good for sensitive keys

---

## ✅ Read from Stdin

**Best for:** Scripts or piping from other commands

```bash
# From echo
echo "rzp_test_RlAOuGGXSxvL66" | ./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --stdin

# From file
cat /path/to/key.txt | ./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --stdin

# From clipboard (macOS)
pbpaste | ./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --stdin
```

**Pros:**
- ✅ Flexible - can come from anywhere
- ✅ Good for automation

---

## ❌ Backup File (.secrets - Not Recommended)

The script will **only** use `.secrets/api-keys/razorpay-test.json` as a **last resort** if no other method is provided. This is just for backward compatibility.

**Note:** `.secrets/` folder is for backup only, not for direct use in production.

---

## 🔐 Priority Order

The script checks for API keys in this order:

1. **Command line argument** (`--api-key`)
2. **Environment variable** (`RAZORPAY_TEST_KEY`)
3. **Interactive prompt** (`--interactive`)
4. **Stdin** (`--stdin`)
5. **Backup file** (`.secrets/api-keys/razorpay-test.json` - last resort)

---

## 🔧 Firebase Service Account

The script also supports multiple ways to provide Firebase service account:

1. **File:** `.secrets/web/firebase_service_account.json`
2. **Environment variable:** `FIREBASE_SERVICE_ACCOUNT` (JSON string)
3. **Environment variable:** `GOOGLE_APPLICATION_CREDENTIALS` (file path)
4. **Environment variable:** `FIREBASE_SERVICE_ACCOUNT_PATH` (file path)

---

## 📝 Examples

### Example 1: Quick Setup with Command Line
```bash
./scripts/setup/setup-razorpay-test-keys.sh blg5v21mbvb6U70xUpzrfKVjYh13 \
  --api-key rzp_test_RlAOuGGXSxvL66
```

### Example 2: Secure Setup with Environment Variable
```bash
export RAZORPAY_TEST_KEY=rzp_test_RlAOuGGXSxvL66
./scripts/setup/setup-razorpay-test-keys.sh blg5v21mbvb6U70xUpzrfKVjYh13
```

### Example 3: Interactive Setup
```bash
./scripts/setup/setup-razorpay-test-keys.sh blg5v21mbvb6U70xUpzrfKVjYh13 --interactive
# Will prompt: Enter Razorpay API Key: 
```

### Example 4: Overwrite Existing Keys
```bash
./scripts/setup/setup-razorpay-test-keys.sh <owner-id> \
  --api-key rzp_test_RlAOuGGXSxvL66 \
  --force
```

---

## 🔒 Security Best Practices

1. ✅ **Use Environment Variables** for production/CI/CD
2. ✅ **Use Interactive Prompt** for manual setup
3. ✅ **Don't commit keys** to git
4. ✅ **Clear shell history** if keys were typed directly
5. ✅ **Rotate keys regularly**

---

## 🎯 Quick Reference

| Method | Command | Best For |
|--------|---------|----------|
| Env Variable | `RAZORPAY_TEST_KEY=xxx ./script.sh <id>` | Production, CI/CD |
| CLI Arg | `./script.sh <id> --api-key xxx` | Quick setup |
| Interactive | `./script.sh <id> --interactive` | First-time, secure |
| Stdin | `echo "xxx" \| ./script.sh <id> --stdin` | Automation |

---

**Questions?** Check the main documentation: `RAZORPAY_TEST_SETUP_AUTOMATED.md`
