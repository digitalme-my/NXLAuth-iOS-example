# NXLAuth for iOS Example Project

The examples need to be configured with an OpenID Connect issuer (or
Authorization and Token endpoints manually), and the OAuth client information
like the Client ID and Redirect URI.


## Setup & Open the Project

1. In your project folder, run the following command to install the
AppAuth pod.

```
pod install
```

2. Open the `NXLAuthExample.xcworkspace` workspace.

```
open NXLAuthExample.xcworkspace
```

This workspace is configured to include AppAuth via CocoaPods and NXLAuth Framework.

## Configuration

The example doesn't work out of the box, you need to configure it with your own
client ID, Issuer, Redirect URI

### Information You'll Need

* Issuer
* Client ID
* Redirect URI

How to get this information varies by IdP, but we have
[instructions](/README.md#openid-certified-providers) for some OpenID
Certified providers.

### Configure the Example

#### In the file `configuration.plist` 

1. Update `Issuer` with the IdP's issuer.
2. Update `ClientID` with your new client id.
3. Update `RedirectURI` redirect URI

![configuration_plist](/images/configuration_plist.png)

#### In the file `Info.plist`

Fully expand "URL types" (a.k.a. `CFBundleURLTypes`) and replace
`com.example.app` with the *scheme* of your redirect URI. 
The scheme is everything before the colon (`:`).  For example, if the redirect
URI is `com.example.app:/oauth2redirect/example-provider`, then the scheme
would be `com.example.app`.

![info_plist](/images/info_plist.png)

### Running the Example

Now your example should be ready to run.

