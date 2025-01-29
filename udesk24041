# Makefile for Ubuntu 24.04 Initial Setup & Optimization

# Variables for commands
APT = sudo apt
SYSTEMCTL = sudo systemctl
RM = sudo rm
CAT = cat
CHMOD = sudo chmod
EXEC = sudo bash
# Common packages
GAMES = gnome-mahjongg gnome-mines gnome-sudoku aisleriot gnome-hearts
IMPROVEMENTS = htop vim git tmux
APPLICATIONS = chromium-browser vlc code audacity
POWERTOP = powertop tlp
PRELOAD = preload

# Targets
all: setup

setup: update_packages remove_games install_powersaving_tools configure_tlp install_powertop_systemd_service install_improvements install_commonly_used_applications install_preload cleanup_packages disable_motd finalize

# Update & Upgrade Packages
update_packages:
	@echo "Updating and upgrading packages..."
	$(APT) update && $(APT) upgrade -y

# Remove Games
remove_games:
	@echo "Removing games..."
	$(APT) remove -y $(GAMES)

# Install Power Saving Tools
install_powersaving_tools:
	@echo "Installing power saving tools..."
	$(APT) install -y $(POWERTOP)

# Configure TLP (Optional)
configure_tlp:
	@echo "Configuring TLP for power saving (Optional)..."
	$(SYSTEMCTL) enable tlp
	$(SYSTEMCTL) start tlp

# Install Powertop and systemd service
install_powertop_systemd_service:
    @echo "Installing and enabling powertop systemd service..."
    $(APT) install -y powertop
	$(CAT) > /etc/default/powertop << EOF
ENABLE_POWERTOP=true
EOF
    $(CAT) > /etc/systemd/system/powertop.service << EOF
[Unit]
Description=Powertop auto-tune
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/powertop --auto-tune
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
    $(SYSTEMCTL) daemon-reload
    $(SYSTEMCTL) enable powertop
    $(SYSTEMCTL) start powertop

# Install Improvement Tools
install_improvements:
	@echo "Installing system improvements..."
	$(APT) install -y $(IMPROVEMENTS)

# Install commonly used applications
install_commonly_used_applications:
	@echo "Installing commonly used applications"
	$(APT) install -y $(APPLICATIONS)

# Install preload
install_preload:
    @echo "Installing preload for faster application startup..."
	$(APT) install -y preload
    $(SYSTEMCTL) enable preload
	$(SYSTEMCTL) start preload

# Clean up packages
cleanup_packages:
	@echo "Cleaning up packages..."
	$(APT) autoremove -y
	$(APT) clean

# Disable the MOTD
disable_motd:
    @echo "Disabling message of the day..."
    $(RM) /etc/update-motd.d/10-help-text
    $(RM) /etc/update-motd.d/50-motd-news

# Final Message
finalize:
	@echo "----------------------------------------"
	@echo "  Initial setup and optimization complete!"
	@echo "  Reboot your system for changes to take effect."
	@echo "----------------------------------------"


.PHONY: all setup update_packages remove_games install_powersaving_tools configure_tlp install_powertop_systemd_service install_improvements install_commonly_used_applications install_preload cleanup_packages disable_motd finalize
