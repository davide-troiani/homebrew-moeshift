# MoEShift Homebrew tap

Private preparation tap for [MoEShift](https://github.com/davide-troiani/moeshift).
Both repositories remain private until the maintainer authorizes publication.

## Private preview

Authenticate Git with an account allowed to read both private repositories.
The preview follows the development branch and requires an explicit HEAD install:

```sh
brew install --HEAD davide-troiani/moeshift/moeshift
```

The source branch must include the current MoEShift application and first-launch
configuration support before the preview can be installed from GitHub.
No tagged source release has been published yet.

On first launch, `moeshift` creates `~/.config/moeshift/config.json` (or the
XDG_CONFIG_HOME equivalent) without replacing an existing file. Set model and
expert paths there. Model weights and extracted experts are not packaged.
The bundled preparation interpreter is under `$(brew --prefix moeshift)/libexec/bin/python`.

## Maintenance

The formula builds native Apple Silicon code and embeds Metal shaders. CMake is
a build dependency; Python and the project's existing GGUF dependencies are
isolated under the package prefix. Python wheels are pinned by URL and SHA-256
for CPython 3.14 on macOS arm64. The PyYAML wheel embeds LibYAML and has no
external libyaml linkage. Homebrew audit nevertheless requests an external
libyaml dependency based on the resource name; this remains a known audit finding. Keep license notices in the installed package.
There are no GitHub Actions or automatic publication jobs.

Before publication, pin a tagged MoEShift release with its source checksum and
validate a clean installation, model preparation, and real-model inference on a
Mac. That stable formula enables:

```sh
brew install davide-troiani/moeshift/moeshift
```

Checks for an installed preview:

```sh
brew test davide-troiani/moeshift/moeshift
brew audit --strict davide-troiani/moeshift/moeshift
```

The formula test verifies extraction and full byte comparison on a tiny generated
GGUF, localhost health/model discovery, first-launch configuration creation and
preservation across restarts. It does not benchmark a real model.
