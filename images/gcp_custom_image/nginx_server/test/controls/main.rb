control 'nginx install' do
  title "nginx vm image"

  describe package('nginx') do
    it { should be_installed }
  end

end
