{stdenv, fetchgit, fetchsvn, autoconf, automake, libtool, gfortran, clang, cmake, gnumake,
hwloc, jre, lapack, blas, hdf5, expat, ncurses, readline, qt4, webkitgtk, which,
lp_solve, omniorb, sqlite, libatomic_ops, pkgconfig, file, gettext, flex, bison,
doxygen, boost, openscenegraph, gnome2, xorg, git, bash, gtk2, makeWrapper }:

let

  fakegit = import ./fakegit.nix {inherit stdenv fetchgit fetchsvn bash;} ;

in

stdenv.mkDerivation {
  name = "openmodelica";

  src = fetchgit (import ./src-main.nix);

  buildInputs = [autoconf cmake automake libtool gfortran clang gnumake
    hwloc jre lapack blas hdf5 expat ncurses readline qt4 webkitgtk which
    lp_solve omniorb sqlite libatomic_ops pkgconfig file gettext flex bison
    doxygen boost openscenegraph gnome2.gtkglext xorg.libXmu
    git gtk2 makeWrapper];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  patchPhase = ''
    cp -fv ${fakegit}/bin/checkout-git.sh libraries/checkout-git.sh
    cp -fv ${fakegit}/bin/checkout-svn.sh libraries/checkout-svn.sh
  '';

  configurePhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${gfortran.cc.lib}/lib"

    autoconf
    ./configure CC=${clang}/bin/clang CXX=${clang}/bin/clang++ --prefix=$out
  '';

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --prefix PATH : "${gnumake}/bin" \
        --prefix LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ lapack blas ]}"
    done
  '';

  meta = with stdenv.lib; {
    description = "An open-source Modelica-based modeling and simulation environment";
    homepage    = "https://openmodelica.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.linux;
    broken      = true;
  };
}
