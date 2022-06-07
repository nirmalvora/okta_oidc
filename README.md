# okta_oidc

okta_oidc provide simple authentication integratiin in mobile apps.

# Sample

check out sample app [Okta oidc](https://github.com/nirmalvora/okta_oidc/tree/main/example)

# Installation
to add okta_oidc to your flutter application [install](https://pub.dev/packages/okta_oidc/install) instructions. Below are some Android and iOS specifics that are required

<details>
<summary>Android</summary>

1. Make sure you set the `minSdkVersion` 21 or above in your "android/app/build.gradle" 
```
android {
  minSdkVersion 21

  ...
}
```
2. Similar to the sample app, you must add a redirect scheme to receive sign in results from the web browser. To do this, you must define a gradle manifest placeholder in your app's build.gradle:

```
manifestPlaceholders = [
    appAuthRedirectScheme: 'Add redirect schema here...'
  ]
```
</details>

<details>
<summary>iOS</summary>

1. Make sure the minimum deployment target in Podfile set to 13 or above

```
platform :ios, '13.0'
```
</details>

<br>
Add `assets/okta_config.json` file in root of your project with below data.

```
{
  "client_id": "",
  "redirect_uri": "",
  "end_session_redirect_uri": "",
  "scopes": [],
  "discovery_uri": ""
}
```

# Example

### Available Methods

### `initOkta`
This method will initialize okta with config file or map data.
<details>
<summary>code</summary>

```
OktaOidc oktaOidc = OktaOidc();

...
...

 Future<void> initOkta() async {
    final String response =
        await rootBundle.loadString('assets/okta_config.json');
    Map<String, dynamic>? oktaConfig = jsonDecode(response);
    oktaOidc.initOkta(oktaConfig);
  }
```
</details>


### `login`
This method will redirect you to okta sign in page and return response or error. 
<details>
<summary>code</summary>

```
 oktaOidc.login().then((value) {
                }).catchError((onError) {
                });
```

</details>


### `socialLogin`
This method can be used for social login like linked in, google and apple sign in. Need to provide idp and idp-scope for social sign in. 
<details>
<summary>code</summary>

```
  oktaOidc.socialLogin({
      "idp": "0oa11t5hlpcImo4BX0h8",
      "idp-scope": "r_liteprofile r_emailaddress"
    }).then((value) {
    });
```

</details>


### `getAccessToken`
This method will return access token if logged in if token is expired it will refresh the token. 
<details>
<summary>code</summary>

```
  oktaOidc.getAccessToken();
```

</details>


### `getUserProfile`
This method returns user profile data. 
<details>
<summary>code</summary>

```
  oktaOidc.getUserProfile();
```

</details>


### `logout`
This method clears the user session. 
<details>
<summary>code</summary>

```
  oktaOidc.logout();
```

</details>