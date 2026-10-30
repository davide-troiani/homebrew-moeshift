# MoEShift Homebrew tap

Private preparation tap for [MoEShift](https://github.com/davide-troiani/moeshift).
Both repositories remain private until the maintainer authorizes publication.

## Private alpha installation

The formula pins `v0.1.0-alpha.1` to its exact source revision. Both repositories
remain private, so authenticate with GitHub CLI using an account that can read
both repositories, then install:

```sh
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token --hostname github.com)" \
  brew install davide-troiani/moeshift/moeshift
```

The token is passed only to this command. Once both repositories are public,
installation requires no authentication:

```sh
brew install davide-troiani/moeshift/moeshift
```

Use `--HEAD` only to explicitly select the development branch instead of the
versioned alpha. Creating the source tag does not publish the GitHub draft release.

On first launch, `moeshift` creates `~/.config/moeshift/config.json` (or the
XDG_CONFIG_HOME equivalent) without replacing an existing file. Set model and
expert paths there. Model weights and extracted experts are not packaged.
The bundled preparation interpreter is under `$(brew --prefix moeshift)/libexec/bin/python`.

## Maintenance

The formula builds native Apple Silicon code and embeds Metal shaders. CMake is
a build dependency; Python and the project's existing GGUF dependencies are
isolated under the package prefix. Resources are pinned by URL and SHA-256.
PyYAML is compiled from source against Homebrew LibYAML; its Setuptools and
Cython build helpers are isolated in a temporary environment and are not installed
with the runtime. Other Python wheels target CPython 3.14 on macOS arm64.
Keep license notices in the installed package.
There are no GitHub Actions or automatic publication jobs.

Before publishing the alpha, validate model preparation and real-model inference
on the installed package. Future versions must update both the tag and pinned
source revision; never move a released tag. No prebuilt bottle is provided yet.

Checks for an installed preview:

```sh
brew test davide-troiani/moeshift/moeshift
brew audit --strict davide-troiani/moeshift/moeshift
```

The formula test verifies extraction and full byte comparison on a tiny generated
GGUF, localhost health/model discovery, first-launch configuration creation and
preservation across restarts. It does not benchmark a real model.
