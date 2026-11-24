# MoEShift Homebrew Tap

Official Homebrew tap for [MoEShift](https://github.com/davide-troiani/moeshift), a memory-efficient Mixture-of-Experts inference engine for Apple Silicon.

## Installation

Requires macOS on Apple Silicon (M-series) and [Homebrew](https://brew.sh/).

Install MoEShift with:

```sh
brew install davide-troiani/moeshift/moeshift
```

The current formula installs **v0.1.0-alpha.6**.

MoEShift is built from source with Metal support. Prebuilt Homebrew bottles are not currently provided.

## Getting started

Launch MoEShift once:

```sh
moeshift
```

On first launch, use the arrow keys and Enter to select a tested model. Drag in an existing GGUF or download it with progress and ETA. The wizard prepares experts, saves the configuration and starts the local API.

Downloads and prepared experts live under `~/.moeshift/models/`. GGUF files supplied by the user stay in place. Subsequent launches use the saved configuration.

Choose **Manual configuration** to create a base JSON file and follow the linked setup guide. Existing configurations remain available after upgrading.

For other supported GGUF models, set the model path and alias in the JSON configuration. SSD streaming uses matching prepared experts. See the [configuration guide](https://github.com/davide-troiani/moeshift/blob/main/configs/README.md).

See the [MoEShift README](https://github.com/davide-troiani/moeshift#readme) for tested models and client setup.

## Updates

Update Homebrew and upgrade MoEShift when a new formula version becomes available:

```sh
brew update
brew upgrade davide-troiani/moeshift/moeshift
```

## Release status

MoEShift is currently in alpha. The runtime is functional, but features, performance and compatibility may change.

See the [GitHub releases](https://github.com/davide-troiani/moeshift/releases) for published versions and release notes.

## Maintainer notes

The formula pins the release archive and Python resources with SHA-256 checksums.

For each new release, update the archive URL and checksum. Preserve previously published tags.

The formula includes automated checks for GGUF expert extraction and verification, local server endpoints, and first-launch configuration behavior. These checks do not replace inference testing with a real model.

Validate the installed package with:

```sh
brew test davide-troiani/moeshift/moeshift
brew audit --strict davide-troiani/moeshift/moeshift
```

The package includes a dedicated Python environment for model preparation tools under `$(brew --prefix moeshift)/libexec`.

## License

MoEShift is distributed under the [MIT License](https://github.com/davide-troiani/moeshift/blob/main/LICENSE).
