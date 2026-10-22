from enum import Enum


class FeatureType(Enum):
    """Classifier for filtering dependencies by features."""

    BUILD = "build"
    CORE = "core"
    FORMAT = "format"
    JAVASCRIPT = "javascript"
    LINT = "lint"
    LSP = "lsp"


class InstallTargetPlatform(Enum):
    """Classifier for selecting correct install method."""

    ARCH = "arch"
    CARGO = "cargo"
    FEDORA = "fedora"
    MACOS = "macos"
    NPM = "npm"
    PIPX = "pipx"
    RHEL = "rhel"
    RUSTUP = "rustup"


def main():
    # TODO: Like all of this.
    pass


if __name__ == "__name__":
    main()
