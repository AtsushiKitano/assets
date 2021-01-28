control 'nested_vm' do
  title "nested vm image"

  describe package('qemu-kvm') do
    it { should be_installed }
  end

  describe package('uml-utilities') do
    it { should be_installed }
  end

  describe package('bridge-utils') do
    it { should be_installed }
  end


  describe package('virtinst') do
    it { should be_installed }
  end

  describe package('libvirt-daemon-system') do
    it { should be_installed }
  end

  describe package('libvirt-clients') do
    it { should be_installed }
  end

end
