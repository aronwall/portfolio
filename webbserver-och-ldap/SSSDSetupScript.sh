#!/bin/bash

# ==============================================================================
# SSSD & LDAP Client Setup Script for Ubuntu 24.04
# ==============================================================================
# Run this script with sudo!
# ==============================================================================

# --- 1. CONFIGURATION VARIABLES ---
# Change these to match your LDAP server's IP and your domain structure.
LDAP_SERVER_IP="172.30.174.86"
LDAP_BASE_DN="dc=tenta,dc=labb"

echo "Starting LDAP Client setup..."

# --- 2. INSTALL REQUIRED PACKAGES ---
# sssd: The main daemon.
# sssd-tools: Utilities for managing SSSD caches.
# libnss-sss & libpam-sss: The plugins that tell Ubuntu to use SSSD for logins.
# ldap-utils: Gives us ldapsearch on the client for troubleshooting.
echo "Installing SSSD and LDAP utilities..."
apt update
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y sssd sssd-tools libnss-sss libpam-sss ldap-utils

# --- 3. CONFIGURE SSSD ---
# We are creating the sssd.conf file from scratch.
# The "cat <<EOF" command writes everything between here and "EOF" directly into the file.
echo "Creating /etc/sssd/sssd.conf..."

cat <<EOF > /etc/sssd/sssd.conf
[sssd]
# SSSD can handle multiple domains and services. 
# We are enabling NSS (Name Service Switch - for resolving users) 
# and PAM (Pluggable Authentication Modules - for passwords).
config_file_version = 2
services = nss, pam
domains = default

[nss]
# Makes it so that logging in on the local root account always bypasses LDAP.
filter_users = root
filter_groups = root

[pam]
# Allows users to log in even if the LDAP server briefly goes offline (uses cached passwords)
offline_credentials_pass = true

[domain/default]
# This tells SSSD we are using a standard LDAP server (not Active Directory or FreeIPA).
id_provider = ldap
auth_provider = ldap

# Network connection settings
ldap_uri = ldap://$LDAP_SERVER_IP
ldap_search_base = $LDAP_BASE_DN

# Schema setting: rfc2307 matches standard OpenLDAP posixAccount and posixGroup structures.
ldap_schema = rfc2307

# Allows unecrypted connections, which is usually not allowed.
ldap_tls_reqcert = never

# Cache settings
cache_credentials = true
enumerate = false
EOF

# --- 4. SECURE THE CONFIGURATION ---
# Set owner and permissions, which is required by SSSD
echo "Setting strict permissions on sssd.conf..."
chown root:root /etc/sssd/sssd.conf
chmod 600 /etc/sssd/sssd.conf

# --- 5. ENABLE AUTOMATIC HOME DIRECTORIES ---
# Makes it so that a home directory is created the first time a user logs in with SSSD.
echo "Configuring PAM to automatically create home directories..."
pam-auth-update --enable mkhomedir

# --- 6. CONFIGURE LDAP CLIENT TOOLS (/etc/ldap/ldap.conf) ---
# This ensures that commands like 'ldapsearch' and 'ldapwhoami'
# work without having to type the server URI and Base DN every time.
echo "Configuring LDAP client tools in /etc/ldap/ldap.conf..."

cat <<EOF > /etc/ldap/ldap.conf
# LDAP Public Configuration
# This file is used by the ldap-utils (ldapsearch, etc.)
BASE    $LDAP_BASE_DN
URI     ldap://$LDAP_SERVER_IP

# Require a specific search scope (optional, but good practice)
SIZELIMIT      12
TIMELIMIT      15
DEREF          never
EOF

# --- 7. START AND ENABLE THE SERVICE ---
# Restart SSSD to apply our new configuration, and enable it to start on boot.
echo "Restarting and enabling SSSD service..."
systemctl restart sssd
systemctl enable sssd

echo "=============================================================================="
echo "Setup complete! SSSD is running and configured to talk to ldap://$LDAP_SERVER_IP"
echo "=============================================================================="