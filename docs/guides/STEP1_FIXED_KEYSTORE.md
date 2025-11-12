# 🔐 Step 1 (Fixed): Create Android Keystore with Correct Country Code

**Let's recreate the keystore with the correct 2-letter country code 'IN' instead of '91'.**

---

## **Run This Command**

```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia && keytool -genkey -v -keystore android/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias atitia-release
```

---

## **What to Enter (Use Same Values Except Country Code)**

1. **Keystore password**: Same password as before (save it!)

2. **Re-enter password**: Same password

3. **First and last name**: 
   ```
   Banti Rathod
   ```

4. **Organizational unit**: 
   ```
   Avishio
   ```

5. **Organization**: 
   ```
   Avishio
   ```

6. **City**: 
   ```
   Hyderabad
   ```

7. **State**: 
   ```
   Telangana
   ```

8. **Country code (2 letters)**: 
   ```
   IN
   ```
   ⚠️ **IMPORTANT:** Enter `IN` (not 91!)

9. **Confirm (CN=... correct?)**: 
   ```
   yes
   ```

10. **Key password**: Press Enter (use same as keystore)

---

## **After Keystore is Created**

I'll help you create the `key.properties` file automatically.

---

**Ready? Run the command above and follow the prompts!**

