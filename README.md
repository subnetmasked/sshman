# 🚀 sshman: A Simple and Secure SSH Manager


[![Gem Version](https://badge.fury.io/rb/sshman.svg)](https://badge.fury.io/rb/sshman) [![License: GPL](https://img.shields.io/badge/License-GPL-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

**sshman** is a terminal-based SSH manager built with Ruby that simplifies managing your SSH connections. It enables you to easily add, edit, delete, and connect to servers with just a few commands. The tool supports SSH keys and passwords, and it secures your configuration with restricted file permissions.

---

## ✨ Features 

- **Add** SSH server configurations
- **List** all saved servers in a neatly formatted table
- **Edit** existing server configurations
- **Delete** server entries by alias
- **Connect** to servers via SSH in a single command
- **Security**: Restricts file permissions to protect SSH keys
- **User-friendly CLI**: Interactive, colorized terminal-based interface with built-in help

---

## 📦 Installation

### Using RubyGems

1. Install the gem locally or globally:

   ```bash
   gem install sshman
   ```

2. Or install from the local `.gem` file if you've built it yourself:

   ```bash
   gem install ./sshman-0.1.0.gem --user-install
   ```

### From Source

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/sshman.git
   cd sshman
   ```

2. Build and install the gem:

   ```bash
   gem build sshman.gemspec
   gem install ./sshman-0.1.0.gem --user-install
   ```

---

## 🚀 Quick Start

After installing the gem, you can use the `sshman` command to manage your SSH servers.

### Inline Commands

You can now run commands directly:

```bash
sshman list       # List all saved servers
sshman add        # Add a new server configuration
sshman edit       # Edit an existing server
sshman delete     # Delete a server by its alias
sshman connect    # Connect to a server by its alias
sshman help       # Display help information
```

### Interactive Mode

Simply run:

```bash
sshman
```

This will launch the interactive menu where you can add, edit, delete, or connect to servers interactively.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/VictorBjorke/sshman/issues) to report bugs or request features.

1. Fork the project
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

---

## 📄 License

This project is licensed under the **GNU General Public License (GPL-3.0)** - see the [LICENSE](LICENSE) file for details.

---

### 💬 Questions?

If you have any questions or need further clarification, feel free to open an issue or reach out to the maintainer at [bjorke@startmail.com](mailto:bjorke@startmail.com).

---
