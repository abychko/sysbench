# Copyright (C) 2016 Alexey Kopytov <akopytov@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

# ---------------------------------------------------------------------------
# Macro: SB_CONCURRENCY_KIT
# ---------------------------------------------------------------------------
AC_DEFUN([SB_CONCURRENCY_KIT], [

AC_ARG_WITH([system-ck],
  AC_HELP_STRING([--with-system-ck],
  [Use system-provided Concurrency Kit headers and library (requires pkg-config)]),
  [sb_use_ck="system"],
  [sb_use_ck="bundled"])

AC_CACHE_CHECK([whether to build with system or bundled Concurrency Kit],
  [sb_cv_lib_ck], [
    AS_IF([test "x$sb_use_ck" = "xsystem"],
    [
      sb_cv_lib_ck=[system]
    ], [
      sb_cv_lib_ck=[bundled]
    ])
  ])

AS_IF([test "x$sb_cv_lib_ck" = "xsystem"],
  # let PKG_CHECK_MODULES set CK_CFLAGS and CK_LIBS for system libck
  [PKG_CHECK_MODULES([CK], [ck])],
  # Set CK_CFLAGS and CK_LIBS manually for bundled libck
  [
    CK_CFLAGS="-I\$(abs_top_builddir)/third_party/concurrency_kit/include"
    CK_LIBS="\$(abs_top_builddir)/third_party/concurrency_kit/lib/libck.a"
  ]
)

AC_DEFINE_UNQUOTED([SB_WITH_CK], ["$sb_use_ck"],
  [Whether system or bundled Concurrency Ki is used])

AM_CONDITIONAL([USE_BUNDLED_CK], [test "x$sb_use_ck" = xbundled])
])