pkgname=smlnj
pkgver=110.77
pkgrel=2
pkgdesc="Standard ML of New Jersey, a compiler for the Standard ML '97 programming language"
url='http://www.smlnj.org/'
license=('BSD')
arch=('x86_64' 'i686')
provides=('sml')
if [ "$CARCH" = "x86_64" ]; then
  makedepends=('gcc-multilib')
  depends=('lib32-glibc')
fi
source=("git://github.com/xyproto/smlnj#tag=v$pkgver")
md5sums=('SKIP')

build() {
  smlnj/build.sh "$srcdir" "$pkgdir"
}

package() {
  install -d "$pkgdir/usr/lib/smlnj" "$pkgdir/etc/profile.d"
  install -Dm755 "$srcdir/$pkgname/profile.d-smlnj.sh" "$pkgdir/etc/profile.d/smlnj.sh"
  cp -R "$srcdir/$pkgname/"{bin,lib} "$pkgdir/usr/lib/smlnj"
}

# vim:set ts=2 sw=2 et:
