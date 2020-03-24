#!/bin/bash

echo "# japanese setting"

apt-get install -y aptitude
aptitude reinstall -ycdbus
apt autoremove && apt-get update
apt-get install -y language-pack-ja-base  language-pack-ja
apt-get install -y ibus-mozc
