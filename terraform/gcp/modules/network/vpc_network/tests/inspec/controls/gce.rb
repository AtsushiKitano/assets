title 'gce module test'

project = attribute('project')
gce = yaml(content: inspec.profile.file('gce.yaml')).params

control 'gce' do
  gce.each do |gce|
    describe google_compute_disk(project: project["id"], name: gce["name"], zone: gce["zone"]) do
      it {should exist}
      its('source_image') { should match gce["image"] }
    end
    describe google_compute_instance(project: project["id"], zone: gce["zone"], name: gce["name"]) do
      it { should exist }
      its('machine_type') { should match gce["machine_type"] }
      its('tag_count') { should cmp 1 }
      its('tags.items') { should include gce["tag"] }
    end
  end
end
