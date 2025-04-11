# Contributing to macOS Theme Suite for Linux

First off, thank you for considering contributing to this project! 🎉

We welcome contributions from everyone. Here are some ways you can contribute:

- Reporting bugs
- Suggesting enhancements
- Writing code (fixing bugs, adding features)
- Improving documentation
- Submitting translations

## Reporting Bugs

If you find a bug, please open an issue on GitHub. Include the following information:

- Your Linux distribution and version (e.g., Ubuntu 22.04)
- Your desktop environment (e.g., GNOME, XFCE)
- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Any relevant screenshots

## Suggesting Enhancements

If you have an idea for a new feature or an improvement to an existing one, please open an issue on GitHub. Describe your idea clearly and explain why you think it would be beneficial.

## Pull Requests

We welcome pull requests! Here's how to submit one:

1.  **Fork the repository** on GitHub.
2.  **Clone your fork** locally: `git clone https://github.com/yourusername/macos-theme-for-linux.git`
3.  **Create a new branch** for your changes: `git checkout -b feature/your-feature-name` or `fix/your-bug-fix-name`
4.  **Make your changes.** Ensure your code follows the project's style guidelines (if any).
5.  **Test your changes** thoroughly.
6.  **Commit your changes** with a clear and descriptive commit message: `git commit -m "feat: Add new amazing feature"` (See [Conventional Commits](https://www.conventionalcommits.org/) for guidance).
7.  **Push your branch** to your fork: `git push origin feature/your-feature-name`
8.  **Open a pull request** from your fork's branch to the `main` branch of the original repository.
9.  **Describe your changes** in the pull request description. Explain the problem you solved or the feature you added. Link to any relevant issues.

## Development Setup

If you plan to contribute code, you might need the following dependencies (already handled by `install.sh` for users):

- `git`
- `sassc`
- `libglib2.0-dev-bin` (or equivalent for your distribution)
- `wget`, `curl`, `unzip`

You can run the installation script locally during development, but be mindful of changes it makes to your system theme settings.

## Code Style

- Follow existing code patterns.
- Use clear variable and function names.
- Add comments where necessary to explain complex logic.
- Keep shell scripts POSIX-compliant where possible, or clearly state Bash-specific requirements.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

Thank you for contributing!
