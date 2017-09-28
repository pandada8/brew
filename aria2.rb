class Aria2 < Formula
  desc "Download with resuming and segmented downloading"
  homepage "https://aria2.github.io/"
  url "https://github.com/aria2/aria2/releases/download/release-1.32.0/aria2-1.32.0.tar.xz"
  sha256 "546e9194a9135d665fce572cb93c88f30fb5601d113bfa19951107ced682dc50"

  depends_on "pkg-config" => :build
  depends_on "libssh2" => :optional

  needs :cxx11
  
  patch do
    url "https://aur.archlinux.org/cgit/aur.git/plain/aria2-fast.patch?h=aria2-fast"
    sha256 "c6b84c42259f13c80c1b7d85ef1d783a84cca1b54c79e622c816d8ee86f37d6b"
  end

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    args << "--with-libssh2" if build.with? "libssh2"

    system "./configure", *args
    system "make", "install"

    bash_completion.install "doc/bash_completion/aria2c"
  end

  test do
    system "#{bin}/aria2c", "https://brew.sh/"
    assert File.exist?("index.html"), "Failed to create index.html!"
  end
end
