# Copyright SolarWinds Worldwide, LLC.
# SPDX-License-Identifier: Apache-2.0

# docker-bake.hcl — drives all PHP extension builds + final image assembly.
#
# Build the final image:        docker buildx bake
# Build and push:               docker buildx bake --push
# Build a single variant:       docker buildx bake build-non-zts-81
# Override opentelemetry version or tag:      OPENTELEMETRY_VERSION=1.4.2 TAG=1.4.2 docker buildx bake

variable "OPENTELEMETRY_VERSION" {
  # Override at build time: OPENTELEMETRY_VERSION=1.4.2 docker buildx bake
  default = "1.4.2"
}

variable "APM_EXT_VERSION" {
  # Override at build time: APM_EXT_VERSION=2.0.0 docker buildx bake
  default = "2.0.0"
}


variable "IMAGE_NAME" {
  default = "autoinstrumentation-php"
}

variable "TAG" {
  default = "latest"
}

# ---------------------------------------------------------------------------
# Pinned PHP base images — update SHAs here when upgrading PHP versions.
# To add a new PHP version, add four variables below and four targets further
# down, then add four COPY lines to Dockerfile.final.
# ---------------------------------------------------------------------------

# PHP 8.1
variable "PHP_81_NON_ZTS"      { default = "php:8.1@sha256:76e563191d1ade120313a8736df24154d21da5155c0756f147c0b01bd19d9087" }
variable "PHP_81_ZTS"          { default = "php:8.1-zts@sha256:113088c9c240ccfb16c45834cb1df50b2bc6f414638cd16a72ab7a5b03681329" }
variable "PHP_81_MUSL_NON_ZTS" { default = "php:8.1-alpine@sha256:7949370448b0b4d9787776dc5968e0fd8d48763292344b5fbf21539441228a98" }
variable "PHP_81_MUSL_ZTS"     { default = "php:8.1-zts-alpine@sha256:f36160602456091e5a8f656a2f5c8e68435c36284856fa4116a46e00f38dc04b" }

# PHP 8.2
variable "PHP_82_NON_ZTS"      { default = "php:8.2@sha256:118ef4fb1db5e866fb604f2f260da81f819a0a1eac87a4083f9194f48e00beee" }
variable "PHP_82_ZTS"          { default = "php:8.2-zts@sha256:1e8d8c8bce6dbba31182667bf1503277216895bb89a49d38660299b31cbe96ac" }
variable "PHP_82_MUSL_NON_ZTS" { default = "php:8.2-alpine@sha256:0814a91662f32e59ba3092a443ebb4b9915f3320b1b4688650dfc38939c6ff59" }
variable "PHP_82_MUSL_ZTS"     { default = "php:8.2-zts-alpine@sha256:0d7c08a1699e0c356a87a038473567b2eac41e0088d13619f46aa0a3a8213eef" }

# PHP 8.3
variable "PHP_83_NON_ZTS"      { default = "php:8.3@sha256:aafe21201943a8a6e497ddfb471e2ce68ada76adede38c7d61fede8918b24319" }
variable "PHP_83_ZTS"          { default = "php:8.3-zts@sha256:4f3147519f9a018fcaec361c8919fa5efba3003c75314965609b805fffca7ab6" }
variable "PHP_83_MUSL_NON_ZTS" { default = "php:8.3-alpine@sha256:8dbeb51c352cf1f70d5d50f3642c9fbed311e914475ea2382f5bc1525bef7bb3" }
variable "PHP_83_MUSL_ZTS"     { default = "php:8.3-zts-alpine@sha256:51b48f507d20611feedf88bb901ea8b26d98718d82a2bd5cf8cb472f302f54d4" }

# PHP 8.4
variable "PHP_84_NON_ZTS"      { default = "php:8.4@sha256:1d2cf2b7d715b5b3aa959f0150ccbcc7b71e0181b637e443abf40a7fb56bf79a" }
variable "PHP_84_ZTS"          { default = "php:8.4-zts@sha256:6945f3138d7076ba5567acee0399db54d4f5e39ed2548555b6ffcad3fcfeb44c" }
variable "PHP_84_MUSL_NON_ZTS" { default = "php:8.4-alpine@sha256:37c8c64177612b72e7f9d2c00481739c166a3708bea27c1cfd27fea1291d82d1" }
variable "PHP_84_MUSL_ZTS"     { default = "php:8.4-zts-alpine@sha256:85e0f7b274a5b0cbdd6889332458352e801c6840f32d5bab8063b419c9581282" }

# PHP 8.5
variable "PHP_85_NON_ZTS"      { default = "php:8.5@sha256:01a109229f4465bc9ef042d9198f09a4d9da7775a825dbd8572dcdbd8756c4d3" }
variable "PHP_85_ZTS"          { default = "php:8.5-zts@sha256:9a358d8de4a52ea343e77f50311342ddaae2c42ac11e3defbf364e9c4f490cb9" }
variable "PHP_85_MUSL_NON_ZTS" { default = "php:8.5-alpine@sha256:93684051146ec037620855feb77f278090bde45ddc030801cd3f2a7685bc4deb" }
variable "PHP_85_MUSL_ZTS"     { default = "php:8.5-zts-alpine@sha256:1c45229fd82d57ae54104a0930fb58c635bbfe81dc156971eeaf7993bc59db32" }

# ---------------------------------------------------------------------------
# Shared base target — all build targets inherit from this.
# ---------------------------------------------------------------------------
target "_build-base" {
  dockerfile = "Dockerfile"
  target     = "builder"
  context    = "."
  args       = { OPENTELEMETRY_VERSION = OPENTELEMETRY_VERSION, APM_EXT_VERSION = APM_EXT_VERSION }
  output     = []
}

# ---------------------------------------------------------------------------
# Per-variant build targets
# ---------------------------------------------------------------------------

# PHP 8.1
target "build-non-zts-81" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_81_NON_ZTS, LIBC = "glibc", THREAD = "non-zts" }
}
target "build-zts-81" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_81_ZTS, LIBC = "glibc", THREAD = "zts" }
}
target "build-non-zts-musl-81" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_81_MUSL_NON_ZTS, LIBC = "musl", THREAD = "non-zts" }
}
target "build-zts-musl-81" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_81_MUSL_ZTS, LIBC = "musl", THREAD = "zts" }
}

# PHP 8.2
target "build-non-zts-82" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_82_NON_ZTS, LIBC = "glibc", THREAD = "non-zts" }
}
target "build-zts-82" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_82_ZTS, LIBC = "glibc", THREAD = "zts" }
}
target "build-non-zts-musl-82" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_82_MUSL_NON_ZTS, LIBC = "musl", THREAD = "non-zts" }
}
target "build-zts-musl-82" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_82_MUSL_ZTS, LIBC = "musl", THREAD = "zts" }
}

# PHP 8.3
target "build-non-zts-83" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_83_NON_ZTS, LIBC = "glibc", THREAD = "non-zts" }
}
target "build-zts-83" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_83_ZTS, LIBC = "glibc", THREAD = "zts" }
}
target "build-non-zts-musl-83" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_83_MUSL_NON_ZTS, LIBC = "musl", THREAD = "non-zts" }
}
target "build-zts-musl-83" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_83_MUSL_ZTS, LIBC = "musl", THREAD = "zts" }
}

# PHP 8.4
target "build-non-zts-84" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_84_NON_ZTS, LIBC = "glibc", THREAD = "non-zts" }
}
target "build-zts-84" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_84_ZTS, LIBC = "glibc", THREAD = "zts" }
}
target "build-non-zts-musl-84" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_84_MUSL_NON_ZTS, LIBC = "musl", THREAD = "non-zts" }
}
target "build-zts-musl-84" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_84_MUSL_ZTS, LIBC = "musl", THREAD = "zts" }
}

# PHP 8.5
target "build-non-zts-85" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_85_NON_ZTS, LIBC = "glibc", THREAD = "non-zts" }
}
target "build-zts-85" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_85_ZTS, LIBC = "glibc", THREAD = "zts" }
}
target "build-non-zts-musl-85" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_85_MUSL_NON_ZTS, LIBC = "musl", THREAD = "non-zts" }
}
target "build-zts-musl-85" {
  inherits = ["_build-base"]
  args = { PHP_IMAGE = PHP_85_MUSL_ZTS, LIBC = "musl", THREAD = "zts" }
}

# ---------------------------------------------------------------------------
# Final image — assembles all build artifacts into a single busybox image.
# ---------------------------------------------------------------------------
target "final" {
  dockerfile = "Dockerfile.final"
  context    = "."
  platforms  = ["linux/amd64","linux/arm64","linux/s390x","linux/ppc64le"]
  tags       = ["${IMAGE_NAME}:${TAG}"]
  contexts = {
    build-non-zts-81      = "target:build-non-zts-81"
    build-zts-81          = "target:build-zts-81"
    build-non-zts-musl-81 = "target:build-non-zts-musl-81"
    build-zts-musl-81     = "target:build-zts-musl-81"
    build-non-zts-82      = "target:build-non-zts-82"
    build-zts-82          = "target:build-zts-82"
    build-non-zts-musl-82 = "target:build-non-zts-musl-82"
    build-zts-musl-82     = "target:build-zts-musl-82"
    build-non-zts-83      = "target:build-non-zts-83"
    build-zts-83          = "target:build-zts-83"
    build-non-zts-musl-83 = "target:build-non-zts-musl-83"
    build-zts-musl-83     = "target:build-zts-musl-83"
    build-non-zts-84      = "target:build-non-zts-84"
    build-zts-84          = "target:build-zts-84"
    build-non-zts-musl-84 = "target:build-non-zts-musl-84"
    build-zts-musl-84     = "target:build-zts-musl-84"
    build-non-zts-85      = "target:build-non-zts-85"
    build-zts-85          = "target:build-zts-85"
    build-non-zts-musl-85 = "target:build-non-zts-musl-85"
    build-zts-musl-85     = "target:build-zts-musl-85"
  }
}

group "default" {
  targets = ["final"]
}
