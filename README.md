# CritterCrush

## Table of Contents
1. [Overview](#Overview)
2. [Wireframes](#Wireframes)
3. [API Reference](#API_Reference)

## Overview
### Description
Develop an iOS app for users to take pictures of invasive species of insects in NY, identify them using image recognition and upload reports to an online database. The app will be built for more casual use with extras such as social features and associated rewards for uploading reports.

## Demo
<img src="https://i.imgur.com/vYDZ3OK.gif" width="300" height="600">

### Login
<img src="http://g.recordit.co/O2gJGXhWig.gif" width="300" height="600">

### Map
<img src="https://i.imgur.com/VRLqr05.gif" width="300" height="600">

### Species
<img src="https://i.imgur.com/ZGTSx9t.gif" width="300" height="600">

### Submissions
<img src="https://i.imgur.com/FI4K7wv.gif" width="300" height="600">

### Profile / Settings
<img src="https://i.imgur.com/mTWoJfN.gif" width="300" height="600">

### Add Report / Image Recognition
<img src="https://i.imgur.com/xpiBNy4.gif" width="300" height="600">
<img src="https://i.imgur.com/vc82Oc7.gif" width="300" height="600">

## API Reference
|        API        |    Description   | Request Parameters | Response Body |
| ----------------- | ---------------- | ----------------- | ------------- |
| GET /api/reports      | Returns list of reports | None | List of Report objects |
| GET /api/users/login | Recieve auth token for user from username and password | Username, Password | Auth token |
| POST /api/users/register | Register new user into database | Username, Password, Email | Auth token |
| GET /api/users/verifylogin | Verify auth token | Username | Boolean (true if token is valid) |


## Wireframes
<img width="872" alt="Screenshot 2023-02-23 at 3 23 20 PM" src="https://user-images.githubusercontent.com/56377738/221021733-8d9b9651-3682-4d67-bcf8-11ec70a17b88.png">
