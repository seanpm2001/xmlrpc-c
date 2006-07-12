# -*-makefile-*-    <-- an Emacs control

# The including make file must define these make variables:
#
# SHARED_LIBS_TO_INSTALL: List of the shared libraries that need to be
#   installed -- just the basic library names.  E.g. "libfoo libbar"
#
# SHLIB_SUFFIX: Shared library filename suffix, e.g. "so".
#
# MAJ: Library major version number, e.g. "3" in file name "libfoo.3.1"
#
# MIN: Library minor version number, e.g. "1" in file name "libfoo.3.1"
#
# LDFLAGS_SHLIB: linker (Ld) flags needed to link object files together into
#   a shared library.  May use $(SONAME) for the soname of the library.
#   Include -lc if appropriate.
#
# LADD: Additional linker flags (normally set on the make command line).
#
# INSTALL_DATA: beginning of shell command to install a library file.
#
# DESTDIR: main installation directory
#
# LIBINST_DIR: directory in which to install libraries, relative to DESTDIR.
#
# LN_S: beginning of shell command to make symbolic link (e.g. "ln -s").
#
# CXXLD: beginning of shell command to link, e.g. "g++".

# This make file defines these make variables that the including make file
# can use:
#
# ALL_SHARED_LIBRARIES: list of targets to be dependencies of all: .

# Including make file must contain a rule to build each library file
# (e.g. libfoo.3.1)

# This make file provides these rules:
#
# install-shared-libraries: install all shared libraries and the necessary
# symbolic links.

ALL_SHARED_LIBRARIES = \
  $(SHARED_LIBS_TO_BUILD:%=%.$(SHLIB_SUFFIX).$(MAJ).$(MIN))

# SONAME is to be referenced by $(LDSHLIB) in $(SHLIB_RULE)
# SONAME is the name of the library file being built, with the minor
#   version number cut off.  E.g. if we're building libfoo.so.1.2, SONAME
#   is libfoo.so.1 .
SONAME = $(@:%.$(MIN)=%)

SHLIB_RULE = $(CXXLD) $(LDFLAGS_SHLIB) -o $@ $^ $(LADD)

SHLIB_INSTALL_TARGETS = $(SHARED_LIBS_TO_INSTALL:%=%/install)

#SHLIB_INSTALL_TARGETS is like "install/libfoo install/libbar"

.PHONY: $(SHLIB_INSTALL_TARGETS)
.PHONY: install-shared-libraries

install-shared-libraries: $(SHLIB_INSTALL_TARGETS)

$(SHLIB_INSTALL_TARGETS) X/install:%/install:%.$(SHLIB_SUFFIX).$(MAJ).$(MIN)
# $< is a library file name, e.g. libfoo.3.1 .
	$(INSTALL_SHLIB) $< $(DESTDIR)$(LIBINST_DIR)/$<
	cd $(DESTDIR)$(LIBINST_DIR); \
	  $(LN_S) $< $(<:%.$(MIN)=%)
	cd $(DESTDIR)$(LIBINST_DIR); \
	  $(LN_S) $(<:%.$(MIN)=%) $(<:%.$(MAJ).$(MIN)=%)
