HOME ?= /tmp
CTWMRC ?= $(HOME)/.ctwmrc
LIBEXECDIR ?= $(HOME)/.local/libexec/ctwm
CONFIGDIR ?= $(HOME)/.config/ctwm
PROFILE ?= $(CONFIGDIR)/profile
XINITRC ?= $(HOME)/.xinitrc
XRESOURCES ?= $(HOME)/.Xresources
THEME ?= netbsd
PLATFORM ?=
HELPERS = ctwm_app_menu ctwm_font_path ctwm_font_size ctwm_terminal \
	ctwm_monitor ctwm_profile ctwm_volume xdg-terminal-exec

.PHONY: all check install-user install-profile install-xresources install-xinit

all: check

check:
	@for helper in $(HELPERS); do sh -n "$$helper"; done
	@sh -n templates/xinitrc
	@test "$$(CTWM_SCREEN_WIDTH=640 CTWM_SCREEN_HEIGHT=480 \
	    CTWM_SCREEN_DPI=96 sh ./ctwm_font_size)" = 12
	@test "$$(CTWM_SCREEN_WIDTH=1920 CTWM_SCREEN_HEIGHT=1080 \
	    CTWM_SCREEN_DPI=96 sh ./ctwm_font_size)" = 16
	@test "$$(CTWM_SCREEN_WIDTH=3840 CTWM_SCREEN_HEIGHT=2160 \
	    CTWM_SCREEN_DPI=200 sh ./ctwm_font_size)" = 24
	@xrandr_output=$$(printf '%s\n' 'Monitors: 1' \
	    ' 0: +*eDP-1 1920/509x1080/286+0+0 eDP-1'); \
	test "$$(CTWM_XRANDR_OUTPUT="$$xrandr_output" \
	    sh ./ctwm_font_size)" = 16
	@test "$$(CTWM_TERMINAL=/bin/sh sh ./ctwm_terminal --print)" = /bin/sh
	@fallback=$$(command -v x-terminal-emulator 2>/dev/null || \
	    command -v xterm 2>/dev/null || command -v uxterm 2>/dev/null); \
	if test -n "$$fallback"; then \
		test "$$(CTWM_TERMINAL=missing TERMINAL=missing \
		    sh ./ctwm_terminal --print)" = "$$fallback"; \
	fi
	@test "$$(CTWM_PLATFORM=freebsd sh ./ctwm_profile --platform)" = freebsd
	@test "$$(CTWM_THEME=acme sh ./ctwm_profile --theme)" = acme
	@set -e; \
	tmp_home=$$(mktemp -d); \
	trap 'rm -rf "$$tmp_home"' EXIT HUP INT TERM; \
	profile="$$tmp_home/profile"; \
	printf 'CTWM_THEME=acme\nCTWM_PLATFORM=freebsd\n' >"$$profile"; \
	test "$$(CTWM_PROFILE="$$profile" sh -c \
	    'unset CTWM_THEME CTWM_PLATFORM; exec sh ./ctwm_profile --theme')" = acme; \
	test "$$(CTWM_PROFILE="$$profile" sh -c \
	    'unset CTWM_THEME CTWM_PLATFORM; exec sh ./ctwm_profile --platform')" = freebsd; \
	test "$$(CTWM_PROFILE="$$profile" CTWM_THEME=netbsd \
	    sh ./ctwm_profile --theme)" = netbsd
	@set -e; \
	for theme in netbsd acme; do \
		for platform in netbsd freebsd openbsd arch debian linux; do \
			tmp=$$(mktemp); \
			CTWM_LIBEXEC="$(CURDIR)" CTWM_THEME="$$theme" \
			    CTWM_PLATFORM="$$platform" m4 system.ctwmrc >"$$tmp"; \
			if command -v ctwm >/dev/null 2>&1; then \
				ctwm --cfgchk --nom4 --file "$$tmp"; \
			fi; \
			rm -f "$$tmp"; \
		done; \
	done

install-user: check
	@mkdir -p "$(LIBEXECDIR)" "$(dir $(CTWMRC))"
	@for helper in $(HELPERS); do \
		install -m 755 "$$helper" "$(LIBEXECDIR)/$$helper"; \
	done
	@if test -e "$(CTWMRC)" && ! cmp -s system.ctwmrc "$(CTWMRC)"; then \
		backup="$(CTWMRC).backup.$$(date +%Y%m%d%H%M%S)"; \
		cp -p "$(CTWMRC)" "$$backup"; \
		printf 'Backed up %s to %s\n' "$(CTWMRC)" "$$backup"; \
	fi
	install -m 644 system.ctwmrc "$(CTWMRC)"
	@printf 'Installed %s\n' "$(CTWMRC)"
	@printf 'Installed helpers in %s\n' "$(LIBEXECDIR)"

install-profile:
	@case "$(THEME)" in netbsd|acme) ;; \
		*) printf 'Unsupported THEME=%s\n' "$(THEME)" >&2; exit 2 ;; \
	esac
	@case "$(PLATFORM)" in ''|netbsd|freebsd|openbsd|arch|debian|linux) ;; \
		*) printf 'Unsupported PLATFORM=%s\n' "$(PLATFORM)" >&2; exit 2 ;; \
	esac
	@mkdir -p "$(CONFIGDIR)"
	@tmp="$(PROFILE).tmp"; \
	{ \
		printf 'CTWM_THEME=%s\n' "$(THEME)"; \
		if test -n "$(PLATFORM)"; then \
			printf 'CTWM_PLATFORM=%s\n' "$(PLATFORM)"; \
		fi; \
	} >"$$tmp"; \
	mv "$$tmp" "$(PROFILE)"
	@printf 'Installed %s\n' "$(PROFILE)"

install-xresources:
	@test -f "themes/$(THEME).Xresources" || { \
		printf 'No Xresources template for THEME=%s\n' "$(THEME)" >&2; \
		exit 2; \
	}
	@mkdir -p "$(dir $(XRESOURCES))"
	@if test -e "$(XRESOURCES)" && \
	    ! cmp -s "themes/$(THEME).Xresources" "$(XRESOURCES)"; then \
		backup="$(XRESOURCES).backup.$$(date +%Y%m%d%H%M%S)"; \
		cp -p "$(XRESOURCES)" "$$backup"; \
		printf 'Backed up %s to %s\n' "$(XRESOURCES)" "$$backup"; \
	fi
	install -m 644 "themes/$(THEME).Xresources" "$(XRESOURCES)"
	@printf 'Installed %s\n' "$(XRESOURCES)"

install-xinit:
	@mkdir -p "$(dir $(XINITRC))"
	@if test -e "$(XINITRC)" && ! cmp -s templates/xinitrc "$(XINITRC)"; then \
		backup="$(XINITRC).backup.$$(date +%Y%m%d%H%M%S)"; \
		cp -p "$(XINITRC)" "$$backup"; \
		printf 'Backed up %s to %s\n' "$(XINITRC)" "$$backup"; \
	fi
	install -m 755 templates/xinitrc "$(XINITRC)"
	@printf 'Installed %s\n' "$(XINITRC)"
