# Docker Laravel

🚀 Exciting News for Laravel Developers! 🌟

🎉 I'm thrilled to announce a comprehensive Laravel Development Environment now available for you! Crafted meticulously
using Docker containers, this environment is a game-changer for developers looking to streamline their workflow.

### Key Features Include:

- 🌐 **Nginx Reverse Proxy with SSL:** Enjoy secure browsing with self-signed certificates.
- ⚡ **PHP-FPM & Vite Integration:** Experience enhanced performance and speed.
- 💾 **Robust Data Handling:** Comes equipped with Redis, MySQL, and phpMyAdmin.
- 🛠️ **Dev Service Container:** A dedicated container to cater to your development needs.

### Work in Progress:

We're constantly improving! Currently focusing on:

- 📚 **Comprehensive Documentation** for ease of use.
- ⚙️ **Performance Optimization** for a smoother experience.
- 📡 **Integration of Websockets** for real-time data communication.
- 🔧 **Adding Additional Configuration** options for customization.

🔗 Find all the details and get started here: https://github.com/CRISvsGAME/docker-laravel

Whether you're a seasoned Laravel developer or just starting, this environment is designed to enhance your coding
experience. Let's make development more efficient and fun!

💬 Feel free to reach out with feedback or questions. Let's collaborate and grow together!

👍 Happy Coding, Everyone!

## Quick Start

### Requirements

- Install [Docker](https://docs.docker.com)
    - Install for Ubuntu: [Docker for Ubuntu](https://github.com/CRISvsGAME/ubuntu-packages/tree/main/docker)
- Install [Git](https://git-scm.com/downloads)
    - Install for Ubuntu: [Git for Ubuntu](https://github.com/CRISvsGAME/ubuntu-packages/tree/main/git)

**Optional:**

- Connecting to **GitHub** with
  SSH: [Generating SSH Keys](https://github.com/CRISvsGAME/ubuntu-packages/tree/main/github)
- Adding a new SSH key to your **GitHub**
  account: [Adding SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

### Installation

```
# Create your "project" directory
mkdir project && cd project
```

```
# Option 1: Clone with HTTPS
git clone https://github.com/CRISvsGAME/docker-laravel.git .
```

```
# Option 2: Clone with SSH
git clone git@github.com:CRISvsGAME/docker-laravel.git .
```

```
# Edit .env & Run Docker Compose
docker compose up -d
```
