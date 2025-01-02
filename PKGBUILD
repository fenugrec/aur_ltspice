# Maintainer: Jan-Henrik Bruhn <aur@jhbruhn.de>
# Contributor: Max Stabel <max dot stabel03 at gmail dot com>

pkgname=ltspice
pkgver=24.0.11.20240418.3
pkgrel=1
pkgdesc="SPICE simulator, schematic capture and waveform viewer. Installation based on Field Update Utility."
arch=('x86_64')
url="http://www.linear.com/designtools/software/"
license=('LicenseRef-LTspice')
depends=('wine')
optdepends=('xdg-utils: for launching HTML help files')
makedepends=('curl' 'icoutils' 'imagemagick' 'gendesk' 'msitools')

source=("${pkgname}.sh"
        "${pkgname}-help.sh"
        "https://ltspice.analog.com/software/LTspice64.msi")
sha256sums=('eb49fb2914f752bb3e80a7a754faff0d0eec1e4f4b9156f289aae6d5f2701faa'
            '3a0fed134c263a7a0573f36c1f4e49d27bea2cca0c098e069e79e1411d3c302e'
            '62a9f20b630738e6ade20a37551baa91b20760bfb718807d8a2be4caa3421a36')

OPTIONS=(!strip)

prepare() {
    cd "${srcdir}"

    msiextract LTspice64.msi
    mv -f "APPDIR:."/* .
    mv -f "LocalAppDataFolder/LTspice"/* .
}

build() {
    cd "${srcdir}"

    wrestool -x -t 14 LTspice.exe >${pkgname}.ico
    magick ${pkgname}.ico ${pkgname}.png
    rm ${pkgname}.ico

    gendesk --pkgname "${pkgname}" --pkgdesc "${pkgdesc}" -n --name="LTSpice" --exec="/usr/bin/ltspice" -f
}

package()
{
    cd "${srcdir}"

    # Install License
    install -Dm644 License.txt "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"

    # Install Desktop file
    install -Dm644 "${pkgname}.png" "${pkgdir}/usr/share/pixmaps/${pkgname}.png"
    install -Dm644 "${pkgname}.desktop" "${pkgdir}/usr/share/applications/${pkgname}.desktop"

    # Install docs to /usr/share/doc/
    install -m755 -d "${pkgdir}/usr/share/doc/${pkgname}"
    cp -r LTspiceHelp/* "${pkgdir}/usr/share/doc/${pkgname}"

    # Install binary files to /opt
    install -m755 -d "${pkgdir}/opt/${pkgname}"
    install -m755 *.exe "${pkgdir}/opt/${pkgname}"
    install -m644 *.zip "${pkgdir}/opt/${pkgname}"
    install -m644 LTspice.json "${pkgdir}/opt/${pkgname}"
    install -m644 ChangeLog.txt "${pkgdir}/opt/${pkgname}"

    # symlink help files
    ln -sv "/usr/share/doc/${pkgname}" "${pkgdir}/opt/${pkgname}/LTspiceHelp"

    # Install /usr/bin startscript
    install -Dm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/${pkgname}"
    install -Dm755 "${srcdir}/${pkgname}-help.sh" "${pkgdir}/usr/bin/${pkgname}-help"
}

pkgver() {
    cd "${srcdir}"

    # program
    ver=$(grep LTspice64.msi LTspice.json -A1 | grep -i version | grep -oP '\d+\.\d+\.\d+')

    # data
    date=$(head -n1 ChangeLog.txt | awk '{print $1}')
    count=$(grep -c "$date" ChangeLog.txt)
    date_format=$(echo $date | awk -F/ '{print "20"$3$1$2}')

    echo "$ver.$date_format.$count"
}
