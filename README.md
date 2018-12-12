# gabe565/self-service-password

An alpine-based docker image to run php-fpm with [self-service-password](https://github.com/ltb-project/self-service-password).

# Quick Start

Run the self-service-password image:

```sh
docker run --name self-service-password --detach gabe565/self-service-password
```

You will not be able to access this image from the host machine without special setup since this image is a light php-fpm image. A webserver will need to be running to pass HTTP calls to php-fpm.

# Running with docker-compose

The [provided docker-compose file](https://github.com/gabe565/docker-self-service-password/blob/master/docker-compose.yml) is setup with some environment variables in-place and an nginx reverse-proxy setup. 

To run this image

 1. Download [docker-compose.yml](https://github.com/gabe565/docker-self-service-password/blob/master/docker-compose.yml) and [nginx.conf](https://github.com/gabe565/docker-self-service-password/blob/master/nginx.conf) into an empty directory.

 2. Change any environment variables that need to be personalized.

 3. Run the following command to start the app image and the reverse-proxy.

    ```sh
    docker-compose up -d
    ```

The container should now be bound to the host machine at port 8080

# Environment

Most of the [original self-service-password options](https://github.com/ltb-project/self-service-password/blob/master/conf/config.inc.php) can be changed through (all-uppercase) environment variables to allow for customization.    


| Variable                               | Description                                                                                                                                                                                                                              | Default Value                                            |
|----------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| DEBUG                                  | Enable debug logging                                                                                                                                                                                                                     | `false`                                                  |
| LDAP_URL                               | LDAP server url                                                                                                                                                                                                                          | `ldap://localhost`                                       |
| LDAP_STARTTLS                          | Enable starttls                                                                                                                                                                                                                          | `false`                                                  |
| LDAP_BINDDN                            | User bind DN                                                                                                                                                                                                                             | `cn=manager,dc=example,dc=com`                           |
| LDAP_BINDPW                            | User bind password                                                                                                                                                                                                                       | `secret`                                                 |
| LDAP_BASE                              | Base to find users in                                                                                                                                                                                                                    | `dc=example,dc=com`                                      |
| LDAP_LOGIN_ATTRIBUTE                   | LDAP field that corresponds to the "Login" input.                                                                                                                                                                                        | `uid`                                                    |
| LDAP_FULLNAME_ATTRIBUTE                | LDAP field that corresponds to the user's full name.                                                                                                                                                                                     | `cn`                                                     |
| LDAP_FILTER                            | User filter. Note that the other `LDAP_*` variables can be resolved here, just type them lowercase as a PHP variable.                                                                                                                    | `(&(objectClass=person)($ldap_login_attribute={login}))` |
| AD_MODE                                | If enabled, `unicodePwd` will be used as the password field.                                                                                                                                                                             | `false`                                                  |
| AD_OPTIONS_FORCE_UNLOCK                | Force unlock an account on password change.                                                                                                                                                                                              | `false`                                                  |
| AD_OPTIONS_FORCE_PWD_CHANGE            | Force a password change at the next user login.                                                                                                                                                                                          | `false`                                                  |
| AD_OPTIONS_CHANGE_EXPIRED_PASSWORD     | Allow users to update their password even if it is expired.                                                                                                                                                                              | `false`                                                  |
| SAMBA_MODE                             | If enabled, `sambaNTpassword` and `sambaPwdLastSet` attributes will be updated along with the usual password field.                                                                                                                      | `false`                                                  |
| SAMBA_OPTIONS_MIN_AGE                  | Sets the password minimum age.                                                                                                                                                                                                           | `5`                                                      |
| SAMBA_OPTIONS_MAX_AGE                  | Sets the password maximum age.                                                                                                                                                                                                           | `45`                                                     |
| SHADOW_OPTIONS_UPDATE_SHADOWLASTCHANGE | Requires `shadowAccount` objectClass. Updates the `shadowLastChange` attribute.                                                                                                                                                          | `false`                                                  |
| SHADOW_OPTION_UPDATE_SHADOWEXPIRE      | Requires `shadowAccount` objectClass. Updates the `shadowExpireDays` attribute.                                                                                                                                                          | `false`                                                  |
| SHADOW_OPTIONS_SHADOW_EXPIRE_DAYS      | Shadow expiry time. Value of `-1` means never expire.                                                                                                                                                                                    | `-1`                                                     |
| HASH                                   | The hashing method to use for `userPassword`                                                                                                                                                                                             | `clear`                                                  |
| HASH_OPTIONS_CRYPT_SALT_PREFIX         | Characters to prefix to the crypt hash.                                                                                                                                                                                                  | `$6$`                                                    |
| HASH_OPTIONS_CRYPT_SALT_LENGTH         | Length of the salt for the crypt hash.                                                                                                                                                                                                   | `6`                                                      |
| PWD_MIN_LENGTH                         | Minimum length.                                                                                                                                                                                                                          | `0`                                                      |
| PWD_MAX_LENGTH                         | Maximum length.                                                                                                                                                                                                                          | `0`                                                      |
| PWD_MIN_LOWER                          | Minimum lowercase characters.                                                                                                                                                                                                            | `0`                                                      |
| PWD_MIN_UPPER                          | Minimum uppercase characters.                                                                                                                                                                                                            | `0`                                                      |
| PWD_MIN_DIGIT                          | Minumum digit characters.                                                                                                                                                                                                                | `0`                                                      |
| PWD_MIN_SPECIAL                        | Minimum special characters.                                                                                                                                                                                                              | `0`                                                      |
| PWD_SPECIAL_CHARS                      | Defines characters that are considered special characters.                                                                                                                                                                               | `^a-zA-Z0-9`                                             |
| PWD_FORBIDDEN_CHARS                    | Defines characters that are not allowed.                                                                                                                                                                                                 | ` `                                                      |
| PWD_NO_REUSE                           | Does not allow the next password to be the same as the current.                                                                                                                                                                          | `true`                                                   |
| PWD_DIFF_LOGIN                         | Do not allow the password to be the same as the login.                                                                                                                                                                                   | `true`                                                   |
| PWD_COMPLEXITY                         | Number of different class of character required.                                                                                                                                                                                         | `0`                                                      |
| USE_PWNEDPASSWORDS                     | Use the pwnedpasswords API to securely check if the password has been in a leak.                                                                                                                                                         | `false`                                                  |
| PWD_SHOW_POLICY                        | Show the policy constraints. One of: `always`, `never`, `onerror`.                                                                                                                                                                       | `never`                                                  |
| PWD_SHOW_POLICY_POS                    | Position of the policy constraints message. One of: `above`, `below`.                                                                                                                                                                    | `above`                                                  |
| WHO_CHANGE_PASSWORD                    | Who is allowed to change their password. One of: `user`, `manager`.                                                                                                                                                                      | `user`                                                   |
| USE_CHANGE                             | Use the standard password change form.                                                                                                                                                                                                   | `true`                                                   |
| CHANGE_SSHKEY                          | Allow users to change their SSH key.                                                                                                                                                                                                     | `false`                                                  |
| CHANGE_SSHKEY_ATTRIBUTE                | Attribute that corresponds to an SSH key.                                                                                                                                                                                                | `sshPublicKey`                                           |
| WHO_CHANGE_SSHKEY                      | Who can change their SSH key. One of: `user`, `manager`.                                                                                                                                                                                 | `user`                                                   |
| NOTIFY_ON_SSHKEY_CHANGE                | Notify a user on SSH key change. Requires valid mail configuration.                                                                                                                                                                      | `false`                                                  |
| USE_QUESTIONS                          | Enables question/answer for password reset.                                                                                                                                                                                              | `true`                                                   |
| ANSWER_OBJECTCLASS                     | Object class where the answer is stored.                                                                                                                                                                                                 | `extensibleObject`                                       |
| ANSWER_ATTRIBUTE                       | Attribute that stores a users' answer.                                                                                                                                                                                                   | `info`                                                   |
| CRYPT_ANSWERS                          | Enables encryption on user answers.                                                                                                                                                                                                      | `true`                                                   |
| USE_TOKENS                             | Enables email tokens for password reset.                                                                                                                                                                                                 | `true`                                                   |
| CRYPT_TOKENS                           | Enables encryption on user tokens.                                                                                                                                                                                                       | `true`                                                   |
| TOKEN_LIFETIME                         | Amount of time before a token expires.                                                                                                                                                                                                   | `3600`                                                   |
| MAIL_ATTRIBUTE                         | Attribute that stores user email addresses.                                                                                                                                                                                              | `mail`                                                   |
| MAIL_ADDRESS_USE_LDAP                  | Get the first mail address from LDAP and hide mail input field.                                                                                                                                                                          | `false`                                                  |
| MAIL_FROM                              | Sender email address.                                                                                                                                                                                                                    | `admin@example.com`                                      |
| MAIL_FROM_NAME                         | Sender name.                                                                                                                                                                                                                             | `Self Service Password`                                  |
| MAIL_SIGNATURE                         | Sender signature.                                                                                                                                                                                                                        | ` `                                                      |
| NOTIFY_ON_CHANGE                       | Send an email on password change.                                                                                                                                                                                                        | `false`                                                  |
| MAIL_PROTOCOL                          | Protocol to send mail over.                                                                                                                                                                                                              | `smtp`                                                   |
| MAIL_SMTP_DEBUG                        | Enables debug logging on email send.                                                                                                                                                                                                     | `false`                                                  |
| MAIL_SMTP_HOST                         | SMTP server's hostname/IP address.                                                                                                                                                                                                       | `localhost`                                              |
| MAIL_SMTP_AUTH                         | Send username/password with SMTP.                                                                                                                                                                                                        | `false`                                                  |
| MAIL_SMTP_USER                         | SMTP username.                                                                                                                                                                                                                           | ` `                                                      |
| MAIL_SMTP_PASS                         | SMTP password.                                                                                                                                                                                                                           | ` `                                                      |
| MAIL_SMTP_PORT                         | SMTP port.                                                                                                                                                                                                                               | `25`                                                     |
| MAIL_SMTP_TIMEOUT                      | SMTP timeout in seconds.                                                                                                                                                                                                                 | `30`                                                     |
| MAIL_SMTP_KEEPALIVE                    | SMTP keepalive.                                                                                                                                                                                                                          | `false`                                                  |
| MAIL_SMTP_SECURE                       | SMTP secure communication.                                                                                                                                                                                                               | `tls`                                                    |
| MAIL_SMTP_AUTOTLS                      | SMTP autotls                                                                                                                                                                                                                             | `true`                                                   |
| MAIL_CONTENTTYPE                       | `Content-Type` header to send with emails.                                                                                                                                                                                               | `text/plain`                                             |
| MAIL_WORDWRAP                          | Mail word-wrap.                                                                                                                                                                                                                          | `0`                                                      |
| MAIL_CHARSET                           | Mail charset.                                                                                                                                                                                                                            | `utf-8`                                                  |
| MAIL_PRIORITY                          | Mail priority.                                                                                                                                                                                                                           | `3`                                                      |
| MAIL_NEWLINE                           | Newline character                                                                                                                                                                                                                        | `PHP_EOL`                                                |
| USE_SMS                                | Enable SMS notifications.                                                                                                                                                                                                                | `true`                                                   |
| SMS_METHOD                             | SMS delivery method.                                                                                                                                                                                                                     | `mail`                                                   |
| SMS_API_LIB                            | SMS API library location.                                                                                                                                                                                                                | `lib/smsapi.inc.php`                                     |
| SMS_ATTRIBUTE                          | Attribute that maps to a user's phone number.                                                                                                                                                                                            | `mobile`                                                 |
| SMS_PARTIALLY_HIDE_NUMBER              | Do not output a user's entire phone number.                                                                                                                                                                                              | `true`                                                   |
| SMSMAILTO                              | Where to send email to an SMS gateway.                                                                                                                                                                                                   | `{sms_attribute}@service.provider.com`                   |
| SMSMAIL_SUBJECT                        | Subject when sending to an SMS mail provider.                                                                                                                                                                                            | `Provider code`                                          |
| SMS_MESSAGE                            | SMS message text contents.                                                                                                                                                                                                               | `{smsresetmessage} {smstoken}`                           |
| SMS_SANITIZE_NUMBER                    | Remove non digit characters from GSM number.                                                                                                                                                                                             | `false`                                                  |
| SMS_TRUNCATE_NUMBER                    | Truncate GSM number.                                                                                                                                                                                                                     | `false`                                                  |
| SMS_TRUNCATE_NUMBER_LENGTH             | Length to truncate to.                                                                                                                                                                                                                   | `10`                                                     |
| SMS_TOKEN_LENGTH                       | Length of SMS token.                                                                                                                                                                                                                     | `6`                                                      |
| MAX_ATTEMPTS                           | Maximum attempts for SMS token.                                                                                                                                                                                                          | `3`                                                      |
| KEYPHRASE                              | Encryption and decryption keyphrase, required if `CRYPT_TOKENS` is `true`. Please change it to anything long, random and complicated, you do not have to remember it. Changing it will also invalidate all previous tokens and SMS codes | `secret`                                                 |
| RESET_URL                              | Reset URL (if behind a reverse proxy).                                                                                                                                                                                                   | Inferred from accessed url.                              |
| SHOW_HELP                              | Display help messages.                                                                                                                                                                                                                   | `true`                                                   |
| LANG                                   | Default language.                                                                                                                                                                                                                        | `en`                                                     |
| ALLOWED_LANG                           | List of authorized languages. If empty, all language are allowed. If not empty and the user's browser language setting is not in that list, language from `LANG` will be used.                                                           | ` `                                                      |
| SHOW_MENU                              | Display the top navigation menu.                                                                                                                                                                                                         | `true`                                                   |
| LOGO                                   | URL to logo image.                                                                                                                                                                                                                       | `images/ltb-logo.png`                                    |
| BACKGROUND_IMAGE                       | URL to background image.                                                                                                                                                                                                                 | `images/unsplash-space.jpeg`                             |
| LOGIN_FORBIDDEN_CHARS                  | Invalid characters in login. Set at least "*()&|" to prevent LDAP injection. If empty, only alphanumeric characters are accepted                                                                                                         | `*()&|`                                                  |
| USE_RECAPTCHA                          | Enable Google reCAPTCHA.                                                                                                                                                                                                                 | `false`                                                  |
| RECAPTCHA_PUBLICKEY                    | reCAPTCHA public key. Must be obtained from admin panel.                                                                                                                                                                                 | ``                                                       |
| RECAPTCHA_PRIVATEKEY                   | reCAPTCHA private key. Must be obtained from admin panel.                                                                                                                                                                                | ``                                                       |
| RECAPTCHA_THEME                        | reCAPTCHA theme. One of: `light`, `dark`.                                                                                                                                                                                                | `light`                                                  |
| RECAPTCHA_TYPE                         | reCAPTCHA type.                                                                                                                                                                                                                          | `image`                                                  |
| RECAPTCHA_SIZE                         | reCAPTCHA size.                                                                                                                                                                                                                          | `normal`                                                 |
| DEFAULT_ACTION                         | Default page to display. One of: `change`, `sendtoken`, `sendsms`.                                                                                                                                                                       | `change`                                                 |
| OBSCURE_FAILURE_MESSAGES               | Hide some messages to not disclose sensitive information. Passed in a JSON.                                                                                                                                                              | ``                                                       |
