require 'formula'

class TmuxPatched < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tmux/tmux/tmux-1.9/tmux-1.9a.tar.gz'
  sha256 '815264268e63c6c85fe8784e06a840883fcfc6a2'

  bottle do
    cellar :any
    sha256 "258df085ed5fd3ff4374337294641bd057b81ff4" => :mavericks
    sha256 "3838e790a791d44464df6e7fcd25d8558d864d9c" => :mountain_lion
    sha256 "4368a7f81267c047050758338eb8f4207da12224" => :lion
  end

  head do
    url 'git://git.code.sf.net/p/tmux/tmux-code'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  def patches
    [
      "https://gist.githubusercontent.com/waltarix/1399751/raw/8c5f0018c901f151d39680ef85de6d22649b687a/tmux-ambiguous-width-cjk.patch",
      "https://gist.githubusercontent.com/waltarix/1399751/raw/dc11f40266d9371e730eff41c64a70c84d34484a/tmux-pane-border-ascii.patch"
    ]
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    bash_completion.install "examples/bash_completion_tmux.sh" => 'tmux'
    (share/'tmux').install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{share}/tmux/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
