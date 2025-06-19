# 🌍 Liquid Galaxy Setup

This project sets up a **Liquid Galaxy** system, a multi-display visualization tool originally developed by Google, allowing an immersive panoramic view using Google Earth and other apps. This custom setup was created and tested on virtual machines using Ubuntu.

## 🖥️ System Architecture


- **Main Rig:** Controls the entire system and sends commands to slave rigs.
- **Slave Rigs:** Render synchronised Google Earth views on different screens.

## 🔧 Features

- Synchronised panoramic view using Google Earth
- Command propagation from the main to the slave rigs
- Virtual setup for multi-rig simulation
- SSH key-based secure communication
- Works on Ubuntu-based virtual machines

## 📁 Directory Structure
liquid-galaxy/
├── main-rig/
│ └── startup-scripts/
├── slave-rig-1/
├── slave-rig-2/
└── assets/
└── logos, configs, keys


## 🚀 Setup Instructions

### 1. Prerequisites

- Ubuntu 20.04 or 22.04
- Minimum 3 virtual machines (or physical systems)
- Internet connection
- Google Earth Pro installed
- SSH is configured with key-based authentication

### 2. Installation

#### Main Rig

Launch Process
Start the slave machines first.

Launch the master rig and run:
./start-liquid-galaxy.sh


