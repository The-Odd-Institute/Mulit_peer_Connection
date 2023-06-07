# MultipeerConnectivity iOS Demo

An iOS application demonstrating peer-to-peer device communication using Apple's MultipeerConnectivity framework. Enables direct device-to-device messaging over local networks (with or without WiFi).

## Overview

This app allows multiple iOS or macOS devices to discover each other on a local network and establish direct connections for real-time message exchange. Uses Apple's native peer-to-peer framework for seamless device communication.

## Technologies

- **Language**: Swift
- **Framework**: MultipeerConnectivity
- **UI**: UIKit
- **Platform**: iOS/macOS

## Features

### Peer Discovery & Connection
- Automatic discovery of nearby devices
- Service advertisement and browsing
- Connection invitation system with accept/deny dialogs
- Real-time peer connection status tracking

### Messaging
- Send and receive messages between connected peers
- Chat display showing connection events and messages
- Device name identification using UIDevice

### User Interface
- TableView listing discovered peers
- Chat text view for message display
- Send action button
- Connection invitation alerts

## Project Structure

```
MultiPeer_Connection/
├── AppDelegate.swift      # App lifecycle
├── ViewController.swift   # Main logic and UI
│   ├── MCSessionDelegate
│   ├── MCBrowserViewControllerDelegate
│   └── MCNearbyServiceAdvertiserDelegate
└── Info.plist             # App configuration
```

## Key Components

The ViewController implements three important delegates:

1. **MCSessionDelegate**: Handles session state changes and data reception
2. **MCBrowserViewControllerDelegate**: Manages peer browsing UI
3. **MCNearbyServiceAdvertiserDelegate**: Handles incoming connection invitations

## Requirements

- Xcode
- iOS 10.0+ or macOS 10.12+
- Two or more devices for testing peer communication

## Usage

1. Run the app on multiple devices
2. Devices will automatically discover each other
3. Tap a peer to send connection invitation
4. Accept invitations on receiving device
5. Send messages between connected peers
