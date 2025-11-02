#!/usr/bin/env python3
"""
Add GitHub Secrets using GitHub API
Requires: pip install PyNaCl requests
"""

import os
import sys
import base64
import json
import requests
from nacl import encoding, public

REPO_OWNER = "bantirathodtech"
REPO_NAME = "atitia"
GITHUB_API = "https://api.github.com"

def encrypt_secret(public_key: str, secret_value: str) -> str:
    """Encrypt a secret using the repository's public key."""
    public_key_bytes = base64.b64decode(public_key)
    sealed_box = public.SealedBox(public.PublicKey(public_key_bytes))
    encrypted = sealed_box.encrypt(secret_value.encode())
    return base64.b64encode(encrypted).decode()

def get_public_key(token: str):
    """Get the repository's public key for encryption."""
    url = f"{GITHUB_API}/repos/{REPO_OWNER}/{REPO_NAME}/actions/secrets/public-key"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def add_secret(token: str, secret_name: str, secret_value: str):
    """Add a secret to GitHub repository."""
    # Get public key
    key_data = get_public_key(token)
    public_key = key_data["key"]
    key_id = key_data["key_id"]
    
    # Encrypt secret
    encrypted_value = encrypt_secret(public_key, secret_value)
    
    # Add secret
    url = f"{GITHUB_API}/repos/{REPO_OWNER}/{REPO_NAME}/actions/secrets/{secret_name}"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    data = {
        "encrypted_value": encrypted_value,
        "key_id": key_id
    }
    response = requests.put(url, headers=headers, json=data)
    response.raise_for_status()
    return True

def main():
    print("🔐 Adding GitHub Secrets via API")
    print("=" * 50)
    print(f"Repository: {REPO_OWNER}/{REPO_NAME}\n")
    
    # Check dependencies
    try:
        import nacl
        import requests
    except ImportError:
        print("❌ Missing dependencies. Install:")
        print("   pip install PyNaCl requests")
        sys.exit(1)
    
    # Get GitHub token
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Enter your GitHub Personal Access Token:")
        print("(Create at: https://github.com/settings/tokens)")
        print("(Required scopes: repo)")
        token = input("Token: ").strip()
        if not token:
            print("❌ Token required")
            sys.exit(1)
    
    # Check keystore exists
    keystore_path = "android/keystore.jks"
    if not os.path.exists(keystore_path):
        print(f"❌ Keystore not found: {keystore_path}")
        sys.exit(1)
    
    # Read keystore password
    print("\nEnter your keystore password:")
    import getpass
    keystore_password = getpass.getpass().strip()
    if not keystore_password:
        print("❌ Password required")
        sys.exit(1)
    
    # Generate base64 keystore
    print("\n📦 Generating base64 keystore...")
    with open(keystore_path, "rb") as f:
        keystore_base64 = base64.b64encode(f.read()).decode()
    
    secrets = {
        "ANDROID_KEYSTORE_BASE64": keystore_base64,
        "ANDROID_KEYSTORE_PASSWORD": keystore_password,
        "ANDROID_KEY_ALIAS": "atitia-release",
        "ANDROID_KEY_PASSWORD": keystore_password
    }
    
    print("\n🔐 Adding secrets...")
    print("-" * 50)
    
    success_count = 0
    for name, value in secrets.items():
        try:
            print(f"Adding {name}...", end=" ")
            add_secret(token, name, value)
            print("✅")
            success_count += 1
        except Exception as e:
            print(f"❌ Failed: {e}")
    
    print("-" * 50)
    print(f"\n✅ Added {success_count}/{len(secrets)} secrets successfully!")
    print(f"\nVerify at: https://github.com/{REPO_OWNER}/{REPO_NAME}/settings/secrets/actions")

if __name__ == "__main__":
    main()

