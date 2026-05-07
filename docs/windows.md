# Using these dot-files in Windows

This document provides instructions on how to use some of the configurations within this repository on a Windows system. While these dot-files are primarily designed for Arch/EndeavourOS, certain components like Neovim can be easily synchronized.

## Neovim

You can synchronize the Neovim configuration between this repository and your Windows machine using the provided PowerShell scripts in the root directory.

### Applying Configuration to Windows

To copy the Neovim configuration from this repository to your local Windows configuration directory (`%LOCALAPPDATA%\nvim`), run:

```powershell
.\get_nvim_config_win.ps1
```

The script will perform a dry run first and ask for confirmation before making any changes.

### Updating Repository from Windows

If you have made changes to your Neovim configuration on Windows and want to save them back to this repository, run:

```powershell
.\put_nvim_config_win.ps1
```

This script also performs a dry run and requires confirmation.
