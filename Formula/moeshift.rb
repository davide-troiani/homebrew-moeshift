class Moeshift < Formula
  desc "Local MoE inference on Apple Silicon with SSD expert streaming"
  homepage "https://github.com/davide-troiani/moeshift"
  url "https://github.com/davide-troiani/moeshift.git",
      tag:      "v0.1.0-alpha.1",
      revision: "6fac70346e893bfb631f4780d0a843549ab666f8"
  license "MIT"
  head "https://github.com/davide-troiani/moeshift.git", branch: "main"

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on "libyaml"
  depends_on :macos
  depends_on "python@3.14"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/f3/49/fee7587c33ee35f7977f9051d7f2023d4e7246d62710c80f20c2361ea232/numpy-2.5.4-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "ffa6ce09a1c6a08e9667dd9c97aa0b14184e8d18f2a14b78b2a2328c9147f076"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/55/6dc6d6bb953bdfc52519a0059592c52b6e3b8ad51cf8256dffceb55b0610/setuptools-84.2.1-py3-none-any.whl"
    sha256 "ca140b45d5325a9478f880e351484f62fef15f336462e449ca0c03c873d589c2"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/8a/7f/e409f76bb955ecdcb746b80350b945fbb808846d797346d647a37e1790ca/cython-3.3.0-cp314-cp314-macosx_11_0_arm64.whl"
    sha256 "0deedc2e9a5a664e1adfa4c2d310aa7b54903e1a647c274b6c9213f77a02d637"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a0/f4/c67b0b3f1b9245e8d266f0f112c500d50e5b4e83cb6f3b71b6528104182a/requests-2.34.2-py3-none-any.whl"
    sha256 "2a0d60c172f83ac6ab31e4554906c0f3b3588d37b5cb939b1c061f4907e278e0"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a7/03/921a3d3c75785aca9ebfbfcabfbc3a1be12e2ab5265deb026d55a5a3f83e/tqdm-4.70.1-py3-none-any.whl"
    sha256 "c293e525e6fef9c20e8728fd4612df02a0aa31bb5fe91ecd93e123b1b7bffa73"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/32/d1/a3652fe2c19134d0d15922177821d863cbd7e842d53a21bbe7e8e3a1b5ac/certifi-2026.10.23-py3-none-any.whl"
    sha256 "e9b54de76e530bb6cf0ccd036787103acb58fd42ba930ea8bf948ddbaa2f61d1"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/fc/ad/d07d7862a62ffa6d79d68074d14823243dd235a77c45262acbf6adeb28bf/charset_normalizer-3.5.2-py3-none-any.whl"
    sha256 "b6b751274acb69d77b3323d6b7dbaa3c7fdfc1eb829b7eb61d262f32e1af9685"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/58/a2/bb081bab032533a855d44de1d56f8e8426114ff1ba5d1f07a438a0a654f8/idna-3.20-py3-none-any.whl"
    sha256 "ab7ae7122974553370f0bdb919e1a960b2cd1bc1ef0276416d896db81c14582c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/92/9d/c4e665119135114480843e7ab388fa94d8480650450e6f8e26b70d323a4c/urllib3-2.8.0-py3-none-any.whl"
    sha256 "0cf3cae568d36aa9576b28dfb35f11328f1cb974ca7647d9475ebb86c75ac6e3"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                   "-DBUILD_SHARED_LIBS=OFF", "-DGGML_METAL=ON",
                   "-DGGML_METAL_EMBED_LIBRARY=ON", "-DGGML_NATIVE=ON",
                   "-DLLAMA_OPENSSL=OFF", "-DLLAMA_BUILD_UI=OFF",
                   "-DLLAMA_BUILD_APP=OFF", "-DLLAMA_BUILD_EXAMPLES=OFF",
                   "-DLLAMA_BUILD_TESTS=OFF"
    system "cmake", "--build", "build", "--target", "moeshift", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build", "--component", "moeshift"

    python = formula_opt_bin("python@3.14")/"python3.14"
    system python, "-m", "venv", libexec
    build_env = buildpath/"pyyaml-build"
    system python, "-m", "venv", build_env
    # Build helpers stay outside the installed runtime environment.
    resources.each do |res|
      next if res.name == "pyyaml"

      wheel = buildpath/"wheels"/File.basename(res.url)
      wheel.dirname.mkpath
      cp res.cached_download, wheel
      target = %w[setuptools cython].include?(res.name) ? build_env : libexec
      system target/"bin/python", "-m", "pip", "install", "--no-index", "--no-deps", wheel
    end
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("libyaml")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("libyaml")}"
    ENV["PYYAML_FORCE_LIBYAML"] = "1"
    resource("pyyaml").stage do
      system build_env/"bin/python", "-m", "pip", "wheel", "--no-index", "--no-deps",
             "--no-build-isolation", "--wheel-dir", buildpath/"pyyaml-wheels", "."
    end
    yaml_wheel = (buildpath/"pyyaml-wheels").glob("*.whl").fetch(0)
    system libexec/"bin/python", "-m", "pip", "install", "--no-index", "--no-deps", yaml_wheel
    system libexec/"bin/python", "-m", "pip", "check"
  end

  def caveats
    <<~EOS
      Start once with:
        moeshift
      The first launch creates ~/.config/moeshift/config.json (or the XDG_CONFIG_HOME path).
      Stop with Ctrl-C, set model and moe-experts paths in that file, then restart.
      Existing configuration is never overwritten.

      Model preparation uses:
        #{opt_libexec}/bin/python #{opt_pkgshare}/tools/moe/experts.py extract --model FILE --out-dir DIR
        #{opt_libexec}/bin/python #{opt_pkgshare}/tools/moe/experts.py verify --model FILE --experts DIR
      Model weights are not included.
    EOS
  end

  test do
    require "json"
    require "net/http"
    require "socket"
    require "timeout"

    python = libexec/"bin/python"
    experts = pkgshare/"tools/moe/experts.py"
    system python, "-c", <<~PYTHON
      import yaml
      assert yaml.__with_libyaml__
      assert yaml.load("ok: true", Loader=yaml.CSafeLoader) == {"ok": True}
    PYTHON
    yaml_extension = shell_output("#{python} -c 'import yaml._yaml; print(yaml._yaml.__file__)'").strip
    assert_match "#{formula_opt_lib("libyaml")}/libyaml", shell_output("otool -L #{yaml_extension}")
    system python, "-c", <<~PYTHON
      import sys
      sys.path.insert(0, #{(pkgshare/"gguf-py").to_s.dump})
      import numpy as np
      from gguf import GGUFWriter
      writer = GGUFWriter("tiny.gguf", "llama")
      writer.add_uint32("llama.expert_count", 2)
      writer.add_uint32("llama.expert_used_count", 1)
      for name in ("ffn_gate_exps", "ffn_up_exps", "ffn_down_exps"):
          writer.add_tensor("blk.0." + name + ".weight", np.arange(2048, dtype=np.float32).reshape(2, 32, 32))
      writer.write_header_to_file()
      writer.write_kv_data_to_file()
      writer.write_tensors_to_file()
      writer.close()
    PYTHON
    system python, experts, "extract", "--model", testpath/"tiny.gguf", "--out-dir", testpath/"experts"
    system python, experts, "verify", "--model", testpath/"tiny.gguf", "--experts", testpath/"experts"
    assert_path_exists testpath/"experts/manifest.json"

    socket = TCPServer.new("127.0.0.1", 0)
    port = socket.addr[1]
    socket.close
    config = testpath/".config/moeshift/config.json"
    expected = JSON.parse((pkgshare/"moeshift.json").read)
    2.times do
      pid = spawn({ "HOME" => testpath.to_s, "XDG_CONFIG_HOME" => (testpath/".config").to_s },
                  bin/"moeshift", "--port", port.to_s, [:out, :err] => (testpath/"server.log").to_s)
      begin
        Timeout.timeout(20) do
          loop do
            begin
              response = Net::HTTP.get_response(URI("http://127.0.0.1:#{port}/health"))
              break if response.code == "200"
            rescue Errno::ECONNREFUSED, EOFError
              nil
            end
            sleep 0.1
          end
        end
        assert_equal expected, JSON.parse(config.read)
        models = JSON.parse(Net::HTTP.get(URI("http://127.0.0.1:#{port}/v1/models")))
        assert_equal expected.fetch("models").keys.sort, models.fetch("data").map { |model| model.fetch("id") }.sort
      ensure
        Process.kill("INT", pid)
        begin
          Timeout.timeout(10) { Process.wait(pid) }
        rescue Timeout::Error
          Process.kill("KILL", pid)
          Process.wait(pid)
        end
      end
      expected["port"] = port
      File.write(config, JSON.pretty_generate(expected))
    end
  end
end
