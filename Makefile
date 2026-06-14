HOME ?= /tmp
CTWMRC ?= $(HOME)/.ctwmrc
LIBEXECDIR ?= $(HOME)/.local/libexec/ctwm
HELPERS = ctwm_app_menu ctwm_font_path ctwm_font_size ctwm_terminal \
	xdg-terminal-exec

.PHONY: all check install-user

all: check

check:
	@for helper in $(HELPERS); do sh -n "$$helper"; done
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
	@test "$$(CTWM_TERMINAL=missing TERMINAL=missing \
	    sh ./ctwm_terminal --print)" = "$$(command -v xterm)"
	@tmp=$$(mktemp); \
	trap 'rm -f "$$tmp"' EXIT HUP INT TERM; \
	CTWM_LIBEXEC="$(CURDIR)" m4 system.ctwmrc >"$$tmp"; \
	if command -v ctwm >/dev/null 2>&1; then \
		ctwm --cfgchk --nom4 --file "$$tmp"; \
	fi

install-user: check
	@for helper in $(HELPERS); do \
		install -Dm755 "$$helper" "$(LIBEXECDIR)/$$helper"; \
	done
	@if test -e "$(CTWMRC)" && ! cmp -s system.ctwmrc "$(CTWMRC)"; then \
		backup="$(CTWMRC).backup.$$(date +%Y%m%d%H%M%S)"; \
		cp -p "$(CTWMRC)" "$$backup"; \
		printf 'Backed up %s to %s\n' "$(CTWMRC)" "$$backup"; \
	fi
	install -Dm644 system.ctwmrc "$(CTWMRC)"
	@printf 'Installed %s\n' "$(CTWMRC)"
	@printf 'Installed helpers in %s\n' "$(LIBEXECDIR)"
