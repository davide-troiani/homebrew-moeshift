# MoEShift Homebrew Tap

Official Homebrew tap for [MoEShift](https://github.com/davide-troiani/moeshift), a memory-efficient Mixture-of-Experts inference engine for Apple Silicon.

## Installation

Requires macOS on Apple Silicon (M-series) and [Homebrew](https://brew.sh/).

Install MoEShift with:

```sh
brew install davide-troiani/moeshift/moeshift
```

The current formula installs **v0.1.0-alpha.1**, the first public alpha release.

MoEShift is built from source with Metal support. Prebuilt Homebrew bottles are not currently provided.

## Getting started

Launch MoEShift once:

```sh
moeshift
```

On first launch, MoEShift creates `~/.config/moeshift/config.json` (or the equivalent `XDG_CONFIG_HOME` path) without overwriting existing settings.

Stop the server with Ctrl-C, then configure the model and expert paths before restarting.

Model weights and extracted experts are not included in the Homebrew package.

For model downloads, expert extraction, configuration and usage instructions, see the [MoEShift README](https://github.com/davide-troiani/moeshift#readme).

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

The formula pins the release tag and exact source revision. Python resources are pinned with SHA-256 checksums.

For each new release, update the formula's tag and revision without modifying previously published tags.

The formula includes automated checks for GGUF expert extraction and verification, local server endpoints, and first-launch configuration behavior. These checks do not replace inference testing with a real model.

Validate the installed package with:

```sh
brew test davide-troiani/moeshift/moeshift
brew audit --strict davide-troiani/moeshift/moeshift
```

The package includes a dedicated Python environment for model preparation tools under `$(brew --prefix moeshift)/libexec`.

## License

MoEShift is distributed under the [MIT License](https://github.com/davide-troiani/moeshift/blob/main/LICENSE).
