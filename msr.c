/* msr.c - Read or write CPU model specific registers */
/*
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2006, 2007, 2009  Free Software Foundation, Inc.
 *  Based on gcc/gcc/config/i386/driver-i386.c
 *
 *  GRUB is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GRUB is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <grub/dl.h>
#include <grub/misc.h>
#include <grub/mm.h>
#include <grub/env.h>
#include <grub/command.h>
#include <grub/extcmd.h>
#include <grub/i386/msr.h>
#include <grub/i18n.h>

char modname[] __attribute__((section(".modname"))) = "msr";
char moddeps[] __attribute__((section(".moddeps"))) = "extcmd";

GRUB_MOD_LICENSE("GPLv3+");

static const struct grub_arg_option options[] =
{
  {0, 'v', 0, N_("Save read value into variable VARNAME."),
    N_("VARNAME"), ARG_TYPE_STRING},
  {0, 0, 0, 0, 0, 0}
};

static grub_err_t
grub_cmd_msr_read(grub_command_t cmd, int argc, char **argv)
{
  grub_uint64_t addr;
  grub_uint64_t value;
  char buf[sizeof("XXXXXXXX")];

  if (argc != 1)
  {
    return grub_error(GRUB_ERR_BAD_ARGUMENT, N_("one argument expected"));
  }

  addr = grub_strtoul(argv[0], 0, 0);

  value = grub_msr_read(addr);

  if (ctxt->state[0].set)
  {
    grub_snprintf(buf, sizeof(buf), "%x", value);
    grub_env_set(ctxt->state[0].arg, buf);
  }
  else
  {
    grub_printf("0x%x\n", value);
  }

  return GRUB_ERR_NONE;
}

static grub_err_t
grub_cmd_msr_write(grub_command_t cmd, int argc, char **argv)
{
  grub_addr_t addr;
  grub_uint32_t value;

  if (argc != 2)
  {
    return grub_error(GRUB_ERR_BAD_ARGUMENT, N_("two arguments expected"));
  }

  addr = grub_strtoul(argv[0], 0, 0);
  value = grub_strtoul(argv[1], 0, 0);

  grub_msr_write(addr, value);

  return GRUB_ERR_NONE;
}

static grub_extcmd_t cmd_read;
static grub_extcmd_t cmd_write;

GRUB_MOD_INIT(msr)
{
  cmd_read = grub_register_extcmd("rdmsr", grub_cmd_msr_read, 0,
                                  N_("ADDR"),
                                  N_("Read a CPU model specific register."),
                                  options);

  cmd_write = grub_register_extcmd("wrmsr", grub_cmd_msr_write, 0,
                                   N_("ADDR VALUE"),
                                   N_("Write a value to a CPU model specific register."));
}

GRUB_MOD_FINI(msr)
{
  grub_unregister_extcmd(cmd_read);
  grub_unregister_extcmd(cmd_write);
}
