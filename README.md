# Solarwinds OpenTelemetry PHP Autoinstrumentation

Builds the Solarwinds OpenTelemetry PHP autoinstrumentation image published to GitHub Container Registry.

## What it builds

- PHP 8.1, 8.2, 8.3, 8.4, and 8.5
- glibc and musl variants
- ZTS and non-ZTS variants

## Build locally

The `final` target is configured as a multi-platform build (see `docker-bake.hcl`), so depending on your Buildx driver you may need to select a single platform and/or set an output (e.g., `--load`) to get a runnable local image.

    docker buildx bake

Build and push:

```bash
docker buildx bake --push
```

Build extension artifacts for a single variant (intermediate build target; does not build/tag the final image):

    docker buildx bake build-non-zts-81

Override the release version and tag:

```bash
APM_EXT_VERSION=2.0.0 OPENTELEMETRY_VERSION=1.4.2 TAG=1.4.2 docker buildx bake 
```

## Release flow

Create and push a version tag:

```bash
git tag 1.0.0
git push origin 1.0.0
```

GitHub Actions builds each PHP variant in a separate matrix runner and uploads
the `/build` output as an OCI layout using Actions artifacts, retained for one
day. The assembly job downloads these layouts and selects the matching
architecture automatically, preserving file permissions. Only the final image
is pushed to GHCR after all variants succeed.

## Files

- `Dockerfile` builds each PHP/platform variant
- `Dockerfile.final` assembles the release image
- `docker-bake.hcl` defines the matrix and image tags
- `docker-bake.ci.hcl` configures CI artifact exports and local OCI layout assembly
- `.github/workflows/build.yml` runs CI builds and pushes
- `.github/dependabot.yml` keeps dependencies updated
