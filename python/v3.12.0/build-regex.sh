#!/usr/bin/env bash

if [[ ! -v WLR_ENV ]]; then
  echo "WLR build environment is not set"
  exit 1
fi

pyenv local ${WLR_PY_BUILDER_VERSION}

# Download the regex package
curl -L https://files.pythonhosted.org/packages/source/r/regex/regex-2019.11.1.tar.gz -o regex-2019.11.1.tar.gz

# Extract the package
tar -xvf regex-2019.11.1.tar.gz
cd regex-2019.11.1

# Set up the cross-compilation environment
export CC="wasi-clang"
export LD="wasi-clang"
export CFLAGS="-target wasm32-wasi --sysroot /opt/wasi-sdk/share/wasi-sysroot"
export LDFLAGS="-target wasm32-wasi --sysroot /opt/wasi-sdk/share/wasi-sysroot"

# Create a setup.cfg file to tell distutils to use the cross-compiler
cat > setup.cfg << EOL
[build]
compiler=clang
[build_ext]
plat_name=wasi
EOL

# Build and install the package
pip install . --target "${WLR_SOURCE_PATH}/Lib"