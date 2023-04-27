# msaf-yamnet

Music structure analysis with deep embeddings from a pretrained audio classifier

## Usage

```
nix run github:carlthome/msaf-yamnet
```

## Develop

```
# Clone the repo to the working directory.
nix flake clone --dest . github:carlthome/msaf-yamnet

# Show available packages.
nix flake show

# Show flake inputs.
nix flake metadata

# Run tests.
nix flake check

# Create development environment.
nix develop
```
