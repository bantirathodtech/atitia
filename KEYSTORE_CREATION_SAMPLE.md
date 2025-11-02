# 🔐 Complete Keystore Creation - All Answers Sample

**Copy this command and use these exact answers:**

---

## **Step 1: Run This Command**

```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia && keytool -genkey -v -keystore android/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias atitia-release
```

---

## **Step 2: Answer Each Prompt**

Here are all the answers you'll need:

```
Enter keystore password: 
[Enter your password - at least 6 characters]
[Example: Atitia@pg123]

Re-enter new password: 
[Enter the same password again]
[Example: Atitia@pg123]

What is your first and last name?
  [Unknown]: Banti Rathod

What is the name of your organizational unit?
  [Unknown]: Avishio

What is the name of your organization?
  [Unknown]: Avishio

What is the name of your City or Locality?
  [Unknown]: Hyderabad

What is the name of your State or Province?
  [Unknown]: Telangana

What is the two-letter country code for this unit?
  [Unknown]: IN

Is CN=Banti Rathod, OU=Avishio, O=Avishio, L=Hyderabad, ST=Telangana, C=IN correct?
  [no]: yes

Enter key password for <atitia-release>
        (RETURN if same as keystore password): 
[Press Enter to use same password]
```

---

## **Complete Example Session**

Here's what your terminal session will look like:

```bash
$ keytool -genkey -v -keystore android/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias atitia-release

Enter keystore password: ********
Re-enter new password: ********

What is your first and last name?
  [Unknown]: Banti Rathod

What is the name of your organizational unit?
  [Unknown]: Avishio

What is the name of your organization?
  [Unknown]: Avishio

What is the name of your City or Locality?
  [Unknown]: Hyderabad

What is the name of your State or Province?
  [Unknown]: Telangana

What is the two-letter country code for this unit?
  [Unknown]: IN

Is CN=Banti Rathod, OU=Avishio, O=Avishio, L=Hyderabad, ST=Telangana, C=IN correct?
  [no]: yes

Enter key password for <atitia-release>
        (RETURN if same as keystore password): 
[Press Enter]

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
	for: CN=Banti Rathod, OU=Avishio, O=Avishio, L=Hyderabad, ST=Telangana, C=IN

[Storing android/keystore.jks]
```

---

## **Summary of All Answers**

| Prompt | Your Answer |
|--------|-------------|
| Keystore password | Your password (save securely!) |
| Re-enter password | Same password |
| First and last name | `Banti Rathod` |
| Organizational unit | `Avishio` |
| Organization | `Avishio` |
| City | `Hyderabad` |
| State | `Telangana` |
| Country code | `IN` ⚠️ (2 letters, not 91!) |
| Confirm correct? | `yes` |
| Key password | Press `Enter` (use same) |

---

## **Key Points**

✅ **Country Code**: Use `IN` (2 letters), NOT `91` (numeric code)  
✅ **Password**: Save it securely - you'll need it forever for app updates  
✅ **Key Password**: Just press Enter to use the same as keystore password  

---

**Ready? Copy the command from Step 1 and use these answers!**

