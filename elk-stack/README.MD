# Docker images of ELK Stack

This examples provising Docker images with ELK Stack using Ubuntu 18.04.

## Summary

  - [Installation](#installation)

  - [Configuration](#configuration)

  - [Running](#running)

## Installation

OBS: I will go through their official download sites, so that the latest version of each utility can be downloaded.

OBS: My choice to use provisioning with Ansible, you will modify a type provision.

- [Packer](https://www.packer.io/)

- [Docker](https://www.docker.com/)

## Configuration

1. Define ELK version how environment variable what you want provision.
    ```
        $ export ELK_VERSION=version
    ```
    PS: For define environment variable in whole system, edit your *~/.bashrc* file:

    ```
        $ echo 'export ELK_VERSION=version' >> ~/.bashrc
        $ source ~/.bashrc
    ```
2. Edit versions.yml with same value of version defined in ELK_VERSION.

## Running

1. For create docker image execute following command:
    ```
        $ packer build name-image.json
    ```
2. Running container:
    ```
        $ docker run name-image:$ELK_VERSION
    ```

Thanks!