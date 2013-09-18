
prefix ?= /usr/local
sysconfdir ?= /etc
datadir ?= $(prefix)/share

AWK ?= gawk

NAME ?= $(shell $(AWK) -F= '/^SELINUXTYPE/{ print $$2 }' $(sysconfdir)/selinux/config)
SHAREDIR ?= $(datadir)/selinux
HEADERDIR ?= $(SHAREDIR)/$(NAME)/include
modpkgdir ?= $(DESTDIR)$(SHAREDIR)/$(strip $(NAME))
hdrpkgdir ?= $(modpkgdir)/include

include $(HEADERDIR)/Makefile

instpkg := $(addprefix $(modpkgdir)/,$(notdir $(all_packages)))
insthdr := $(addprefix $(hdrpkgdir)/,$(notdir $(detected_ifs)))
install: $(instpkg)
install-headers: $(insthdr)

########################################
#
# Install policy packages
#
$(modpkgdir)/%.pp: $(BUILDDIR)%.pp
	@echo "Installing $(NAME) $(@F) policy package."
	@$(INSTALL) -d -m 0755 $(@D)
	$(verbose) $(INSTALL) -m 0644 $^ $(modpkgdir)
$(hdrpkgdir)/%.if: $(BUILDDIR)%.if
	@echo "Installing $(NAME) $(@F) policy interface."
	@$(INSTALL) -d -m 0755 $(@D)
	$(verbose) $(INSTALL) -m 0644 $^ $(hdrpkgdir)
