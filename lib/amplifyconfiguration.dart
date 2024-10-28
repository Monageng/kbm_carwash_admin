const amplifyconfig = ''' {
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": {"Default": {}},
        "CredentialsProvider": {
          "CognitoIdentity": {
            "Default": {
              "PoolId": "af-south-1_AS0E6kpLh",
              "Region": "af-south-1"
            }
          }
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "af-south-1_AS0E6kpLh",
            "AppClientId": "qrthng2thfvp3kdoip4oft24j",
            "Region": "af-south-1"
          }
        },
        "Auth": {
          "Default": {"authenticationFlowType": "USER_PASSWORD_AUTH"}
        }
      }
    }
  }
}''';
