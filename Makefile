# Ubuntu 24.4.1 Initial Setup and Optimization Makefile

# Define variables
POWERTOP_SERVICE_PATH := /etc/systemd/system/powertop.service

.PHONY: all install_powertop setup_systemd optimize_system remove_games cleanup update_kernel install_tools improve_security

all: install_powertop setup_systemd optimize_system remove_games install_tools improve_security update_kernel cleanup

install_powertop:
	@echo "Installing powertop..."
	sudo apt update && sudo apt install -y powertop

setup_systemd:
	@echo "Creating systemd service for powertop..."
	sudo bash -c "cat > $(POWERTOP_SERVICE_PATH) << EOF
[Unit]
Description=PowerTOP tunings
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF"
	sudo systemctl daemon-reload
	sudo systemctl enable --now powertop


optimize_system:
	@echo "Applying additional system optimizations..."
	sudo apt install -y tlp tlp-rdw laptop-mode-tools
	sudo systemctl enable --now tlp
	sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

install_tools:
	@echo "Installing essential tools..."
	sudo apt install -y htop neofetch net-tools vim git curl wget

improve_security:
	@echo "Applying security improvements..."
	sudo apt install -y ufw fail2ban
	sudo ufw enable
	sudo systemctl enable --now fail2ban

update_kernel:
	@echo "Updating kernel to the latest version..."
	sudo apt update && sudo apt full-upgrade -y
	sudo apt autoremove --purge -y

remove_games:
	@echo "Removing all unnecessary games..."
	sudo apt purge -y gnome-mahjongg gnome-mines gnome-sudoku aisleriot
	sudo apt autoremove -y

cleanup:
	@echo "Cleaning up system..."
	sudo apt autoclean && sudo apt clean
