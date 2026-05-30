# SVX-Link EN AU Sound Files

Audio files for SVX-Link configured for English (Australian) language support.

## Description

This repository contains sound files and audio resources for SVX-Link, customized for Australian English language settings.

## Usage

These sound files are intended to be used with SVX-Link configuration. Place the audio files in the appropriate SVX-Link sound directory as per your installation.

## Contents

- Sound files for Australian English announcements and prompts
- Audio resources for system notifications and responses

## Installation

1. Clone or download this repository
2. Copy the sound files to your SVX-Link sound directory
3. Configure SVX-Link to use the Australian English sound set

## License

Please refer to the LICENSE file in this repository for licensing information.
# Online TTS Integration for SvxLink en_AU

This document describes how to use the online Text-to-Speech (TTS) functionality integrated with the SvxLink sound processing system.

## Overview

The `tts_handler.sh` script generates audio clips from text using online TTS services or local engines, then applies the same audio processing filters used by the static sound clip system.

## Installation

### Prerequisites

- `sox` - Sound eXchange audio tool
- `curl` - For API requests to cloud TTS services
- One of the following for local TTS:
  - `espeak` - Lightweight local TTS
  - `festival` - More advanced local TTS
  - Or cloud API credentials for Google, Azure, or AWS

### Setup Steps

1. Copy `tts_handler.sh` and `tts_handler.cfg` to the sound directory
2. Make the script executable: `chmod +x tts_handler.sh`
3. Configure `tts_handler.cfg` with your preferred TTS provider

## Configuration

Edit `tts_handler.cfg` to set:

### Google Cloud TTS
```ini
TTS_PROVIDER="google"
GOOGLE_API_KEY="your-api-key"
GOOGLE_LANGUAGE="en-AU"

## Contributing

Contributions are welcome. Please submit pull requests or issues for improvements or corrections.

## Support

For issues or questions related to these sound files, please open an issue in this repository.

---

*SVX-Link EN AU Sound files repository*
