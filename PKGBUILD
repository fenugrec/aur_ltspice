# Maintainer: Jan-Henrik Bruhn <aur@jhbruhn.de>
# Contributor: Max Stabel <max dot stabel03 at gmail dot com>

pkgname=ltspice
pkgver=24.0.11.20240418.3
pkgrel=2
pkgdesc="SPICE simulator, schematic capture and waveform viewer. Installation based on Field Update Utility."
arch=('x86_64')
url="http://www.linear.com/designtools/software/"
license=('LicenseRef-LTspice')
depends=('wine')
optdepends=('xdg-utils: for launching HTML help files')
makedepends=('gawk'
	'curl'
	'icoutils'
	'imagemagick'
	'gendesk'
	'msitools'
)

source=("${pkgname}.sh"
        "${pkgname}-help.sh"
	"conv.sh"
        "https://ltspice.analog.com/software/LTspice64.msi")
sha256sums=('456c0e6550f8d7ee354aca18f9d421be023b6bcb6afe80d9e8bc558b7d8961a6'
            '3a0fed134c263a7a0573f36c1f4e49d27bea2cca0c098e069e79e1411d3c302e'
            '2dd9f26ac982f0c2fd5d5cdeff921a87f2cf33264152bcfc3ac6f0ea2c5e5f9d'
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

    #tweak mixed-case hyperlinks in help docs
    cd LTspiceHelp
    sh ../conv.sh
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
