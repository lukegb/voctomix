{ lib
, buildPythonApplication
, nix-gitignore
, python
, hatchling
, pygobject3
, gobject-introspection
, sdnotify
, gst-python
, gst_all_1
, wrapGAppsHook3
, numpy
, scipy
}:

let
  fs = lib.fileset;
in
buildPythonApplication rec {
  pname = "voctomix";
  version = "0.0.1";
  pyproject = true;

  src = nix-gitignore.gitignoreSource [] ./.;

  postPatch = ''
    for bin in voctocore voctogui; do
      substituteInPlace "$bin/$bin.py" \
        --replace-fail "sys.path.insert(0, '.')" "sys.path.insert(0, '$out/${python.sitePackages}/$bin')"
    done
  '';

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  dependencies = [
    pygobject3
    sdnotify

    gst-python
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    numpy
    scipy
  ];
}
