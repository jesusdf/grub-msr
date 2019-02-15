# For msr.mod.
pkglib_MODULES += msr.mod
msr_mod_SOURCES = commands/msr.c
 
clean-module-msr.mod.1:
        rm -f msr.mod mod-msr.o mod-msr.c pre-msr.o msr_mod-commands_msr.o und-msr.lst
 
CLEAN_MODULE_TARGETS += clean-module-msr.mod.1
 
clean-module-msr.mod-symbol.1:
        rm -f def-msr.lst
 
CLEAN_MODULE_TARGETS += clean-module-msr.mod-symbol.1
DEFSYMFILES += def-msr.lst
mostlyclean-module-msr.mod.1:
        rm -f msr_mod-commands_msr.d
 
MOSTLYCLEAN_MODULE_TARGETS += mostlyclean-module-msr.mod.1
UNDSYMFILES += und-msr.lst
ifneq ($(TARGET_APPLE_CC),1)
msr.mod: pre-msr.o mod-msr.o $(TARGET_OBJ2ELF)
        -rm -f $@
        $(TARGET_CC) $(msr_mod_LDFLAGS) $(TARGET_LDFLAGS) -Wl,-r,-d -o $@ pre-msr.o mod-msr.o
        if test ! -z "$(TARGET_OBJ2ELF)"; then ./$(TARGET_OBJ2ELF) $@ || (rm -f $@; exit 1); fi
        $(STRIP) --strip-unneeded -K grub_mod_init -K grub_mod_fini -K _grub_mod_init -K _grub_mod_fini -R .note -R .comment $@
else
msr.mod: pre-msr.o mod-msr.o $(TARGET_OBJ2ELF)
        -rm -f $@
        -rm -f $@.bin
        $(TARGET_CC) $(msr_mod_LDFLAGS) $(TARGET_LDFLAGS) -Wl,-r,-d -o $@.bin pre-msr.o mod-msr.o
        $(OBJCONV) -f$(TARGET_MODULE_FORMAT) -nr:_grub_mod_init:grub_mod_init -nr:_grub_mod_fini:grub_mod_fini -wd1106 -nu -nd $@.bin $@
        -rm -f $@.bin
endif
 
pre-msr.o: $(msr_mod_DEPENDENCIES) msr_mod-commands_msr.o
        -rm -f $@
        $(TARGET_CC) $(msr_mod_LDFLAGS) $(TARGET_LDFLAGS) -Wl,-r,-d -o $@ msr_mod-commands_msr.o
 
mod-msr.o: mod-msr.c
        $(TARGET_CC) $(TARGET_CPPFLAGS) $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -c -o $@ $<
 
mod-msr.c: $(builddir)/moddep.lst $(srcdir)/genmodsrc.sh
        sh $(srcdir)/genmodsrc.sh 'msr' $< > $@ || (rm -f $@; exit 1)
ifneq ($(TARGET_APPLE_CC),1)
def-msr.lst: pre-msr.o
        $(NM) -g --defined-only -P -p $< | sed 's/^\([^ ]*\).*/\1 msr/' > $@
else
def-msr.lst: pre-msr.o
        $(NM) -g -P -p $< | grep -E '^[a-zA-Z0-9_]* [TDS]'  | sed 's/^\([^ ]*\).*/\1 msr/' > $@
endif
 
und-msr.lst: pre-msr.o
        echo 'msr' > $@
        $(NM) -u -P -p $< | cut -f1 -d' ' >> $@
 
msr_mod-commands_msr.o: commands/msr.c $(commands/msr.c_DEPENDENCIES)
        $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -MD -c -o $@ $<
-include msr_mod-commands_msr.d
 
clean-module-msr_mod-commands_msr-extra.1:
        rm -f cmd-msr_mod-commands_msr.lst fs-msr_mod-commands_msr.lst partmap-msr_mod-commands_msr.lst handler-msr_mod-commands_msr.lst parttool-msr_mod-commands_msr.lst video-msr_mod-commands_msr.lst terminal-msr_mod-commands_msr.lst
 
CLEAN_MODULE_TARGETS += clean-module-msr_mod-commands_msr-extra.1
 
COMMANDFILES += cmd-msr_mod-commands_msr.lst
FSFILES += fs-msr_mod-commands_msr.lst
PARTTOOLFILES += parttool-msr_mod-commands_msr.lst
PARTMAPFILES += partmap-msr_mod-commands_msr.lst
HANDLERFILES += handler-msr_mod-commands_msr.lst
TERMINALFILES += terminal-msr_mod-commands_msr.lst
VIDEOFILES += video-msr_mod-commands_msr.lst
cmd-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) gencmdlist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/gencmdlist.sh msr > $@ || (rm -f $@; exit 1)
 
fs-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genfslist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genfslist.sh msr > $@ || (rm -f $@; exit 1)
 
parttool-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genparttoollist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genparttoollist.sh msr > $@ || (rm -f $@; exit 1)
 
partmap-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genpartmaplist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genpartmaplist.sh msr > $@ || (rm -f $@; exit 1)
 
handler-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genhandlerlist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genhandlerlist.sh msr > $@ || (rm -f $@; exit 1)
 
terminal-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genterminallist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genterminallist.sh msr > $@ || (rm -f $@; exit 1)
 
video-msr_mod-commands_msr.lst: commands/msr.c $(commands/msr.c_DEPENDENCIES) genvideolist.sh
        set -e;           $(TARGET_CC) -Icommands -I$(srcdir)/commands $(TARGET_CPPFLAGS)  $(TARGET_CFLAGS) $(msr_mod_CFLAGS) -E $<         | sh $(srcdir)/genvideolist.sh msr > $@ || (rm -f $@; exit 1)
 
msr_mod_CFLAGS = $(COMMON_CFLAGS)
msr_mod_LDFLAGS = $(COMMON_LDFLAGS)
