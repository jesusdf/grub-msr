/*
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2009  Free Software Foundation, Inc.
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

/*
 * Assembly code adapted from:
 *
 *	https://wiki.osdev.org/Inline_Assembly/Examples#RDMSR
 *	https://wiki.osdev.org/Inline_Assembly/Examples#WRMSR 
 *
 * by Jesús Diéguez Fernández
 */

#ifndef GRUB_CPU_MSR_HEADER
#define GRUB_CPU_MSR_HEADER 1

extern unsigned char grub_msr_read;
extern unsigned char grub_msr_write;

#ifdef __x86_64__

static __inline grub_uint64_t
grub_msr_read (grub_uint64_t msr_id)
{
    grub_uint32_t low;
    grub_uint32_t high;
    __asm__ __volatile__ ( "rdmsr"
		: "=a"(low), "=d"(high)
		: "c"(msr)
		);
    return ((grub_uint64_t)high << 32) | low;
}

static __inline void 
grub_msr_write(grub_uint64_t msr, grub_uint64_t value)
{
	grub_uint32_t low = value & 0xFFFFFFFF;
	grub_uint32_t high = value >> 32;
	__asm__ __volatile__ (
		"wrmsr"
		:
		: "c"(msr), "a"(low), "d"(high)
	);
}

#else

static __inline grub_uint64_t
grub_msr_read (grub_uint64_t msr_id)
{
	/* We use uint64 in msr_id just to keep the same function definition as the amd64 version. */
	grub_uint32_t low = msr_id & 0xFFFFFFFF;
    grub_uint64_t msr_value;
    __asm__ __volatile__ ( "rdmsr" : "=A" (msr_value) : "c" (low) );
    return msr_value;
}

static __inline void 
grub_msr_write(grub_uint64_t msr_id, uint64_t msr_value)
{
	/* We use uint64 in msr_id just to keep the same function definition as the amd64 version. */
	grub_uint32_t low = msr_id & 0xFFFFFFFF;
    __asm__ __volatile__ ( "wrmsr" : : "c" (low), "A" (msr_value) );
}

#endif

