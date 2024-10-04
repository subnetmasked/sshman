[![Gem Version](https://img.shields.io/gem/v/sshman)](https://rubygems.org/gems/sshman)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
# 🚀 sshman: A Simple and Secure SSH Manager

sshman is a terminal-based SSH manager built with Ruby that simplifies managing your SSH connections. It enables you to easily add, edit, delete, and connect to servers with just a few commands. The tool supports SSH keys and passwords and secures your configuration with restricted file permissions.

## ✨ Features

Add SSH server configurations
List all saved servers in a neatly formatted table
Edit existing server configurations
Delete server entries by alias
Connect to servers via SSH in a single command
Security: Restricts file permissions to protect SSH keys
User-friendly CLI: Interactive, colorized terminal-based interface with built-in help

## 📦 Installation

### Using RubyGems
Install the gem locally or globally:

```shell
gem install sshman
```
###From Source

Clone the repository:

```shell
git clone https://github.com/subnetmasked/sshman.git
cd sshman
```
Build and install the gem:

```shell
gem build sshman.gemspec
gem install ./sshman-0.2.3.gem --user-install
```
## 🚀 Quick Start
After installing the gem, you can use the sshman command to manage your SSH servers.

Inline Commands
You can now run commands directly:

- sshman list - List all saved servers
- shman add - Add a new server configuration
- sshman edit - Edit an existing server
- sshman delete -  Delete a server by its alias
- sshman connect -  Connect to a server by its alias
- sshman help - Display help information

## Interactive Mode
Simply run:
```shell
sshman
```

This will launch the interactive menu where you can add, edit, delete, or connect to servers interactively.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the issues page to report bugs or request features.

- Fork the project
- Create your feature branch: git checkout -b my-new-feature
- Commit your changes: git commit -m 'Add some feature'
- Push to the branch: git push origin my-new-feature
- Submit a pull request

## 📄 License
This project is licensed under the GNU General Public License (GPL-3.0) - see the LICENSE file for details.

## 💬 Questions?
If you have any questions or need further clarification, feel free to open an issue or reach out to me at bjorke@startmail.com.
