<h1 align="start">SecPass</h1>

<p align="start">
  <strong>Local-only password manager for iOS with an optional on-device Vision feature to temporarily conceal sensitive data if multiple people are looking at your screen.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS_26+-000000?style=for-the-badge&logo=apple" alt="iOS" />
  <img src="https://img.shields.io/badge/Language-Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift" />
  <img src="https://img.shields.io/badge/License-AGPL--3.0-important?style=for-the-badge" alt="AGPL-3.0" />
</p>

<hr/>

<h3 align="start">Core Idea</h3>

<p align="start" style="max-width: 700px; margin: 0 auto;">
  SecPass is a local-only password manager that keeps all data <strong>on-device</strong>, using Apple's secure
  cryptographic frameworks. An optional Vision-based feature uses the camera to detect multiple faces near the screen
  and temporarily conceals sensitive information to reduce shoulder-surfing risk.
</p>

<hr/>

<h4>Screenshots</h4>

<p align="center" style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
    <img src="https://github.com/jorgelso/EncryptionApp/blob/main/Photo1.PNG" width="30%" />
</p>

<hr/>

<h4>Features</h4>

<ul>
  <li><strong>Local-only storage:</strong> all data stays on-device; no servers, no syncing, no telemetry.</li>
  <li><strong>Encrypted at rest:</strong> passwords and secrets are stored using Apple's cryptographic frameworks.</li>
  <li><strong>Vision-based protection:</strong> optional camera-powered detection of multiple faces near the screen to hide sensitive content.</li>
  <li><strong>Offline-first:</strong> the app does not rely on any network connectivity or external APIs.</li>
  <li><strong>SwiftUI interface:</strong> modern, minimal UI with a small attack surface.</li>
  <li><strong>No third-party services.</strong></li>
</ul>

<hr/>

<h4>Technologies Used</h4>

<p align="center" style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="https://img.shields.io/badge/SwiftUI-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="SwiftUI" />
  <img src="https://img.shields.io/badge/SwiftData-4B8BBE?style=for-the-badge" alt="SwiftData" />
  <img src="https://img.shields.io/badge/CryptoKit-007ACC?style=for-the-badge" alt="CryptoKit" />
  <img src="https://img.shields.io/badge/Security_Framework-4A90E2?style=for-the-badge" alt="Security" />
  <img src="https://img.shields.io/badge/CommonCrypto-6C757D?style=for-the-badge" alt="CommonCrypto" />
  <img src="https://img.shields.io/badge/Vision-007BFF?style=for-the-badge" alt="Vision" />
  <img src="https://img.shields.io/badge/Foundation-555555?style=for-the-badge" alt="Foundation" />
</p>

<h4>Privacy</h4>

<p>
  SecPass is designed with a strict local-only privacy model:
</p>

<ul>
  <li>All data is stored exclusively on the device.</li>
  <li>No remote servers, accounts, or cloud syncing.</li>
  <li>Camera frames used for Vision are processed in-memory only and never stored or transmitted.</li>
  <li>Removing the app from the device deletes all stored data.</li>
</ul>

<hr/>

<h4>Building the App</h4>

<ol>
  <li>Open the project in <strong>Xcode 15</strong> or later.</li>
  <li>Select an iOS 26+ simulator or a physical device.</li>
  <li>Build &amp; run from Xcode.</li>
  <p>To test the Vision-based concealment feature, grant camera permissions when prompted.</p>
</ol>

<p>
  No additional configuration, backend, or third-party keys are required for this snapshot.
</p>

<hr/>

<h4>License</h4>

<p>
  This repository is released under the <strong>GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)</strong>.
  By using, modifying, or redistributing this code, you agree to the terms of the AGPL.
</p>

<p>
  See the <code>LICENSE</code> file for the full text.
</p>

<hr/>

<h4>Notes</h4>

<p>
  This repository is a public AGPL snapshot of the project, intended for code review and study.
</p>
