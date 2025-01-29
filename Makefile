# Makefile for Ubuntu 24.04 Initial Setup & Optimization

# Variables for commands
APT = sudo apt
SYSTEMCTL = sudo systemctl
RM = sudo rm
CAT = cat
CHMOD = sudo chmod
EXEC = sudo bash
ECHO = echo
DATE = date
TOUCH = touch

# Common packages
GAMES = gnome-mahjongg gnome-mines gnome-sudoku aisleriot gnome-hearts
IMPROVEMENTS = htop vim git tmux
APPLICATIONS = chromium-browser vlc code audacity
POWERTOP = powertop tlp
PRELOAD = preload

# Log file
LOG_FILE = setup.log

# Helper function to log messages to terminal and log file
log = $(ECHO) "$$( $(DATE) '+%Y-%m-%d %H:%M:%S' ): $*" | tee -a $(LOG_FILE)

# Function to check if a command is successful and log errors if not
check_cmd = $(if $(shell $(1) 2>&1 | grep -q -v "0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded"),\
              $(log) "Error: Command failed: '$(1)'",\
	       $(log) "Command successful: '$(1)'")

# Targets
all: setup

setup: update_packages remove_games install_powersaving_tools configure_tlp install_powertop_systemd_service install_improvements install_commonly_used_applications install_preload cleanup_packages disable_motd finalize

# Update & Upgrade Packages
update_packages:
	@$(log) "Updating and upgrading packages..."
	@$(check_cmd) "$(APT) update"
	@$(check_cmd) "$(APT) upgrade -y"

# Remove Games
remove_games:
	@$(log) "Removing games..."
	@$(check_cmd) "$(APT) remove -y $(GAMES)"

# Install Power Saving Tools
install_powersaving_tools:
	@$(log) "Installing power saving tools..."
	@$(check_cmd) "$(APT) install -y $(POWERTOP)"

# Configure TLP (Optional)
configure_tlp:
	@$(log) "Configuring TLP for power saving (Optional)..."
	@$(check_cmd) "$(SYSTEMCTL) enable tlp"
	@$(check_cmd) "$(SYSTEMCTL) start tlp"

# Install Powertop and systemd service
install_powertop_systemd_service:
    @$(log) "Installing and enabling powertop systemd service..."
    @$(check_cmd) "$(APT) install -y powertop"
    @$(check_cmd) $(CAT) > /etc/default/powertop << EOF
ENABLE_POWERTOP=true
EOF
    @$(check_cmd) $(CAT) > /etc/systemd/system/powertop.service << EOF
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
    @$(check_cmd) "$(SYSTEMCTL) daemon-reload"
    @$(check_cmd) "$(SYSTEMCTL) enable powertop"
    @$(check_cmd) "$(SYSTEMCTL) start powertop"

# Install Improvement Tools
install_improvements:
	@$(log) "Installing system improvements..."
	@$(check_cmd) "$(APT) install -y $(IMPROVEMENTS)"

# Install commonly used applications
install_commonly_used_applications:
	@$(log) "Installing commonly used applications"
	@$(check_cmd) "$(APT) install -y $(APPLICATIONS)"

# Install preload
install_preload:
    @$(log) "Installing preload for faster application startup..."
	@$(check_cmd) "$(APT) install -y $(PRELOAD)"
	@$(check_cmd) "$(SYSTEMCTL) enable preload"
	@$(check_cmd) "$(SYSTEMCTL) start preload"

# Clean up packages
cleanup_packages:
	@$(log) "Cleaning up packages..."
	@$(check_cmd) "$(APT) autoremove -y"
	@$(check_cmd) "$(APT) clean"

# Disable the MOTD
disable_motd:
    @$(log) "Disabling message of the day..."
    @$(check_cmd) "$(RM) /etc/update-motd.d/10-help-text"
    @$(check_cmd) "$(RM) /etc/update-motd.d/50-motd-news"

# Final Message
finalize:
	@$(log) "----------------------------------------"
	@$(log) "  Initial setup and optimization complete!"
	@$(log) "  Reboot your system for changes to take effect."
	@$(log) "----------------------------------------"
	$(TOUCH) $(LOG_FILE)


.PHONY: all setup update_packages remove_games install_powersaving_tools configure_tlp install_powertop_systemd_service install_improvements install_commonly_used_applications install_preload cleanup_packages disable_motd finalize
