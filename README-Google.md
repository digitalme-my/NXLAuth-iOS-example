# Using NXLAuth for iOS with Google

To configure the sample with a Google OAuth client, first visit
https://console.developers.google.com/apis/credentials?project=_ and create a
new project. Then tap "Create credentials" and select "OAuth client ID".

Follow the instructions to configure the consent screen (just the Product Name
is needed).

Then follow the instructions for your platform:

## iOS

Select "iOS" as the application type, and enter your Bundle ID.

Then, setup the example with your configuration:

| Configuration | Description      |
|---------------|------------------|
| Issuer        | `https://accounts.google.com`|
| Client ID     | The value named `Client ID` in the console, has the format `IDENTIFIER.apps.googleusercontent.com`.|
| Client Secret | Google's iOS clients do not have a secret.|
| Redirect URI  | The value for `iOS URL scheme` wil be the scheme of your redirect URI. This is the Client ID in reverse domain name notation, e.g. `	com.googleusercontent.apps.IDENTIFIER`. To construct the redirect URI, add your own path component. E.g. `	com.googleusercontent.apps.IDENTIFIER:/oauth2redirect/google`. Note that there is only a single slash (`/`) after the scheme.| 

