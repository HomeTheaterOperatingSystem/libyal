dnl Functions for libmapidb
dnl
dnl Version: 20120414

dnl Function to detect if libmapidb is available
AC_DEFUN([AX_LIBMAPIDB_CHECK_LIB],
 [dnl Check if parameters were provided
 AS_IF(
  [test "x$ac_cv_with_libmapidb" != x && test "x$ac_cv_with_libmapidb" != xno && test "x$ac_cv_with_libmapidb" != xauto-detect],
  [AS_IF(
   [test -d "$ac_cv_with_libmapidb"],
   [CFLAGS="$CFLAGS -I${ac_cv_with_libmapidb}/include"
   LDFLAGS="$LDFLAGS -L${ac_cv_with_libmapidb}/lib"],
   [AC_MSG_WARN([no such directory: $ac_cv_with_libmapidb])
   ])
  ])

 AS_IF(
  [test "x$ac_cv_with_libmapidb" = xno],
  [ac_cv_libmapidb=no],
  [dnl Check for headers
  AC_CHECK_HEADERS([libmapidb.h])

  AS_IF(
   [test "x$ac_cv_header_libmapidb_h" = xno],
   [ac_cv_libmapidb=no],
   [ac_cv_libmapidb=yes
   AC_CHECK_LIB(
    fdatetime,
    libmapidb_get_version,
    [],
    [ac_cv_libmapidb=no])

   dnl TODO add functions
   ])
  ])

 AS_IF(
  [test "x$ac_cv_libmapidb" = xyes],
  [AC_DEFINE(
   [HAVE_LIBMAPIDB],
   [1],
   [Define to 1 if you have the `mapidb' library (-lmapidb).])

  ac_cv_libmapidb_LIBADD="-lmapidb"
  ])

 AS_IF(
  [test "x$ac_cv_libmapidb" = xyes],
  [AC_SUBST(
   [HAVE_LIBMAPIDB],
   [1]) ],
  [AC_SUBST(
   [HAVE_LIBMAPIDB],
   [0])
  ])
 ])

dnl Function to detect how to enable libmapidb
AC_DEFUN([AX_LIBMAPIDB_CHECK_ENABLE],
 [AX_COMMON_ARG_WITH(
  [libmapidb],
  [libmapidb],
  [search for libmapidb in includedir and libdir or in the specified DIR, or no if to use local version],
  [auto-detect],
  [DIR])

 dnl Check for a pkg-config file
 AS_IF(
  [test "x$cross_compiling" != "xyes" && test "x$PKGCONFIG" != "x"],
  [PKG_CHECK_MODULES(
   [libmapidb],
   [libmapidb >= 20120405],
   [ac_cv_libmapidb=yes],
   [ac_cv_libmapidb=no])

  ac_cv_libmapidb_CPPFLAGS="$pkg_cv_libmapidb_CFLAGS"
  ac_cv_libmapidb_LIBADD="$pkg_cv_libmapidb_LIBS"
 ])

 dnl Check for a shared library version
 AS_IF(
  [test "x$ac_cv_libmapidb" != xyes],
  [AX_LIBMAPIDB_CHECK_LIB])

 dnl Check if the dependencies for the local library version
 AS_IF(
  [test "x$ac_cv_libmapidb" != xyes],
  [ac_cv_libmapidb_CPPFLAGS="-I../libmapidb";
  ac_cv_libmapidb_LIBADD="../libmapidb/libmapidb.la";

  ac_cv_libmapidb=local

  AC_DEFINE(
   [HAVE_LOCAL_LIBMAPIDB],
   [1],
   [Define to 1 if the local version of libmapidb is used.])
  AC_SUBST(
   [HAVE_LOCAL_LIBMAPIDB],
   [1])
  ])

 AM_CONDITIONAL(
  [HAVE_LOCAL_LIBMAPIDB],
  [test "x$ac_cv_libmapidb" = xlocal])
 AS_IF(
  [test "x$ac_cv_libmapidb_CPPFLAGS" != "x"],
  [AC_SUBST(
   [LIBMAPIDB_CPPFLAGS],
   [$ac_cv_libmapidb_CPPFLAGS])
  ])
 AS_IF(
  [test "x$ac_cv_libmapidb_LIBADD" != "x"],
  [AC_SUBST(
   [LIBMAPIDB_LIBADD],
   [$ac_cv_libmapidb_LIBADD])
  ])

 AS_IF(
  [test "x$ac_cv_libmapidb" = xyes],
  [AC_SUBST(
   [ax_libmapidb_pc_libs_private],
   [-lmapidb])
  ])

 AS_IF(
  [test "x$ac_cv_libmapidb" = xyes],
  [AC_SUBST(
   [ax_libmapidb_spec_requires],
   [libmapidb])
  AC_SUBST(
   [ax_libmapidb_spec_build_requires],
   [libmapidb-devel])
  ])
 ])

