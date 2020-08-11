title 'Tests to confirm alsa-lib works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'alsa-lib')

control 'core-plans-alsa-lib-works' do
  impact 1.0
  title 'Ensure alsa-lib works as expected'
  desc '
  Verify alsa-lib by ensuring that
  (1) its installation directory exists 
  (2) it returns the expected version
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end
  
  plan_pkg_version = plan_installation_directory.stdout.split("/")[5]
  ["aserver"].each do |binary_name|
    command_full_path = File.join(plan_installation_directory.stdout.strip, "bin", binary_name)
    describe command("#{command_full_path} --help") do
      its('exit_status') { should eq 0 }
      its('stderr') { should_not be_empty }
      its('stderr') { should match /Usage:\s+[^\s]*\s+\[OPTIONS\]\s+server/ }
      its('stdout') { should be_empty }
    end
  end
end